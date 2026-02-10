---
name: sync-ag-swift-shims
description: Sync Swift shims from OpenAttributeGraph repo to AG/DeviceSwiftShims
---

Sync Swift source files from OpenAttributeGraph repository to the `_AttributeGraphDeviceSwiftShims` target.

## Usage

This command will:
1. Copy all Swift files from OpenAttributeGraph's `Sources/OpenAttributeGraph` directory
2. Replace `OAG` with `AG` in function names and symbols
3. Replace `OpenAttributeGraph` with `AttributeGraph` in imports and comments
4. Remove documentation (.docc) folders

## Parameters

When using this command, provide:
- **Location**: Path to the OpenAttributeGraph repository (local path or GitHub URL)

## Examples

### Local path
```
/sync-ag-swift-shims

Location: /Users/kyle/Workspace/OP/OpenAttributeGraph
```

### GitHub URL
```
/sync-ag-swift-shims

Location: https://github.com/OpenSwiftUIProject/OpenAttributeGraph
```

## Implementation

The command will:

1. **Resolve the source location**:
   - If a local path is provided, use it directly
   - If a GitHub URL is provided, clone it to a temporary directory

2. **Clean the target directory**:
   - Remove existing files in `AG/DeviceSwiftShims/` (except any non-Swift configuration files)

3. **Copy Swift files**:
   - Source: `{repo}/Sources/OpenAttributeGraph/`
   - Target: `AG/DeviceSwiftShims/`
   - Preserve directory structure (Attribute/, Debug/, Graph/, Runtime/, etc.)

4. **Perform replacements in all copied files**:
   - Replace `OAG` with `AG` (for function names like `OAGGraphMutateAttribute` -> `AGGraphMutateAttribute`)
   - Replace `OpenAttributeGraphCxx` with `AttributeGraph` (for imports)
   - Replace `//  OpenAttributeGraph` with `//  AttributeGraph` (for file headers)
   - Replace any remaining `OpenAttributeGraph` with `AttributeGraph` (for doc comments)

5. **Cleanup**:
   - Remove `.docc` documentation folders
   - Remove `.DS_Store` files
   - If a temporary clone was created, remove it

## Directory Structure After Sync

```
AG/DeviceSwiftShims/
├── Attribute/
│   ├── Attribute/
│   ├── Body/
│   ├── Indirect/
│   ├── Optional/
│   ├── Rule/
│   ├── RuleContext/
│   └── Weak/
├── Debug/
├── Graph/
├── Runtime/
└── Export.swift
```

## Notes

- The `_AttributeGraphDeviceSwiftShims` target provides Swift symbols for iOS device builds where the binary AttributeGraph framework lacks Swift interface
- This target depends on the `AttributeGraph` binary target
- Files use `public import AttributeGraph` to access C/C++ symbols from the binary framework
