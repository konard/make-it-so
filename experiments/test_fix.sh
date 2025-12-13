#!/bin/bash

# Test script to verify the fix for issue #31
# This script:
# 1. Builds the MakeItSo tool
# 2. Generates makefiles for a test C++ project with libraries
# 3. Builds the project twice
# 4. Verifies that the second build doesn't unnecessarily rebuild libraries

set -e

echo "========================================="
echo "Testing Fix for Issue #31"
echo "========================================="

# Build MakeItSo
echo ""
echo "Step 1: Building MakeItSo tool..."
cd /tmp/gh-issue-solver-1760708853987
dotnet build MakeItSo.sln -c Release > /tmp/build_makeitso.log 2>&1

if [ $? -eq 0 ]; then
    echo "✓ MakeItSo built successfully"
else
    echo "✗ Failed to build MakeItSo"
    cat /tmp/build_makeitso.log
    exit 1
fi

# Find the built executable
MAKEITSO_EXE=$(find . -name "MakeItSo.exe" -o -name "MakeItSo.dll" | grep -i release | head -1)
if [ -z "$MAKEITSO_EXE" ]; then
    echo "✗ Could not find MakeItSo executable"
    exit 1
fi
echo "  Found: $MAKEITSO_EXE"

# Navigate to test project
echo ""
echo "Step 2: Setting up test project..."
TEST_DIR="/tmp/gh-issue-solver-1760708853987/Tests/TestProjects/VS2010/C++/AppWithStaticLibrary"
cd "$TEST_DIR"

# Clean up any previous makefiles
rm -f *.makefile Makefile 2>/dev/null || true
rm -rf gccDebug gccRelease 2>/dev/null || true

# Generate makefiles
echo ""
echo "Step 3: Generating Makefiles..."
if [[ "$MAKEITSO_EXE" == *.dll ]]; then
    dotnet "$MAKEITSO_EXE" -file=AppWithStaticLibrary.sln > /tmp/gen_makefiles.log 2>&1
else
    mono "$MAKEITSO_EXE" -file=AppWithStaticLibrary.sln > /tmp/gen_makefiles.log 2>&1
fi

if [ $? -eq 0 ]; then
    echo "✓ Makefiles generated successfully"
else
    echo "✗ Failed to generate makefiles"
    cat /tmp/gen_makefiles.log
    exit 1
fi

# Check if library makefile was created
if [ ! -f "TextLib.makefile" ]; then
    echo "✗ TextLib.makefile not found"
    exit 1
fi

echo ""
echo "Step 4: Examining generated makefile..."
echo "--- First 50 lines of TextLib.makefile ---"
head -50 TextLib.makefile

# First build
echo ""
echo "Step 5: Running first build..."
make -j4 > /tmp/first_build.log 2>&1
if [ $? -eq 0 ]; then
    echo "✓ First build completed successfully"
else
    echo "✗ First build failed"
    cat /tmp/first_build.log
    exit 1
fi

# Get timestamp of library
LIBRARY_FILE=$(find . -name "libTextLib.a" | head -1)
if [ -z "$LIBRARY_FILE" ]; then
    echo "✗ Library file not found after build"
    exit 1
fi
FIRST_TIMESTAMP=$(stat -c %Y "$LIBRARY_FILE" 2>/dev/null || stat -f %m "$LIBRARY_FILE" 2>/dev/null)
echo "  Library timestamp: $FIRST_TIMESTAMP"

# Wait a moment to ensure timestamp difference would be visible
sleep 2

# Second build (should not rebuild library if nothing changed)
echo ""
echo "Step 6: Running second build (no changes)..."
make -j4 > /tmp/second_build.log 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Second build completed successfully"
else
    echo "✗ Second build failed"
    cat /tmp/second_build.log
    exit 1
fi

# Check if library was rebuilt
SECOND_TIMESTAMP=$(stat -c %Y "$LIBRARY_FILE" 2>/dev/null || stat -f %m "$LIBRARY_FILE" 2>/dev/null)
echo "  Library timestamp: $SECOND_TIMESTAMP"

echo ""
echo "========================================="
echo "Test Results:"
echo "========================================="
if [ "$FIRST_TIMESTAMP" = "$SECOND_TIMESTAMP" ]; then
    echo "✓ SUCCESS: Library was NOT rebuilt unnecessarily"
    echo "  The fix is working correctly!"
    exit 0
else
    echo "✗ FAILURE: Library was rebuilt even though nothing changed"
    echo "  First timestamp:  $FIRST_TIMESTAMP"
    echo "  Second timestamp: $SECOND_TIMESTAMP"
    echo ""
    echo "Second build output:"
    cat /tmp/second_build.log
    exit 1
fi
