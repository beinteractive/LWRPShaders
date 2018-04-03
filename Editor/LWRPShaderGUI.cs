using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace LWRPShaders
{
    public class LWRPShaderGUI : ShaderGUI
    {
        public enum Surface
        {
            Opaque,
            Transparent,
            Premultiply,
            Additive,
            Multiply,
            Custom
        }

        private static class Styles
        {
            public static readonly string Surface = "Surface Type";
            public static readonly string[] SurfaceNames = Enum.GetNames(typeof(Surface));
        }
        
        private MaterialProperty SurfaceProperty;
        private MaterialProperty SrcBlendProperty;
        private MaterialProperty DstBlendProperty;
        private MaterialProperty CullProperty;
        private MaterialProperty ZTestProperty;
        private MaterialProperty ZWriteProperty;
        private MaterialProperty AlphaPremultiplyProperty;
        private MaterialProperty AlphaClipProperty;
        private MaterialProperty AlphaCutoffProperty;
        private MaterialProperty EnablePerInstanceDataProperty;

        private bool IsFirstTimeApply = true;
        
        public override void OnGUI(MaterialEditor editor, MaterialProperty[] props)
        {
            FetchProperties(props);

            if (IsFirstTimeApply)
            {
                ApplyMaterialChange((Material) editor.target);
                IsFirstTimeApply = false;
            }

            editor.SetDefaultGUIWidths();

            BasicProperties(editor, props);

            EditorGUILayout.Space();
            EditorGUILayout.Space();
            
            EditorGUI.BeginChangeCheck();
            {
                AdvancedProperties(editor, props);

                EditorGUILayout.Space();
                EditorGUILayout.Space();

                editor.RenderQueueField();

                if (EnablePerInstanceDataProperty != null)
                {
                    editor.EnableInstancingField();
                    Property(editor, EnablePerInstanceDataProperty);
                }
                
                editor.DoubleSidedGIField();
            }
            if (EditorGUI.EndChangeCheck())
            {
                foreach (var target in SurfaceProperty.targets)
                {
                    ApplyMaterialChange((Material) target);
                }
            }
        }

        private void FetchProperties(MaterialProperty[] props)
        {
            SurfaceProperty = FindProperty("_Surface", props);
            SrcBlendProperty = FindProperty("_SrcBlend", props);
            DstBlendProperty = FindProperty("_DstBlend", props);
            CullProperty = FindProperty("_Cull", props);
            ZTestProperty = FindProperty("_ZTest", props);
            ZWriteProperty = FindProperty("_ZWrite", props);
            AlphaPremultiplyProperty = FindProperty("_AlphaPremultiply", props);
            AlphaClipProperty = FindProperty("_AlphaClip", props);
            AlphaCutoffProperty = FindProperty("_Cutoff", props);
            EnablePerInstanceDataProperty = FindProperty("_EnablePerInstanceData", props, false);
        }

        private void BasicProperties(MaterialEditor editor, MaterialProperty[] props)
        {
            foreach (var prop in props)
            {
                if ((prop.flags & (MaterialProperty.PropFlags.HideInInspector | MaterialProperty.PropFlags.PerRendererData)) != 0)
                {
                    continue;
                }

                if (prop == AlphaCutoffProperty)
                {
                    continue;
                }
                
                Property(editor, prop);
            }
        }

        private void AdvancedProperties(MaterialEditor editor, MaterialProperty[] props)
        {
            Property(editor, AlphaClipProperty);
            EditorGUI.BeginDisabledGroup(AlphaClipProperty.floatValue <= 0f);
            EditorGUI.indentLevel++;
            {
                Property(editor, AlphaCutoffProperty);
            }
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();
            
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            
            var surface = Popup(editor, Styles.Surface, SurfaceProperty, Styles.SurfaceNames);
        
            EditorGUI.BeginDisabledGroup(surface != (int)Surface.Custom);
            EditorGUI.indentLevel++;
            {
                Property(editor, SrcBlendProperty);
                Property(editor, DstBlendProperty);
                Property(editor, ZWriteProperty);
                Property(editor, AlphaPremultiplyProperty);
            }
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();
            
            Property(editor, CullProperty);
            Property(editor, ZTestProperty);
        }
        
        private int Popup(MaterialEditor editor, string label, MaterialProperty property, string[] options)
        {
            EditorGUI.showMixedValue = property.hasMixedValue;

            EditorGUI.BeginChangeCheck();
            
            var mode = EditorGUILayout.Popup(label, (int)property.floatValue, options);
            
            if (EditorGUI.EndChangeCheck())
            {
                editor.RegisterPropertyChangeUndo(label);
                property.floatValue = mode;
            }

            EditorGUI.showMixedValue = false;

            return mode;
        }

        private void Property(MaterialEditor editor, MaterialProperty property)
        {
            var h = editor.GetPropertyHeight(property, property.displayName);
            var r = EditorGUILayout.GetControlRect(true, h, EditorStyles.layerMaskField);

            editor.ShaderProperty(r, property, property.displayName);
        }

        public static void ApplyMaterialChange(Material m)
        {
            m.shaderKeywords = null;

            var surface = (Surface) m.GetFloat("_Surface");
            switch (surface)
            {
                case Surface.Opaque:
                    m.SetOverrideTag("RenderType", "");
                    m.SetInt("_SrcBlend", (int) BlendMode.One);
                    m.SetInt("_DstBlend", (int) BlendMode.Zero);
                    m.SetInt("_ZWrite", 1);
                    m.SetInt("_AlphaPremultiply", 0);
                    m.renderQueue = -1;
                    break;
                case Surface.Transparent:
                    m.SetOverrideTag("RenderType", "Transparent");
                    m.SetInt("_SrcBlend", (int) BlendMode.SrcAlpha);
                    m.SetInt("_DstBlend", (int) BlendMode.OneMinusSrcAlpha);
                    m.SetInt("_ZWrite", 0);
                    m.SetInt("_AlphaPremultiply", 0);
                    m.renderQueue = (int) RenderQueue.Transparent;
                    break;
                case Surface.Premultiply:
                    m.SetOverrideTag("RenderType", "Transparent");
                    m.SetInt("_SrcBlend", (int) BlendMode.One);
                    m.SetInt("_DstBlend", (int) BlendMode.OneMinusSrcAlpha);
                    m.SetInt("_ZWrite", 0);
                    m.SetInt("_AlphaPremultiply", 1);
                    m.renderQueue = (int) RenderQueue.Transparent;
                    break;
                case Surface.Additive:
                    m.SetOverrideTag("RenderType", "Transparent");
                    m.SetInt("_SrcBlend", (int) BlendMode.SrcAlpha);
                    m.SetInt("_DstBlend", (int) BlendMode.One);
                    m.SetInt("_ZWrite", 0);
                    m.SetInt("_AlphaPremultiply", 0);
                    m.renderQueue = (int) RenderQueue.Transparent;
                    break;
                case Surface.Multiply:
                    m.SetOverrideTag("RenderType", "Transparent");
                    m.SetInt("_SrcBlend", (int) BlendMode.DstColor);
                    m.SetInt("_DstBlend", (int) BlendMode.Zero);
                    m.SetInt("_ZWrite", 0);
                    m.SetInt("_AlphaPremultiply", 0);
                    m.renderQueue = (int) RenderQueue.Transparent;
                    break;
            }

            ApplyMaterialKeyword(m, "_AlphaPremultiply", "_ALPHAPREMULTIPLY_ON");
            ApplyMaterialKeyword(m, "_AlphaClip", "_ALPHACLIP_ON");

            if (m.HasProperty("_EnablePerInstanceData"))
            {
                ApplyMaterialKeyword(m, "_EnablePerInstanceData", "_PERINSTANCEDATA_ON");
            }
        }

        private static void ApplyMaterialKeyword(Material m, string propName, string keywordName)
        {
            if (m.GetFloat(propName) > 0f)
            {
                m.EnableKeyword(keywordName);
            }
            else
            {
                m.DisableKeyword(keywordName);
            }
        }
    }
}