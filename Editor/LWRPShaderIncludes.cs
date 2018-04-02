using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace LWRPShaders
{
    public static class LWRPShaderIncludes
    {
        [ShaderIncludePath]
        public static string[] GetPaths()
        {
            var root = Directory.GetParent(Application.dataPath);
            var paths = root.GetFiles("LWRPShaders.Shaders.asmdef", SearchOption.AllDirectories);
            var path = paths.Select(_ => _.DirectoryName).FirstOrDefault(_ => _ != null);
            if (path != null)
            {
                return new[] { path };
            }

            return null;
        }
    }
}