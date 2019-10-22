#ifndef LWRPSHADRES_SHADERLIBRARY_LIGHTING
#define LWRPSHADRES_SHADERLIBRARY_LIGHTING

#if UNITY_VERSION >= 201930
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#else
#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
#endif

float4 ComputeShadowCoord(float3 ws, float4 cs)
{
#if SHADOWS_SCREEN
    return ComputeScreenPos(cs);
#else
    return TransformWorldToShadowCoord(ws);
#endif
}

#endif
