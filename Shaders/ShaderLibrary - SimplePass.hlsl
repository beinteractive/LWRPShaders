#ifndef LWRPSHADRES_SHADERLIBRARY_SIMPLE_PASS
#define LWRPSHADRES_SHADERLIBRARY_SIMPLE_PASS

struct v2f
{
    float4 pos : SV_POSITION;
    
    #ifndef NO_UV
    float2 uv : TEXCOORD0;
    #endif
    
    #ifdef _PERINSTANCEDATA_ON
    UNITY_VERTEX_INPUT_INSTANCE_ID
    #endif
};

v2f vert_simple(appdata v)
{
    v2f o;

    UNITY_SETUP_INSTANCE_ID(v);
    
    #ifdef _PERINSTANCEDATA_ON
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    #endif

    o.pos = TransformObjectToHClip(v.vertex);
    
    #ifndef NO_UV
    #ifndef NO_MAIN_TEXTURE
    o.uv = TransformMainTextureCoord(v.uv);
    #else
    o.uv = v.uv;
    #endif
    #endif
    
    return o;
}

#ifdef _PERINSTANCEDATA_ON

#define SETUP_PER_INSTANCE_ID(i) UNITY_SETUP_INSTANCE_ID(i)

#else

#define SETUP_PER_INSTANCE_ID(i)

#endif

#endif