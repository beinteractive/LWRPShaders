Shader "Lightweight/Particles/Texture"
{
    Properties
    {
        _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Cutoff ("Threshold", Range(0.0, 1.0)) = 0.5
        
        [HideInInspector] _Surface ("Surface", Float) = 0.0
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
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True" }
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
            #pragma instancing_options procedural:VertInstancingSetup
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHACLIP_ON
            
            #pragma vertex vert_simple
            #pragma fragment frag
            
            #define USE_VERTEX_COLOR
            
            #include "ShaderLibrary - Input.hlsl"
            #include "ShaderLibrary - Instancing.hlsl"
            #include "ShaderLibrary - Particles.hlsl"
            #include "ShaderLibrary - AlphaClip.hlsl"
            #include "ShaderLibrary - SimplePass.hlsl"
            
            half4 _Color;
            DEFINE_CUTOFF
        
            half4 frag(v2f i) : SV_Target
            {
                half4 tex = MainTexture(i.uv);
                half4 vcol = i.color;
                half4 col = _Color;
                half3 albedo = tex.rgb * vcol.rgb * col.rgb;
                half a = tex.a * vcol.a * col.a;
                AlphaClip(a);
                AlphaPremultiply(albedo, a);
                return half4(albedo, a);
            }

            ENDHLSL
        }
    }
    CustomEditor "LWRPShaders.LWRPShaderGUI"
}