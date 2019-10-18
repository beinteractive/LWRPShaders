Shader "Lightweight/Unlit/Gradient"
{
    Properties
    {
        _BaseColorA ("Base Color A", Color) = (1, 1, 1, 1)
        _BaseColorB ("Base Color B", Color) = (1, 1, 1, 1)
        _Cutoff ("Threshold", Range(0.0, 1.0)) = 0.5
        
        [HideInInspector] _Surface ("Surface", Float) = 0.0
        [HideInInspector] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1.0
        [HideInInspector] [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0.0
        [HideInInspector] [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2.0
        [HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("Z Test", Float) = 2.0
        [HideInInspector] [Toggle] _ZWrite ("Z Write", Float) = 1.0
        [HideInInspector] [Toggle] _AlphaPremultiply ("Premultiplied Alpha", Float) = 0.0
        [HideInInspector] [Toggle] _AlphaClip ("Alpha Clip", Float) = 0.0
        [HideInInspector] [Toggle] _EnablePerInstanceData ("Enable Per Instance Data", Float) = 0.0
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
            #pragma shader_feature _PERINSTANCEDATA_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHACLIP_ON
            
            #pragma vertex vert_simple
            #pragma fragment frag
            
            #define NO_MAIN_TEXTURE
            
            #include "Packages/jp.beinteractive.lwrpshaders/Shaders/ShaderLibrary - Input.hlsl"
            #include "Packages/jp.beinteractive.lwrpshaders/Shaders/ShaderLibrary - Instancing.hlsl"
            #include "Packages/jp.beinteractive.lwrpshaders/Shaders/ShaderLibrary - AlphaClip.hlsl"
            #include "Packages/jp.beinteractive.lwrpshaders/Shaders/ShaderLibrary - SimplePass.hlsl"
            
            PERINSTANCEDATA_BEGIN
              PERINSTANCEDATA(half4, _BaseColorA)
              PERINSTANCEDATA(half4, _BaseColorB)
              PERINSTANCEDATA_CUTOFF
            PERINSTANCEDATA_END
        
            half4 frag(v2f i) : SV_Target
            {
                SETUP_PER_INSTANCE_ID(i)
                half4 col_a = PERINSTANCEDATA_REF(_BaseColorA);
                half4 col_b = PERINSTANCEDATA_REF(_BaseColorB);
                half3 albedo_a = col_a.rgb;
                half3 albedo_b = col_b.rgb;
                half a_a = col_a.a;
                half a_b = col_b.a;
                half a = lerp(a_b, a_a, i.uv.y);
                AlphaClip(a);
                half3 albedo = lerp(col_b, col_a, i.uv.y);
                AlphaPremultiply(albedo, a);
                return half4(albedo, a);
            }

            ENDHLSL
        }
    }
    CustomEditor "LWRPShaders.LWRPShaderGUI"
}