#ifndef LWRPSHADRES_SHADERLIBRARY_LIGHTING
#define LWRPSHADRES_SHADERLIBRARY_LIGHTING

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

float4 ComputeShadowCoord(float3 ws, float4 cs)
{
#if SHADOWS_SCREEN
    return ComputeScreenPos(cs);
#else
    return TransformWorldToShadowCoord(ws);
#endif
}

#endif
