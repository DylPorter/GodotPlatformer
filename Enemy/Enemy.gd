extends KinematicBody2D

const targetfps = Engine.iterations_per_second
const fireballscene = preload("Fireball.tscn")
var gravity = 8
var speed = 32

var motion = Vector2.ZERO
var angeredbuffer: float
var isangered = false
var ismovingright = true
var isattacking = false

onready var patrolcast = $PatrolCast
onready var wallcast = $WallCast
onready var playercast = $PlayerCast
onready var animationplayer = $AnimationPlayer

func _physics_process(delta):
	if isangered == false:
		speed = 32
		animationplayer.play("Walk")

	if playercast.is_colliding() and isattacking == false:
		attack()

	movecharacter()
	detectturnaround()

	motion.y += gravity * delta * targetfps
	
	motion = move_and_slide(motion, Vector2.UP)
	
	if isangered == true and isattacking == false:
		angeredbuffer += delta
		speed = 50
		animationplayer.play("AngeredWalk")
		if angeredbuffer >= 5:
			isangered = false
	
func movecharacter():
	if ismovingright:
		motion.x = speed
	else:
		motion.x = -speed
	
func detectturnaround():
	if (not patrolcast.is_colliding() or wallcast.is_colliding()) and is_on_floor():
		ismovingright = !ismovingright
		scale.x = -scale.x

func attack():
	isangered = true
	isattacking = true
	yield(get_tree().create_timer(0.2), "timeout")
	speed = 0
	animationplayer.play("AngeredStand")
	yield(get_tree().create_timer(0.5), "timeout")
	animationplayer.play("Attack")
	yield(get_node("AnimationPlayer"), "animation_finished")
	var fireball = fireballscene.instance()
	get_parent().add_child(fireball)
	fireball.position = get_node("Position2D").global_position
	animationplayer.play("Regenerate")
	yield(get_node("AnimationPlayer"), "animation_finished")
	animationplayer.play("AngeredStand")
	angeredbuffer = 0
	isattacking = false
