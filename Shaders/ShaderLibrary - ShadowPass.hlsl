#ifndef LWRPSHADRES_SHADERLIBRARY_SHADOW_PASS
#define LWRPSHADRES_SHADERLIBRARY_SHADOW_PASS

#ifndef USE_BUILTIN_ALPHA_CLIP

#define Alpha(x, y, z) ;

#endif

#if UNITY_VERSION >= 201930
#include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
#else
#include "Packages/com.unity.render-pipelines.lightweight/Shaders/ShadowCasterPass.hlsl"
#endif

#endif
