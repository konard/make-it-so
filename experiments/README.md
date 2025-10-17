# Makefile Dependency Tracking Experiment

## Problem
The current generated Makefiles have the `.PHONY` configuration targets (like `Debug`, `Release`) directly execute the `ar rcs` command. This means the target always runs, even if nothing changed.

## Root Cause
In `makefile_test_bad.mk`, the `Release` target is marked as `.PHONY`, so it always runs. The `ar rcs` command is in the recipe, so the library is always regenerated.

## Solution
In `makefile_test_good.mk`, we:
1. Make the `.PHONY` target depend on the actual library file (e.g., `lib/libtest.a`)
2. Create a separate target for the library file that depends on object files
3. Put the `ar rcs` command in the library file's recipe

This way, Make can check timestamps: if the library is newer than all object files, it won't be rebuilt.

## Testing
Run both makefiles twice to see the difference:

```bash
# Bad version - always rebuilds
make -f makefile_test_bad.mk
make -f makefile_test_bad.mk  # Rebuilds even though nothing changed!

# Good version - only rebuilds when needed
make -f makefile_test_good.mk
make -f makefile_test_good.mk  # Skips rebuild - nothing changed
```
