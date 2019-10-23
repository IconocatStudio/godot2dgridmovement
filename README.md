# 2D Grid-based movement system
Godot 3.1.1

## Notes
Based off of Godot's TileMap Node.

See Demo folder for example.

## How To Use

Instance a scene from Zones/WorldInstanceBaseScene

All occupied cells I.E. terrain that actors cannot walk on is drawn using the tilemap "InteractiveTerrain."

All non-occupied cells I.E. background tiles are drawn using the tilemap "Non-InteractiveTerrain"

The final tilemap AlwaysOnTop is for non-occupied forground tiles that should always be drawn over objects (roofs, treetops, etc.)

All overworld objects, actors, etc. are children of InteractiveTerrain in this example.

![SampleGif](https://raw.githubusercontent.com/IconocatStudio/godot2dgridmovement/master/Demo/example.gif)