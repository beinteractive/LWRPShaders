Shader "Lightweight/Particles/Textureless"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Cutoff ("Threshold", Range(0.0, 1.0)) = 0.5
        
        [KeywordEnum(Hyperbolic, Power, SmoothStep)] _CurveType("Curve Type", Float) = 0.0
        _Shape("Shape Parameter", Range(0, 1)) = 0.25
        
        [HideInInspector] _Surface ("Surface", Float) = 3.0
        [HideInInspector] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1.0
        [HideInInspector] [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0.0
        [HideInInspector] [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2.0
        [HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("Z Test", Float) = 2.0
        [HideInInspector] [Toggle] _ZWrite ("Z Write", Float) = 1.0
        [HideInInspector] [Toggle] _AlphaPremultiply ("Premultiplied Alpha", Float) = 0.0
        [HideInInspector] [Toggle] _AlphaClip ("Alpha Clip", Float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True" "PreviewType" = "Plane" }
        Pass
        {
            Tags { "LightMode" = "LightweightForward" }
            
            Lighting Off
            
            Blend [_SrcBlend] [_DstBlend]
            Cull [_Cull]
            ZTest [_ZTest]
            ZWrite [_ZWrite]
            
            HLSLPROGRAM
			
            #pragma multi_compile_instancing
            #pragma multi_compile _CURVETYPE_HYPERBOLIC _CURVETYPE_POWER _CURVETYPE_SMOOTHSTEP
            #pragma instancing_options procedural:VertInstancingSetup
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHACLIP_ON
            
            #pragma vertex vert_simple
            #pragma fragment frag
            
            #define NO_MAIN_TEXTURE
            #define USE_VERTEX_COLOR
            
            #include "ShaderLibrary - Input.hlsl"
            #include "ShaderLibrary - Instancing.hlsl"
            #include "ShaderLibrary - Particles.hlsl"
            #include "ShaderLibrary - AlphaClip.hlsl"
            #include "ShaderLibrary - SimplePass.hlsl"
            
            half4 _Color;
            DEFINE_CUTOFF
            half _Shape;
        
            // Based on ShurikenPlus - Custom shader library for Unity particle system
            // https://github.com/keijiro/ShurikenPlus
            
            half4 frag(v2f i) : SV_Target
            {
                half x = length(i.uv - 0.5) * 2;
                
                #if _CURVETYPE_HYPERBOLIC
                    half base = exp(_Shape * 8 - 4);
                    x = saturate(base / x - base);
                #elif _CURVETYPE_POWER
                    x = pow(saturate(1 - x), exp(3 - _Shape * 6));
                #else
                    x = 1 - smoothstep(_Shape, 1, x);
                #endif
                
                half4 vcol = i.color;
                half4 col = _Color;
                half3 albedo = vcol.rgb * col.rgb;
                half a = vcol.a * col.a * x;
                AlphaClip(a);
                AlphaPremultiply(albedo, a);
                return half4(albedo, a);
            }

            ENDHLSL
        }
    }
    CustomEditor "LWRPShaders.LWRPShaderGUI"
}