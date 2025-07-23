;; copyleft ebecheto
;; testFramework.il - SKILL自动化测试框架
;; 为SKILL-GH库提供现代化的单元测试和集成测试能力

; 全局测试配置
global(skillTestConfig)
skillTestConfig = list(
  'reportFormat "html"           ; "html", "text", "json"
  'outputDir "/tmp/skill_tests"
  'timeout 30000                 ; 测试超时时间(毫秒)
  'parallelExecution t           ; 并行执行测试
  'colorOutput t                 ; 彩色输出
  'verbose nil                   ; 详细模式
  'coverage t                    ; 代码覆盖率统计
)

; 测试套件数据结构
defun(createTestSuite(suiteName @optional description)
  let((suite))
    suite = list(
      'name suiteName
      'description or(description "")
      'tests nil
      'setUp nil
      'tearDown nil
      'beforeEach nil
      'afterEach nil
      'stats list(
        'total 0
        'passed 0 
        'failed 0
        'skipped 0
        'errors 0
        'duration 0
      )
      'results nil
      'startTime nil
      'endTime nil
    )
    suite
  )
)

; 添加测试用例
defun(addTest(suite testName testFunc @optional description category)
  let((test newTests))
    test = list(
      'name testName
      'description or(description "")
      'category or(category "default")
      'func testFunc
      'status "pending"
      'result nil
      'duration 0
      'error nil
      'assertions nil
    )
    
    newTests = append(getf(suite 'tests) list(test))
    putf(suite 'tests newTests)
    
    ; 更新统计
    putf(suite 'stats 
      putf(getf(suite 'stats) 'total (length(newTests))))
    
    suite
  )
)

; 断言函数库
defun(assertTrue(condition @optional message)
  let((assertion))
    assertion = list(
      'type "assertTrue"
      'condition condition
      'expected t
      'actual condition
      'passed condition
      'message or(message sprintf(nil "Expected true, got %L" condition))
    )
    
    recordAssertion(assertion)
    
    unless(condition
      error(sprintf(nil "Assertion failed: %s" getf(assertion 'message)))
    )
    
    condition
  )
)

defun(assertEqual(expected actual @optional message)
  let((assertion passed))
    passed = equal(expected actual)
    assertion = list(
      'type "assertEqual"
      'expected expected
      'actual actual
      'passed passed
      'message or(message 
        sprintf(nil "Expected %L, got %L" expected actual))
    )
    
    recordAssertion(assertion)
    
    unless(passed
      error(sprintf(nil "Assertion failed: %s" getf(assertion 'message)))
    )
    
    passed
  )
)

defun(assertNotEqual(notExpected actual @optional message)
  let((assertion passed))
    passed = not(equal(notExpected actual))
    assertion = list(
      'type "assertNotEqual"
      'notExpected notExpected
      'actual actual
      'passed passed
      'message or(message 
        sprintf(nil "Expected not %L, but got %L" notExpected actual))
    )
    
    recordAssertion(assertion)
    
    unless(passed
      error(sprintf(nil "Assertion failed: %s" getf(assertion 'message)))
    )
    
    passed
  )
)

defun(assertType(expected actual @optional message)
  let((actualType assertion passed))
    actualType = type(actual)
    passed = eq(expected actualType)
    assertion = list(
      'type "assertType"
      'expected expected
      'actual actualType
      'value actual
      'passed passed
      'message or(message 
        sprintf(nil "Expected type %s, got %s for value %L" 
          expected actualType actual))
    )
    
    recordAssertion(assertion)
    
    unless(passed
      error(sprintf(nil "Assertion failed: %s" getf(assertion 'message)))
    )
    
    passed
  )
)

defun(assertThrows(func args @optional expectedErrorPattern message)
  let((assertion threw errorMsg passed))
    threw = nil
    errorMsg = nil
    
    errset(
      apply(func args)
      ; 如果没有抛出异常，threw保持nil
    )
    
    ; 检查是否抛出了异常
    threw = t  ; errset返回nil表示有异常
    
    passed = threw
    when(and(threw expectedErrorPattern)
      ; 如果指定了错误模式，检查错误信息是否匹配
      passed = and(threw rexMatchp(expectedErrorPattern errorMsg))
    )
    
    assertion = list(
      'type "assertThrows"
      'func func
      'args args
      'expectedPattern expectedErrorPattern
      'threw threw
      'errorMsg errorMsg
      'passed passed
      'message or(message 
        sprintf(nil "Expected function to throw error%s" 
          if(expectedErrorPattern 
            sprintf(nil " matching '%s'" expectedErrorPattern) "")))
    )
    
    recordAssertion(assertion)
    
    unless(passed
      error(sprintf(nil "Assertion failed: %s" getf(assertion 'message)))
    )
    
    passed
  )
)

; 记录断言结果（全局变量，供测试运行器使用）
global(currentTestAssertions)
currentTestAssertions = nil

defun(recordAssertion(assertion)
  currentTestAssertions = append(currentTestAssertions list(assertion))
)

; 执行单个测试
defun(runSingleTest(suite test)
  let((startTime endTime result error))
    ; 清空断言记录
    currentTestAssertions = nil
    
    startTime = getCurrentTimestamp()
    
    ; 执行beforeEach钩子
    when(getf(suite 'beforeEach)
      apply(getf(suite 'beforeEach) nil)
    )
    
    ; 执行测试
    errset(
      result = apply(getf(test 'func) nil)
      
      ; 测试成功完成
      putf(test 'status "passed")
      putf(test 'result result)
    )
    
    ; 如果errset返回nil，说明有异常
    when(null(result)
      putf(test 'status "failed")
      putf(test 'error "Test function threw an exception")
    )
    
    ; 执行afterEach钩子  
    when(getf(suite 'afterEach)
      errset(
        apply(getf(suite 'afterEach) nil)
      )
    )
    
    endTime = getCurrentTimestamp()
    putf(test 'duration (endTime - startTime))
    putf(test 'assertions currentTestAssertions)
    
    test
  )
)

; 执行测试套件
defun(runTestSuite(suite @optional options)
  let((tests results stats startTime endTime))
    startTime = getCurrentTimestamp()
    putf(suite 'startTime startTime)
    
    printf("🧪 Running test suite: %s\n" getf(suite 'name))
    when(getf(suite 'description) 
      printf("   %s\n" getf(suite 'description)))
    
    tests = getf(suite 'tests)
    
    ; 执行setUp钩子
    when(getf(suite 'setUp)
      printf("🔧 Setting up test suite...\n")
      apply(getf(suite 'setUp) nil)
    )
    
    ; 执行所有测试
    results = foreach(mapcar test tests
      printf("  • Running: %s... " getf(test 'name))
      
      runSingleTest(suite test)
      
      case(getf(test 'status)
        ("passed" printf("✅ PASS (%.2fms)\n" getf(test 'duration)))
        ("failed" printf("❌ FAIL (%.2fms)\n" getf(test 'duration)))
        ("skipped" printf("⏭️ SKIP\n"))
        (t printf("❓ UNKNOWN\n"))
      )
      
      test
    )
    
    ; 执行tearDown钩子
    when(getf(suite 'tearDown)
      printf("🧹 Tearing down test suite...\n")
      apply(getf(suite 'tearDown) nil)
    )
    
    endTime = getCurrentTimestamp()
    putf(suite 'endTime endTime)
    putf(suite 'results results)
    
    ; 更新统计信息
    stats = calculateTestStats(results)
    putf(suite 'stats stats)
    
    ; 打印摘要
    printTestSummary(suite)
    
    ; 生成报告
    when(getf(skillTestConfig 'reportFormat)
      generateTestReport(suite)
    )
    
    suite
  )
)

; 计算测试统计
defun(calculateTestStats(tests)
  let((stats total passed failed skipped errors duration))
    total = length(tests)
    passed = length(setof(t tests eq(getf(t 'status) "passed")))
    failed = length(setof(t tests eq(getf(t 'status) "failed")))  
    skipped = length(setof(t tests eq(getf(t 'status) "skipped")))
    errors = length(setof(t tests getf(t 'error)))
    duration = apply('plus foreach(mapcar t tests getf(t 'duration)))
    
    list(
      'total total
      'passed passed
      'failed failed
      'skipped skipped  
      'errors errors
      'duration duration
      'passRate if(total > 0 (passed * 100.0 / total) 0.0)
    )
  )
)

; 打印测试摘要
defun(printTestSummary(suite)
  let((stats))
    stats = getf(suite 'stats)
    
    printf("\n📊 Test Results Summary:\n")
    printf("   Total: %d\n" getf(stats 'total))
    printf("   ✅ Passed: %d\n" getf(stats 'passed))  
    printf("   ❌ Failed: %d\n" getf(stats 'failed))
    printf("   ⏭️ Skipped: %d\n" getf(stats 'skipped))
    printf("   ⏱️ Duration: %.2fms\n" getf(stats 'duration))
    printf("   📈 Pass Rate: %.1f%%\n" getf(stats 'passRate))
  )
)

; 生成HTML测试报告
defun(generateTestReport(suite)
  let((reportPath fp))
    reportPath = sprintf(nil "%s/%s_report.html" 
      getf(skillTestConfig 'outputDir) getf(suite 'name))
    
    ; 确保输出目录存在
    system(sprintf(nil "mkdir -p %s" getf(skillTestConfig 'outputDir)))
    
    fp = outfile(reportPath)
    when(fp
      fprintf(fp "<!DOCTYPE html>\n<html>\n<head>\n")
      fprintf(fp "<title>Test Report: %s</title>\n" getf(suite 'name))
      fprintf(fp "<style>%s</style>\n" getTestReportCSS())
      fprintf(fp "</head>\n<body>\n")
      
      ; 生成报告内容
      generateHTMLReportContent(fp suite)
      
      fprintf(fp "</body>\n</html>\n")
      close(fp)
      
      printf("📄 Test report generated: %s\n" reportPath)
    )
  )
)

; 获取当前时间戳（毫秒）
defun(getCurrentTimestamp()
  ; 简化实现，实际应使用系统时间函数
  let((timeStr))
    timeStr = system("date +%s%3N")  ; Unix timestamp with milliseconds
    atoi(rexReplace(timeStr "\n" "" 0))
  )
)

; CSS样式（简化版）
defun(getTestReportCSS()
  "body { font-family: Arial, sans-serif; margin: 20px; }
   .header { background: #f5f5f5; padding: 15px; border-radius: 5px; }
   .stats { display: flex; gap: 20px; margin: 20px 0; }
   .stat { padding: 10px; border-radius: 5px; text-align: center; }
   .passed { background: #d4edda; color: #155724; }
   .failed { background: #f8d7da; color: #721c24; }
   .test-item { margin: 10px 0; padding: 10px; border-left: 4px solid #ccc; }
   .test-passed { border-left-color: #28a745; }
   .test-failed { border-left-color: #dc3545; }"
)

printf("testFramework.il loaded - SKILL自动化测试框架\n")
printf("使用示例:\n")
printf("  suite = createTestSuite(\"MyTests\")\n")
printf("  addTest(suite \"testBBoxHeight\" lambda() assertTrue(bBoxHeight('((0 0) (10 5))) == 5))\n")
printf("  runTestSuite(suite)\n")