extends Node2D

export(int) var map_width = 80
export(int) var map_height = 50

export(String) var world_seed = "Hello Godot!"
export(int) var noise_octaves = 1
export(int) var noise_period = 10
export(float) var noise_persistency = 0.7
export(float) var noise_lacunarity = 0.2
export(float) var noise_threshold = 0.2

var tilemap: TileMap
var simplexnoise: OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	tilemap = get_parent() as TileMap
	generate()
	playerspawn()

func clear():
	tilemap.clear()
	
func generate():
	simplexnoise.seed = world_seed.hash()
	simplexnoise.octaves = noise_octaves
	simplexnoise.period = noise_period
	simplexnoise.persistence = noise_persistency
	simplexnoise.lacunarity = noise_lacunarity
	
	for x in range(-map_width / 2, map_width / 2):
		for y in range(-map_height / 2, map_height / 2):
			if simplexnoise.get_noise_2d(x, y) < noise_threshold:
				set_autotile(x, y)
	tilemap.update_dirty_quadrants()
	
func set_autotile(x: int, y: int):
	tilemap.set_cell(
		x,
		y,
		tilemap.get_tileset().get_tiles_ids()[0],
		false,
		false,
		false,
		tilemap.get_cell_autotile_coord(x, y)
		)
	tilemap.update_bitmask_area(Vector2(x, y))
	
func playerspawn():
	tilemap.set_cellv(Vector2(0,0), -1)
	tilemap.set_cellv(Vector2(1,1), -1)
	tilemap.set_cellv(Vector2(1,0), -1)
	tilemap.set_cellv(Vector2(0,1), -1)
	tilemap.set_cellv(Vector2(-1,-1), -1)
	tilemap.set_cellv(Vector2(-1,0), -1)
	tilemap.set_cellv(Vector2(0,-1), -1)
	tilemap.set_cellv(Vector2(-1,1), -1)
	tilemap.set_cellv(Vector2(1,-1), -1)
	tilemap.update_bitmask_region(Vector2(1,1), Vector2(-1,-1))
