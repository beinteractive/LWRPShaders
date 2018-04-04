# Lightweight Render Pipeline Shaders

__"Lightweight Render Pipeline Shaders"__ is a collection of shaders designed for Unity 2018 Lightweight Render Pipeline.
It's especially useful for VFX and particles.

All shaders are fully customizable and GPU Instancing / GPU Instancing Particles friendly.

<img width="300" alt="2018-04-04 14 09 07" src="https://user-images.githubusercontent.com/1482297/38289598-fc170572-3811-11e8-9704-b4e11127a31b.png"> <img width="300" alt="2018-04-04 14 09 52" src="https://user-images.githubusercontent.com/1482297/38289599-fc403820-3811-11e8-90e1-0740d6c1ab3a.png">

## Available Shaders

 - Lightweight
   - Unlit
     - Color
     - Gradient
     - Texture
     - Texture and Color
   - Particles
     - Color
     - Texture
     - Textureless (Port from [ShurikenPlus](https://github.com/keijiro/ShurikenPlus))

## Features

### Basic Parameters

<img width="354" alt="2018-04-04 14 18 37" src="https://user-images.githubusercontent.com/1482297/38289840-444f12c0-3813-11e8-91db-811b14495f72.png">

This section contains shader specific parameters. Basically, color and texture.

### Alpha Clip

<img width="349" alt="2018-04-04 14 18 50" src="https://user-images.githubusercontent.com/1482297/38289841-44758e00-3813-11e8-8dc2-82fee68ebe84.png">

If you check `Alpha Clip`, alpha clipping is enabled. A pixel with alpha that is less than threshold will be discarded.

### Surface

<img width="352" alt="2018-04-04 14 19 01" src="https://user-images.githubusercontent.com/1482297/38289842-449c7d8a-3813-11e8-9d10-8d4cb9ea20ff.png">

You can choose one of the following surface types:

 - `Opaque`
 - `Transparent`
 - `Premultiply`
 - `Additive`
 - `Multiply`

and `Src Blend`, `Dst Blend`, `Z Write` and `Premultiplied Alpha` values will automatically be configured to appropriate settings.

If you choose `Custom`, you can change that values as you like.

### Cull

<img width="351" alt="2018-04-04 14 19 13" src="https://user-images.githubusercontent.com/1482297/38289843-44c32b60-3813-11e8-993a-acbcb806e3c2.png">

You can choose a cull mode from:

 - `Off`
 - `Front`
 - `Back`

Default is `Back`. `Off` is for double sided material.

### Z Test

<img width="351" alt="2018-04-04 14 19 24" src="https://user-images.githubusercontent.com/1482297/38289844-44ebc5f2-3813-11e8-8b17-2a459ff445f5.png">

You can choose which compare function will be used for Z Test.

### GPU Instaincing

<img width="354" alt="2018-04-04 14 19 39" src="https://user-images.githubusercontent.com/1482297/38289845-4535cf6c-3813-11e8-845a-79f96593389b.png">

If you check `Enable GPU Instancing`, a material is automatically configured for GPU Instancing. If you use same mesh and the material with MeshRenderer for rendering, draw call will be automatically instanced.

Also if you check `Enable Per Instance Data`, you can store per-instance `Basic Parameters` via MaterialPropertyBlock.

```C#
// Set random colors but keep GPU Instancing
foreach (var g in gameObjects)
{
  var property = new MaterialPropertyBlock();
  property.SetColor("_Color", Random.color);
  g.GetComponent<MeshRenderer>().SetProperty(property);
}
```

### GPU Instancing Particle

All Particles shaders works correctly with GPU Instaincing in Particle System.

To enable GPU Instaincing in Particle System, use `Mesh` render mode and check `Enable GPU Instancing` in `Render` section of Particle System inspector.

### Minimum

All features are implemented by shader variants. After compilation, code of non-used feature is efficiently striped!
