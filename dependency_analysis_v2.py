#!/usr/bin/env python3
"""
Comprehensive SKILL project dependency analysis
"""

import os
import re
import glob
from collections import defaultdict, deque

def parse_ineed_calls(file_path):
    """Parse a file and extract all ineed() function calls"""
    dependencies = []
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        # Pattern to match ineed calls - handles both single and list formats
        patterns = [
            r"ineed\s*\(\s*'([a-zA-Z_][a-zA-Z0-9_]*)\s*\)",  # Single function
            r"ineed\s*\(\s*'\s*\(\s*([^)]+)\s*\)\s*\)"       # List of functions
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content, re.MULTILINE)
            for match in matches:
                if ' ' in match:  # List format
                    # Split on whitespace and clean up
                    funcs = [f.strip() for f in match.split() if f.strip()]
                    dependencies.extend(funcs)
                else:  # Single function
                    dependencies.append(match)
                    
    except Exception as e:
        print(f"Error parsing {file_path}: {e}")
        
    return dependencies

def find_all_skill_files():
    """Find all .il files in the project"""
    il_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.il'):
                il_files.append(os.path.join(root, file))
    return il_files

def build_comprehensive_analysis():
    """Build comprehensive dependency analysis"""
    
    # Find all files and extract their base names (potential function names)
    all_files = find_all_skill_files()
    existing_functions = set()
    file_to_function = {}
    
    for file_path in all_files:
        base_name = os.path.basename(file_path).replace('.il', '')
        existing_functions.add(base_name)
        file_to_function[base_name] = file_path
    
    # Build dependency graph
    dependency_graph = defaultdict(set)
    files_with_deps = {}
    
    for file_path in all_files:
        func_name = os.path.basename(file_path).replace('.il', '')
        deps = parse_ineed_calls(file_path)
        
        if deps:
            dependency_graph[func_name] = set(deps)
            files_with_deps[func_name] = file_path
    
    return dependency_graph, existing_functions, files_with_deps, file_to_function

def find_circular_dependencies(graph):
    """Find circular dependencies using DFS"""
    visiting = set()
    visited = set()
    cycles = []
    
    def dfs(node, path):
        if node in visiting:
            cycle_start = path.index(node)
            cycle = path[cycle_start:] + [node]
            cycles.append(cycle)
            return
            
        if node in visited:
            return
            
        visiting.add(node)
        
        for neighbor in graph.get(node, []):
            dfs(neighbor, path + [node])
            
        visiting.remove(node)
        visited.add(node)
    
    for node in graph:
        if node not in visited:
            dfs(node, [])
            
    return cycles

def analyze_loading_order(graph, existing_funcs):
    """Determine optimal loading order"""
    # Functions that exist and have dependencies
    graph_existing = {k: v for k, v in graph.items() if k in existing_funcs}
    
    # Calculate in-degree for topological sort
    in_degree = defaultdict(int)
    all_nodes = set(graph_existing.keys())
    
    for node in graph_existing:
        for dep in graph_existing[node]:
            if dep in existing_funcs:  # Only count existing dependencies
                in_degree[dep] += 1
                all_nodes.add(dep)
    
    # Topological sort
    queue = deque([node for node in all_nodes if in_degree[node] == 0])
    result = []
    
    while queue:
        node = queue.popleft()
        result.append(node)
        
        for dep in graph_existing.get(node, []):
            if dep in existing_funcs:
                in_degree[dep] -= 1
                if in_degree[dep] == 0:
                    queue.append(dep)
    
    return result

def main():
    print("COMPREHENSIVE SKILL PROJECT DEPENDENCY ANALYSIS")
    print("=" * 60)
    
    graph, existing_funcs, files_with_deps, file_map = build_comprehensive_analysis()
    
    print(f"\nProject Statistics:")
    print(f"  Total .il files found: {len(existing_funcs)}")
    print(f"  Files with dependencies: {len(files_with_deps)}")
    print(f"  Total dependency relationships: {sum(len(deps) for deps in graph.values())}")
    
    # Analyze core functions (most depended upon)
    dependency_count = defaultdict(int)
    for func, deps in graph.items():
        for dep in deps:
            dependency_count[dep] += 1
    
    print(f"\n1. CORE FUNCTIONS (Most depended upon):")
    print("-" * 50)
    core_functions = sorted(dependency_count.items(), key=lambda x: x[1], reverse=True)
    
    for func, count in core_functions[:15]:
        status = "✓ EXISTS" if func in existing_funcs else "✗ MISSING"
        file_path = file_map.get(func, "N/A")
        print(f"  {func:<25} ({count:2d} deps) {status}")
        if func in existing_funcs and file_path != "N/A":
            print(f"    └─ {file_path}")
    
    # Missing functions analysis
    all_referenced = set()
    for deps in graph.values():
        all_referenced.update(deps)
    
    missing_funcs = all_referenced - existing_funcs
    
    print(f"\n2. MISSING DEPENDENCIES ({len(missing_funcs)} total):")
    print("-" * 50)
    
    # Group missing functions by how many files depend on them
    missing_by_usage = defaultdict(list)
    for func in missing_funcs:
        count = dependency_count[func]
        missing_by_usage[count].append(func)
    
    for count in sorted(missing_by_usage.keys(), reverse=True):
        if count > 0:
            print(f"  Used by {count} files:")
            for func in sorted(missing_by_usage[count]):
                print(f"    - {func}")
    
    if 0 in missing_by_usage:
        print(f"  Referenced once:")
        for func in sorted(missing_by_usage[0])[:10]:  # Show first 10
            print(f"    - {func}")
        if len(missing_by_usage[0]) > 10:
            print(f"    ... and {len(missing_by_usage[0]) - 10} more")
    
    # Circular dependencies
    print(f"\n3. CIRCULAR DEPENDENCIES:")
    print("-" * 50)
    cycles = find_circular_dependencies(graph)
    if cycles:
        for i, cycle in enumerate(cycles, 1):
            print(f"  Cycle {i}: {' → '.join(cycle)}")
            print(f"    Problem: These functions depend on each other")
    else:
        print("  ✓ No circular dependencies found!")
    
    # Loading order analysis
    print(f"\n4. RECOMMENDED LOADING ORDER:")
    print("-" * 50)
    
    load_order = analyze_loading_order(graph, existing_funcs)
    
    # Core infrastructure (should be loaded first)
    core_infra = [func for func, count in core_functions[:10] if func in existing_funcs]
    
    print("  Phase 1 - Core Infrastructure:")
    for func in core_infra[:5]:
        print(f"    {func}")
    
    print("\n  Phase 2 - Utility Functions:")
    utility_funcs = [f for f in load_order if f in existing_funcs and f not in core_infra]
    for func in utility_funcs[:10]:
        deps_count = len(graph.get(func, []))
        print(f"    {func} ({deps_count} dependencies)")
    
    print("\n  Phase 3 - High-level Functions:")
    high_level = [f for f in load_order if f in existing_funcs and len(graph.get(f, [])) > 3]
    for func in high_level[:5]:
        deps_count = len(graph.get(func, []))
        print(f"    {func} ({deps_count} dependencies)")
    
    # Problematic dependencies
    print(f"\n5. DEPENDENCY ISSUES:")
    print("-" * 50)
    
    issues = []
    
    # Functions that depend on missing functions
    functions_with_missing_deps = {}
    for func, deps in graph.items():
        missing_deps = deps - existing_funcs
        if missing_deps and func in existing_funcs:
            functions_with_missing_deps[func] = missing_deps
    
    if functions_with_missing_deps:
        print("  Functions with missing dependencies:")
        for func, missing_deps in sorted(functions_with_missing_deps.items()):
            print(f"    {func} → missing: {', '.join(sorted(missing_deps))}")
    
    # Self-referential dependencies
    self_refs = [func for func, deps in graph.items() if func in deps]
    if self_refs:
        print(f"\n  Self-referential functions (possible errors):")
        for func in self_refs:
            print(f"    {func}")
    
    print(f"\n6. RECOMMENDATIONS:")
    print("-" * 50)
    print("  1. Fix circular dependencies:")
    for cycle in cycles:
        print(f"     - Refactor: {' → '.join(cycle)}")
    
    print("  2. Create missing critical functions:")
    critical_missing = [func for func, count in core_functions[:5] if func not in existing_funcs]
    for func in critical_missing:
        print(f"     - {func} (needed by {dependency_count[func]} files)")
    
    print("  3. Optimize loading in menu.il:")
    print("     - Load core infrastructure first")
    print("     - Use ineed() for on-demand loading")
    print("     - Consider lazy loading for heavy functions")
    
    print(f"\n7. CURRENT MENU.IL INTEGRATION:")
    print("-" * 50)
    
    # Check what's currently loaded by menu.il
    try:
        with open('menu.il', 'r') as f:
            menu_content = f.read()
            
        # Extract functions loaded in menu.il
        menu_loads = re.findall(r'ineed\s*\(\s*\'?\(?([^)]+)\)?\s*\)', menu_content)
        menu_functions = set()
        for match in menu_loads:
            if ' ' in match:
                menu_functions.update(match.split())
            else:
                menu_functions.add(match)
        
        print(f"  Functions loaded by menu.il: {len(menu_functions)}")
        for func in sorted(menu_functions):
            status = "✓" if func in existing_funcs else "✗"
            print(f"    {status} {func}")
            
    except FileNotFoundError:
        print("  menu.il not found in current directory")

if __name__ == "__main__":
    # Change to the project directory
    os.chdir("/Users/dean/Documents/git/skill-gh")
    main()