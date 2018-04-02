#ifndef LWRPSHADRES_SHADERLIBRARY_SIMPLE_PASS
#define LWRPSHADRES_SHADERLIBRARY_SIMPLE_PASS

struct v2f
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

v2f vert_simple(appdata v)
{
    v2f o;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);

    o.pos = TransformObjectToHClip(v.vertex);
    
    #ifndef NO_MAIN_TEXTURE
    o.uv = TransformMainTextureCoord(v.uv);
    #else
    o.uv = v.uv;
    #endif
    
    return o;
}

#endif