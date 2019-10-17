#ifndef LWRPSHADRES_SHADERLIBRARY_DEPTH_ONLY_PASS
#define LWRPSHADRES_SHADERLIBRARY_DEPTH_ONLY_PASS

#ifndef USE_BUILTIN_ALPHA_CLIP

#define Alpha(x, y, z) ;

#endif

#include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"

#endif
