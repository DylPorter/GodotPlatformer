extends Area2D

var fireballspeed = 100

onready var enemy = get_node("/root/World/Enemy")
onready var animationplayer = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	sprite.set_frame(2)
	animationplayer.play("Fireball")
	set_process(true)
	if enemy.ismovingright == true:
		fireballspeed = 100
	else:
		scale.x = -scale.x
		fireballspeed = -100
		
func _physics_process(delta):
	var speed_x = 1
	var speed_y = 0
	var motion = Vector2(speed_x, speed_y) * fireballspeed
	set_global_position(get_global_position() + motion * delta)

func _on_Fireball_body_entered(body):
	fireballspeed = 0
	animationplayer.play("Explosion")
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
