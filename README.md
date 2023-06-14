# GodotPlatformer

Playable alpha build test of a small 2D platformer project built in the [Godot game engine](https://godotengine.org/) `v3.5.1` written in GDScript.

### Features:
* Fluid character movement implementing acceleration, friction, and air resistance
   * Player movement includes double jumps, wall sliding, and coyote time
* Procedurally generated tile map world using [OpenSimplexNoise](https://docs.godotengine.org/en/3.3/classes/class_opensimplexnoise.html)
   * Tile map is interactable in real time, player can add and break tiles up to a designated distance from the player
* Player has a weapon that can fire projectiles to crack the tile environments until they break
* Simple enemy that uses raycasting to patrol back and forth
    * Attack animation plays when detecting a player in front of the enemy, releasing a fireball projectile
