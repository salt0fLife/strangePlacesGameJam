extends CharacterBody2D

@export var speed: float = 150.0 #20 pixels per second
@export var acceleration_time:float = 15.0 #fifteenth of a second
@export var jump_strength : float = -200.0
@export var gravity : float = 600.0
@export var step_height : float = 4.0 #how many pixels you can step up
@onready var graphics = $graphics
@onready var shadow = $graphics/shadow ## NOTE should be child of graphics
@onready var cameraHandler = $graphics/cameraHandler
var y_vel:float = 0.0 #y velocity
var y_pos: float = 0.0
var y_ground_pos: float = 0.0 #height of the ground your on

@export var camera_follow_speed : float = 10.0
@export var camera_dead_zone : float = 20.0 #distance before camera starts following
var camera_velocity = Vector2.ZERO
@export var camera_dampening : float = 0.5 #friction so it slows down
@export var camera_movement_effect : float = 0.1 #how much player velocity effects camera movement

var dead_ground: bool = false #if the ground will kill you
var dead = false

signal player_died

func _physics_process(delta):
	var wish_dir = Input.get_vector("left", "right","up","down")
	velocity = lerp(velocity,wish_dir*speed,delta*acceleration_time)
	if Input.is_action_just_pressed("jump"):
		if y_pos == y_ground_pos: #can only jump if on floor
			jump()
	
	#Implementing Animation
	if wish_dir.length() == 0.0:
		$AnimationPlayer.play("Idle")
		pass
	else: 
		$AnimationPlayer.play("Walk")
		if wish_dir.x >= 0.0:
			$graphics/Sprite2D2.flip_h = false
			pass
		else: 
			$graphics/Sprite2D2.flip_h = true 
	
			pass
	
	
	
	#make sure ground height is up to date
	update_ground_height()
	
	#make sure nearby walls are up to date
	update_nearby_walls_col()
	
	#y position stuff
	y_pos += y_vel * delta
	
	if y_pos > y_ground_pos: #keep you from going under floor
		y_pos = y_ground_pos
		y_vel = 0.0
	
	if y_pos != y_ground_pos: #is not on floor
		y_vel += gravity*delta #adds gravity
	else: #is on ground
		if dead_ground and !dead:
			die()
	
	graphics.position.y = y_pos #applies y_pos
	
	#now for shadow graphics
	var altitude = (y_ground_pos-y_pos) #how far from the ground you are
	shadow.position.y = altitude #puts the shadow on the ground
	var shadow_strength = (1.0 - clamp((altitude/100.0),0.0,1.0)) #shadow not visible after 100 pixel height
	shadow.scale = Vector2(shadow_strength,shadow_strength) #applying shadow strength
	
	
	#want camera to feel good
	camera_velocity += velocity*camera_movement_effect*delta
	
	var cam_dif = (graphics.global_position - cameraHandler.position)
	if cam_dif.length() > camera_dead_zone:
		camera_velocity += (cam_dif) * camera_follow_speed*delta
	
	camera_velocity -= camera_velocity*delta*camera_dampening #applies friction
	
	cameraHandler.position += camera_velocity #applies camera velocity
	z_index = int((global_position.y - y_ground_pos))
	
	#dont have to do anything fancy now
	move_and_slide()

@onready var walls_finder = $walls_finder
func update_nearby_walls_col() -> void:
	for w in walls_finder.get_overlapping_bodies():
		if w.is_in_group("wall"):
			if w.ground_height >= (y_pos-step_height): #is lower than player
				w.set_collision_layer_value(1,false)
			else: #is higher than player
				w.set_collision_layer_value(1,true)

func jump() -> void: #jumps
	y_vel = jump_strength #applies y_vel
	dead = false #for debugging

@onready var ground_finder = $ground_finder
func update_ground_height() -> void:
	if ground_finder.has_overlapping_bodies(): #is on some ground
		var hit
		var max_height = 10000.0 #arbitrary unrealistically high number
		for oa in ground_finder.get_overlapping_bodies(): #picks tallest platform
			if oa.ground_height < max_height:
				hit = oa
				max_height = oa.ground_height
		y_ground_pos = hit.ground_height
		dead_ground = hit.dead_ground
	else:
		dead_ground = false
		y_ground_pos = 0.0

func set_ground_pos(new_ground_pos: float) -> void:
	y_ground_pos = new_ground_pos

func die():
	dead = true
	print("you died")
	emit_signal("player_died")
