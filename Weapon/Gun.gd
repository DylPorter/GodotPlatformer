extends Sprite


var canfire = true
var bullet = preload("res://Weapon/Bullet.tscn")
onready var player = get_owner()

func _physics_process(delta):
	var mouseposition = get_global_mouse_position()
	look_at(mouseposition)
	
	if Input.is_action_just_pressed("attack") and canfire == true:
		var bulletinstance = bullet.instance() as Node2D
		bulletinstance.global_position = $Position2D.global_position
		bulletinstance.direction = (get_global_mouse_position() - global_position).normalized()
		get_parent().add_child(bulletinstance)
		canfire = false
		yield(get_tree().create_timer(0.1), "timeout")
		canfire = true
