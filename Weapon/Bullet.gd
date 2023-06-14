extends KinematicBody2D

const speed = 400

var collision: KinematicCollision2D
var collided = false
var istravelling = false
var direction = Vector2.ZERO

var tilemap
var cell
var tile_id

func _ready():
	set_as_toplevel(true)
	tilemap = get_tree().get_root().get_node("World/TileMap")
	
func _process(delta):
	if !collided:
		collision = move_and_collide(direction * speed * delta)
		if collision != null:
			if collision.collider.name == "TileMap":
				cell = tilemap.world_to_map(collision.position - collision.normal)
				tile_id = tilemap.get_cellv(cell)
				if tile_id < 6:
					tile_id = tile_id + 1
				else:
					tile_id = -1
				tilemap.set_cellv(cell, tile_id)
				tilemap.update_bitmask_area(Vector2(cell))
			set_collision_mask_bit(0, 0)
			collided = true
	else:
		queue_free()
