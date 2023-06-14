extends Sprite

var snapsizex = 16
var snapsizey = 16

var mouseposition = get_global_mouse_position()

var blue_highlight = preload("res://Player/highlight.png")
var red_highlight = preload("res://Player/highlight_red.png")

onready var player = get_tree().get_root().get_node("World/Player")

func _physics_process(delta):
	if player.buildcapability:
		set_texture(blue_highlight)
	else:
		set_texture(red_highlight)
	snap()
	
func snap():
	if get_global_mouse_position().x < 0 and get_global_mouse_position().y < 0:
		mouseposition = Vector2(int(get_global_mouse_position().x / snapsizex), int(get_global_mouse_position().y / snapsizey))
	elif get_global_mouse_position().x < 0 and get_global_mouse_position().y > 0:
		mouseposition = Vector2(int(get_global_mouse_position().x / snapsizex), int(get_global_mouse_position().y / snapsizey+1))
	elif get_global_mouse_position().x > 0 and get_global_mouse_position().y < 0:
		mouseposition = Vector2(int(get_global_mouse_position().x / snapsizex+1), int(get_global_mouse_position().y / snapsizey))
	elif get_global_mouse_position().x > 0 and get_global_mouse_position().y > 0:
		mouseposition = Vector2(int(get_global_mouse_position().x / snapsizex+1), int(get_global_mouse_position().y / snapsizey+1))
	position = mouseposition * snapsizex
