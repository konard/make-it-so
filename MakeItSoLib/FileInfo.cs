using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace MakeItSoLib
{
    /// <summary>
    /// Holds information about one file in a project.
    /// </summary>
    public class FileInfo
    {
        /// <summary>
        /// Enum for how a file should be compiled.
        /// </summary>
        public enum CompileAsType
        {
            Default,        // Use default based on file extension
            CompileAsC,     // Compile as C code
            CompileAsCpp    // Compile as C++ code
        }

        /// <summary>
        /// Constructor.
        /// </summary>
        public FileInfo()
        {
            IsFromAProjectOutputFolder = false;
            CompileAs = CompileAsType.Default;
        }

        /// <summary>
        /// Returns a new copy of this FileInfo.
        /// </summary>
        public FileInfo clone()
        {
            FileInfo result = new FileInfo();
            result.AbsolutePath = AbsolutePath;
            result.CopyToOutputFolder = CopyToOutputFolder;
            result.RelativePath = RelativePath;
            result.IsFromAProjectOutputFolder = IsFromAProjectOutputFolder;
            result.CompileAs = CompileAs;
            return result;
        }

        /// <summary>
        /// Gets or sets the absolute path.
        /// </summary>
        public string AbsolutePath { get; set; }

        /// <summary>
        /// Gets or sets the path to the file, relative to the root folder of
        /// the project that it belongs to.
        /// </summary>
        public string RelativePath { get; set; }

        /// <summary>
        /// Gets or sets whether the file should be copied to the output folder.
        /// </summary>
        public bool CopyToOutputFolder { get; set; }

        /// <summary>
        /// Gets or sets whether this file is from a project's output
        /// folder (e.g. bin/Debug/file.ext). 
        /// </summary><remarks>
        /// If it is, we will need to change the folder name when adding 
        /// it to the makefile.
        /// </remarks>
        public bool IsFromAProjectOutputFolder { get; set; }

        /// <summary>
        /// Gets the file extension, including the '.'
        /// </summary>
        public string Extension
        {
            get { return Path.GetExtension(AbsolutePath); }
        }

        /// <summary>
        /// Gets or sets how this file should be compiled (C vs C++).
        /// </summary>
        public CompileAsType CompileAs { get; set; }
    }
}
