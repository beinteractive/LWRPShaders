#ifndef LWRPSHADRES_SHADERLIBRARY_DEPTH_ONLY_PASS
#define LWRPSHADRES_SHADERLIBRARY_DEPTH_ONLY_PASS

#ifndef USE_BUILTIN_ALPHA_CLIP

#define Alpha(x, y, z) ;

#endif

#if UNITY_VERSION >= 201930
#include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
#else
#include "Packages/com.unity.render-pipelines.lightweight/Shaders/DepthOnlyPass.hlsl"
#endif

#endif
