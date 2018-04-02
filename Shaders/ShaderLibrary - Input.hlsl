#ifndef LWRPSHADRES_SHADERLIBRARY_INPUT
#define LWRPSHADRES_SHADERLIBRARY_INPUT

#include "LWRP/ShaderLibrary/Core.hlsl"

CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
CBUFFER_END

TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

struct appdata
{
    float3 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

float2 TransformMainTextureCoord(float2 uv)
{
    return TRANSFORM_TEX(uv, _MainTex);
}

half4 MainTexture(float2 uv)
{
    return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
}

#endif