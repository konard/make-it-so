# Test Case for Issue #25: Relative Paths for Source Files

## Problem
When Visual Studio project files contain source files with relative paths (e.g., `../src/foobar.c`),
the generated makefile creates invalid object file paths like `gccDebug/../src/foobar.o`.

## Example
Given a source file: `../src/foobar.c`

**Before fix:**
- Object path: `gccDebug/../src/foobar.o`
- This doesn't work because the directory `../src/` doesn't exist in the build context

**After fix:**
- Normalized path: `src/foobar.c` (removed `../`)
- Object path: `gccDebug/src/foobar.o`
- The makefile creates the `gccDebug/src/` directory with `mkdir -p`

## Solution
The fix involves:
1. Creating a helper method `getObjectPathFromSourceFile()` that normalizes source file paths
2. Removing relative path components (`../` and `./`) from source file paths
3. Updating `createConfigurationTarget()` to use the normalized paths
4. Updating `createFileTargets()` to use the normalized paths
5. Updating `createCreateFoldersTarget()` to create subdirectories for nested source files

## Testing
This fix ensures that:
- Source files with relative paths compile correctly
- Object files are placed in appropriate subdirectories within the intermediate folder
- The build system creates all necessary directories
- Multiple files with the same name in different directories are handled correctly
