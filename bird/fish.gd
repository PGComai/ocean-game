extends CharacterBody3D

signal above_clouds(loc)
signal below_clouds(loc)
signal in_clouds(loc)

@export var cloud_low = 145
@export var cloud_high = 260

@export var speed = -20
@export var strength = 5
@export var spin = 5

var cloud_mid = cloud_low + ((cloud_high - cloud_low)/2)
var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO
var h_rot
var spin_cycle = 0
var y_cycle = 0
var rng = RandomNumberGenerator.new()
var velocity_lf = Vector3.ZERO
var df = 0

func _init():
	var direction = Vector3.ZERO
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	#if event.is_action_pressed("boost"):
		#speed = lerp(speed, 20, 0.1)
	#else:
		#speed = lerp(speed, 50, 0.1)
	if event.is_action_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event.is_action_pressed("toggle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	wrap()
	#print(global_translation)
	h_rot = $CamRoot/h.global_transform.basis.get_euler().y
	#if Input.is_action_pressed("go"):
	input_vector = get_input_vector(h_rot)
	apply_movement(input_vector)
		#print(input_vector)
		
	#else:
		#slow_down()
	#velocity = velocity.rotated(Vector3.UP, h_rot)
	$bird.look_at($bird.global_translation + velocity, Vector3.UP)
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	velocity = velocity
	df = lerp_angle(df, velocity.signed_angle_to(velocity_lf, Vector3.UP), 0.1)
	#var dfdf = velocity_lf.distance_squared_to(velocity)
	velocity_lf = velocity
	
	$bird.rotate_object_local(Vector3.FORWARD, df * 20)
	
	#spin_attractor(delta)
	var player_height = return_pos().y
	#print(player_height)
	if player_height > cloud_high:
		emit_signal('above_clouds', player_height)
#		get_parent().get_node("WorldEnvironment").environment.fog_depth_end = remap(player_height, cloud_high, cloud_high + 30, 100, 2000)
#		get_parent().get_node("WorldEnvironment").environment.fog_depth_begin = remap(player_height, cloud_high, cloud_high + 30, 0, 25)
	elif player_height <= cloud_low:
		emit_signal('below_clouds', player_height)
#		get_parent().get_node("WorldEnvironment").environment.fog_depth_end = remap(player_height, cloud_low - 20, cloud_low, 800, 100)
#		get_parent().get_node("WorldEnvironment").environment.fog_depth_begin = remap(player_height, cloud_low - 20, cloud_low, 25, 0)
	if player_height < cloud_high and player_height > cloud_low:
		emit_signal('in_clouds', player_height)
#		get_parent().get_node("WorldEnvironment").environment.ambient_light_energy = remap(player_height, cloud_low, cloud_high, 0.3, 1)
#		get_parent().get_node("water light").light_energy = remap(player_height, cloud_low, cloud_high, 0.423, 1)
		

func get_input_vector(h_rot):
	var input_vector = Vector3.ZERO
	input_vector.x = sin(h_rot)
	input_vector.z = cos(h_rot)
	input_vector.y = -sin($CamRoot/h/v.global_transform.basis.get_euler().x)
	return input_vector.normalized() if input_vector.length() > 1 else input_vector

func apply_movement(input_vector):
	velocity.x = lerp(velocity.x, input_vector.x * speed, 0.01)
	velocity.z = lerp(velocity.z, input_vector.z * speed, 0.01)
	velocity.y = lerp(velocity.y, input_vector.y * speed, 0.01)
	
func slow_down():
	velocity.x = lerp(velocity.x, 0, 0.03)
	velocity.z = lerp(velocity.z, 0, 0.03)
	velocity.y = lerp(velocity.y, 0, 0.03)

func return_pos():
	var x = get_global_transform_interpolated().origin
	return x
	
func return_velocity():
	return velocity
	
func wrap():
	if global_translation.x > 1000:
		global_translation.x -= 1000
	elif global_translation.x < -1000:
		global_translation.x += 1000
	if global_translation.z > 1000:
		global_translation.z -= 1000
	elif global_translation.z < -1000:
		global_translation.z += 1000

