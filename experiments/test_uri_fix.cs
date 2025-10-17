using System;
using MakeItSoLib;

// Simple test to verify the fix for issue #19
// Tests that makeRelativePath handles invalid URI characters gracefully
class TestUriFix
{
    static void Main()
    {
        Console.WriteLine("Testing makeRelativePath with invalid URI characters...");

        // Test 1: Normal valid paths (should work as before)
        try
        {
            string result1 = Utils.makeRelativePath("C:\\Projects\\", "C:\\Projects\\MyProject\\file.cpp");
            Console.WriteLine("Test 1 PASSED: " + result1);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Test 1 FAILED: " + ex.Message);
        }

        // Test 2: Path with environment variable (previously caused URI exception)
        try
        {
            string result2 = Utils.makeRelativePath("C:\\Projects\\", "%VSRHMENV%\\RhmCore\\include");
            Console.WriteLine("Test 2 PASSED: " + result2);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Test 2 FAILED: " + ex.Message);
        }

        // Test 3: Path with spaces
        try
        {
            string result3 = Utils.makeRelativePath("C:\\My Projects\\", "C:\\My Projects\\Test\\file.h");
            Console.WriteLine("Test 3 PASSED: " + result3);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Test 3 FAILED: " + ex.Message);
        }

        // Test 4: Relative path input (should convert slashes)
        try
        {
            string result4 = Utils.makeRelativePath("C:\\Projects\\", "..\\Include\\header.h");
            Console.WriteLine("Test 4 PASSED: " + result4);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Test 4 FAILED: " + ex.Message);
        }

        Console.WriteLine("\nAll tests completed.");
    }
}
