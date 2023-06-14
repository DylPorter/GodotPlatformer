extends KinematicBody2D

################## VARIABLES & CONSTANTS ##################

const targetfps = Engine.iterations_per_second
const acceleration = 8
const maxspeed = 85
const friction = 10
const airresistance = 1
const gravity = 9
const jumpforce = -210
const wallslideacceleration = 14
const maxwallslidespeed = 42
const backwardmaxspeed = 60

var motion = Vector2.ZERO
var jumpcount = 0
var maxjumpcount = 2
var direction = 1

var jumpcapability
var jumpmemory
var wallsliding
var cell_location
var tilemap
var tile_id
var buildcapability
var player_location
var mouseposition

onready var initial_scale = scale
onready var sprite = $Sprite
onready var animationplayer = $Animations
onready var area = $Area2D
onready var reach = $Reach

func _ready():
	tilemap = get_tree().get_root().get_node("World/TileMap")
	
################## MOVEMENT FUNCTIONS ##################

func _physics_process(delta):
	var x_input = Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")
	if (x_input > 0 and direction > 0) or (x_input < 0 and direction < 0):
		motion.x += x_input * acceleration * delta * targetfps
		motion.x = clamp(motion.x, -maxspeed, maxspeed)
		animationplayer.play("Run")
	elif (x_input < 0 and direction > 0) or (x_input > 0 and direction < 0):
		motion.x += x_input * acceleration * delta * targetfps
		motion.x = clamp(motion.x, -backwardmaxspeed, backwardmaxspeed)
		animationplayer.play("BackwardsRun")
	else:
		animationplayer.play("Stand")

	motion.y += gravity * delta * targetfps
	motion = move_and_slide(motion, Vector2.UP)

################## JUMP FUNCTIONS ##################

	if Input.is_action_just_pressed("jump"):
		jumpmemory = true
		remember_jump()
		if jumpcount < maxjumpcount and not is_on_wall():
			motion.y = jumpforce
			jumpcount += 1
			
################## GROUNDED FUNCTIONS ##################
	
	if is_on_floor():
		jumpcapability = true
		jumpcount = 0
		if jumpmemory == true:
			motion.y = jumpforce
			
		if Input.is_action_just_pressed("jump"):
			motion.y = jumpforce
			jumpcount += 1
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, friction * delta)
			
	if not is_on_floor():
		animationplayer.play("Jump")
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, airresistance * delta)

################## WALL FUNCTIONS ##################

	if is_on_wall() and (Input.is_action_pressed("moveleft") or Input.is_action_pressed("moveright")):
		if motion.y >= 20:
			motion.y = min(motion.y + wallslideacceleration, maxwallslidespeed)
			animationplayer.play("Wall Hug")
			wallsliding = true
			jumpcount = 0
			if Input.is_action_pressed("moveleft"):
				scale.x = initial_scale.x * sign(scale.y)
				if Input.is_action_just_pressed("jump"):
					motion.x = maxspeed
					motion.y = jumpforce
					jumpcount += 1
			elif Input.is_action_pressed("moveright"):
				scale.x = -initial_scale.x * sign(scale.y)
				if Input.is_action_just_pressed("jump"):
					motion.x = -maxspeed
					motion.y = jumpforce
					jumpcount += 1
		else:
			wallsliding = false
	else:
		wallsliding = false
	
################## SPRITE FUNCTIONS ##################

	if wallsliding == false:
		if get_global_mouse_position().x > position.x:
			direction = 1
			scale.x = initial_scale.x * sign(scale.y)
		elif get_global_mouse_position().x < position.x:
			direction = -1
			scale.x = -initial_scale.x * sign(scale.y)

################## BLOCK FUNCTIONS ##################
	
	var mouseposition = get_global_mouse_position()
	reach.look_at(mouseposition)
	reach.look_at(mouseposition)

	if Input.is_action_pressed("right_click") and buildcapability == true:
		cell_location = tilemap.world_to_map(get_global_mouse_position())
		player_location = tilemap.world_to_map(position)
		tile_id = tilemap.get_cellv(cell_location)
		print(player_location)
		if cell_location != player_location:
			tilemap.set_cellv(cell_location, 2)
			tilemap.update_bitmask_area(Vector2(cell_location))
			set_collision_mask_bit(0, 0)
		
################## DEFINED FUNCTIONS ##################
	
func remember_jump():
	yield(get_tree().create_timer(0.1), "timeout")
	jumpmemory = false
	pass

func _on_Area2D_mouse_entered():
	buildcapability = true

func _on_Area2D_mouse_exited():
	buildcapability = false
