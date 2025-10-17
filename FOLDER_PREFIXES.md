# Folder Prefixes

## Overview

The folder prefix feature allows you to customize the names of output and intermediate directories when converting Visual Studio solutions to makefiles. This is particularly useful when you want to distinguish build outputs from different build systems or toolchains.

## Configuration

Folder prefixes are configured in the `MakeItSo.config` XML file, which should be placed in the same directory as your Visual Studio solution file.

### C++ Projects

To set a folder prefix for C++ projects:

```xml
<MakeItSo>
  <AllProjects>
    <CPPFolderPrefix prefix="gcc" />
  </AllProjects>
</MakeItSo>
```

### C# Projects

To set a folder prefix for C# projects:

```xml
<MakeItSo>
  <AllProjects>
    <CSharpFolderPrefix prefix="mono" />
  </AllProjects>
</MakeItSo>
```

### Combined Configuration

You can specify both C++ and C# folder prefixes in the same config file:

```xml
<MakeItSo>
  <AllProjects>
    <CPPFolderPrefix prefix="gcc" />
    <CSharpFolderPrefix prefix="mono" />
  </AllProjects>
</MakeItSo>
```

## How It Works

When MakeItSo converts your Visual Studio solution, the folder prefix is prepended to the last component of output and intermediate folder paths.

### Example

Without a folder prefix:
- Debug output folder: `Debug/`
- Release output folder: `Release/`

With `<CPPFolderPrefix prefix="gcc" />`:
- Debug output folder: `gccDebug/`
- Release output folder: `gccRelease/`

With `<CPPFolderPrefix prefix="cppPrefix" />`:
- Debug output folder: `cppPrefixDebug/`
- Release output folder: `cppPrefixRelease/`

### Path Examples

For more complex paths:
- Original: `../Test/Output/Release`
- With prefix "gcc": `../Test/Output/gccRelease`

## Use Cases

1. **Multiple Build Systems**: When building the same project with different compilers (e.g., Visual Studio and GCC), you can keep separate output directories:
   - Visual Studio outputs to `Debug/` and `Release/`
   - GCC outputs to `gccDebug/` and `gccRelease/`

2. **Toolchain Identification**: Clearly identify which toolchain produced which outputs by using prefixes like "gcc", "clang", "mingw", etc.

3. **Cross-Platform Development**: When working across Windows and Unix-like systems, use prefixes to distinguish platform-specific builds.

4. **Build Isolation**: Prevent conflicts between different build configurations by keeping their outputs in separate directories.

## Disabling Folder Prefixes

To disable folder prefixes (use default folder names), set the prefix to an empty string:

```xml
<MakeItSo>
  <AllProjects>
    <CPPFolderPrefix prefix="" />
  </AllProjects>
</MakeItSo>
```

## Tests

Test projects demonstrating folder prefix functionality are available in:
- `Tests/TestProjects/Config/SimpleHelloWorld_FolderPrefix_CPP/`
- `Tests/TestProjects/Config/SimpleHelloWorld_FolderPrefix_CSharp/`
- `Tests/TestProjects/Config/SimpleHelloWorld_NoFolderPrefix_CPP/`
- `Tests/TestProjects/Config/SimpleHelloWorld_NoFolderPrefix_CSharp/`

These tests verify that:
1. Folder prefixes are correctly applied to output directories
2. Build outputs are placed in the prefixed folders
3. Projects build and run successfully with prefixed folders
4. Empty prefix (no prefix) works correctly

Each test project includes:
- A `MakeItSo.config` file with folder prefix configuration
- A Visual Studio solution/project file
- A `testMakeAndTest.sh` script that builds and runs the converted makefile
- A `testExpectedResults.txt` file that defines expected output

## Implementation Details

The folder prefix is implemented in:
- `MakeItSoLib/MakeItSoConfig_Project.cs`: Configuration parsing and storage
- `MakeItSo/MakefileBuilder_Project_CPP.cs`: C++ makefile generation with prefixes
- `MakeItSo/MakefileBuilder_Project_CSharp.cs`: C# makefile generation with prefixes
- `MakeItSoLib/Utils.cs`: Helper methods for adding prefixes to paths

The `Utils.addPrefixToFolderPath()` method handles the actual prefix application by:
1. Normalizing path separators
2. Finding the last folder component in the path
3. Prepending the prefix to that component
4. Reconstructing the full path
