#ifndef LWRPSHADRES_SHADERLIBRARY_FUNCTIONS
#define LWRPSHADRES_SHADERLIBRARY_FUNCTIONS

inline half3 ApplySaturation(half3 albedo, half s)
{
    return lerp((0.212 * albedo.r + 0.701 * albedo.g + 0.087 * albedo.b).xxx, albedo, s);
}

#endif