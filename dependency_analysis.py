#!/usr/bin/env python3
"""
Analyze SKILL project dependencies by parsing ineed() calls
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
        # ineed('functionName) or ineed('(func1 func2 func3))
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

def build_dependency_graph():
    """Build complete dependency graph from all .il files"""
    dependency_graph = defaultdict(set)
    file_functions = {}
    
    # Find all .il files recursively
    il_files = glob.glob("*.il") + glob.glob("ab/*.il") + glob.glob("PICMIC/*.il") + glob.glob("example/*.il")
    
    for file_path in il_files:
        # Extract function name from filename (without .il extension)
        base_name = os.path.basename(file_path)
        func_name = base_name.replace('.il', '')
        
        # Parse dependencies
        deps = parse_ineed_calls(file_path)
        
        if deps:
            dependency_graph[func_name] = set(deps)
            file_functions[func_name] = file_path
            
    return dependency_graph, file_functions

def find_circular_dependencies(graph):
    """Find circular dependencies using DFS"""
    visiting = set()
    visited = set()
    cycles = []
    
    def dfs(node, path):
        if node in visiting:
            # Found a cycle
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

def find_core_functions(graph):
    """Find functions that are most depended upon"""
    dependency_count = defaultdict(int)
    
    for func, deps in graph.items():
        for dep in deps:
            dependency_count[dep] += 1
            
    # Sort by dependency count
    core_functions = sorted(dependency_count.items(), key=lambda x: x[1], reverse=True)
    return core_functions

def find_standalone_functions(graph):
    """Find functions with no dependencies"""
    all_functions = set(graph.keys())
    all_deps = set()
    for deps in graph.values():
        all_deps.update(deps)
        
    standalone = []
    for func in all_functions:
        if not graph.get(func, set()):
            standalone.append(func)
            
    return standalone

def topological_sort(graph):
    """Return topological sort order (loading order)"""
    in_degree = defaultdict(int)
    all_nodes = set(graph.keys())
    
    # Calculate in-degrees
    for node in graph:
        for dep in graph[node]:
            in_degree[dep] += 1
            all_nodes.add(dep)
    
    # Initialize queue with nodes that have no dependencies
    queue = deque([node for node in all_nodes if in_degree[node] == 0])
    result = []
    
    while queue:
        node = queue.popleft()
        result.append(node)
        
        # Remove this node from graph and update in-degrees
        for dep in graph.get(node, []):
            in_degree[dep] -= 1
            if in_degree[dep] == 0:
                queue.append(dep)
                
    return result

def analyze_dependencies():
    """Main analysis function"""
    print("SKILL Project Dependency Analysis")
    print("=" * 50)
    
    graph, file_map = build_dependency_graph()
    
    print(f"\nTotal files with dependencies: {len(graph)}")
    print(f"Total unique functions referenced: {len(set().union(*graph.values()))}")
    
    # Core functions analysis
    print("\n1. CORE FUNCTIONS (Most depended upon):")
    print("-" * 40)
    core_funcs = find_core_functions(graph)
    for func, count in core_funcs[:15]:  # Top 15
        print(f"  {func:<25} ({count} dependencies)")
    
    # Standalone functions
    print("\n2. STANDALONE FUNCTIONS (No dependencies):")
    print("-" * 40)
    standalone = find_standalone_functions(graph)
    for func in standalone[:20]:  # Show first 20
        print(f"  {func}")
    
    if len(standalone) > 20:
        print(f"  ... and {len(standalone) - 20} more")
    
    # Circular dependencies
    print("\n3. CIRCULAR DEPENDENCIES:")
    print("-" * 40)
    cycles = find_circular_dependencies(graph)
    if cycles:
        for i, cycle in enumerate(cycles, 1):
            print(f"  Cycle {i}: {' -> '.join(cycle)}")
    else:
        print("  No circular dependencies found!")
    
    # Missing dependencies
    print("\n4. MISSING DEPENDENCIES:")
    print("-" * 40)
    all_defined = set(graph.keys())
    all_referenced = set().union(*graph.values()) if graph.values() else set()
    missing = all_referenced - all_defined
    
    for func in sorted(missing):
        print(f"  {func} (referenced but not defined)")
    
    # Loading order suggestion
    print("\n5. SUGGESTED LOADING ORDER:")
    print("-" * 40)
    load_order = topological_sort(graph)
    
    print("Core functions to load first:")
    core_func_names = {func for func, _ in core_funcs[:10]}
    for func in load_order:
        if func in core_func_names and func in all_defined:
            print(f"  {func}")
    
    # Detailed dependency chains for key functions
    print("\n6. DEPENDENCY CHAINS FOR KEY FUNCTIONS:")
    print("-" * 40)
    key_functions = ['addCell', 'angleBox', 'generateAllPins', 'schematic2symbol', 'terminal2pin']
    
    def print_deps(func, level=0, visited=None):
        if visited is None:
            visited = set()
        if func in visited or level > 3:  # Prevent infinite recursion
            return
        visited.add(func)
        
        indent = "  " * level
        deps = graph.get(func, set())
        if deps:
            print(f"{indent}{func} depends on:")
            for dep in sorted(deps):
                print(f"{indent}  - {dep}")
                print_deps(dep, level + 1, visited.copy())
        else:
            print(f"{indent}{func} (no dependencies)")
    
    for func in key_functions:
        if func in graph:
            print(f"\n{func}:")
            print_deps(func)

if __name__ == "__main__":
    # Change to the project directory
    os.chdir("/Users/dean/Documents/git/skill-gh")
    analyze_dependencies()