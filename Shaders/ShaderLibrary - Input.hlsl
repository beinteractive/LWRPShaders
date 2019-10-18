#ifndef LWRPSHADRES_SHADERLIBRARY_INPUT
#define LWRPSHADRES_SHADERLIBRARY_INPUT

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

#ifndef NO_MAIN_TEXTURE

CBUFFER_START(UnityPerMaterial)
float4 _BaseMap_ST;
CBUFFER_END

TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);

#endif

struct appdata
{
    float3 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
    
    #ifdef USE_VERTEX_COLOR
    half4 color : COLOR;
    #endif
    
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

#ifndef NO_MAIN_TEXTURE

float2 TransformMainTextureCoord(float2 uv)
{
    return TRANSFORM_TEX(uv, _BaseMap);
}

half4 MainTexture(float2 uv)
{
    return SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
}

#endif

#ifdef _ALPHAPREMULTIPLY_ON

#define AlphaPremultiply(albedo, a) albedo *= a

#else

#define AlphaPremultiply(albedo, a)

#endif

#endif
