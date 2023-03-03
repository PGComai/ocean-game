extends Node3D

var rot_h = 0
var rot_v = 0
var v_min = -80
var v_max = 80
var h_sensitivity = 0.1
var v_sensitivity = 0.1
var h_acc
var v_acc
var mouse = true
var no_mouse_time = 0
var bird_vy = 0
var bird_y = 0
var auto_height = 25
var rng = RandomNumberGenerator.new()
var height_variety = 0
var turn_variety = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera3D.add_exception(get_parent())
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rot_h -= event.relative.x * h_sensitivity
		rot_v -= event.relative.y * v_sensitivity
		mouse = true
	if Input.is_action_pressed("go"):
		mouse = false
		
		
func _physics_process(delta):
	#print(rot_h)
	#print(rot_v)
	
	if not mouse:
		rng.randomize()
		height_variety += rng.randf_range(-0.1, 0.1)
		height_variety = clamp(height_variety, -10, 10)
		turn_variety += rng.randf_range(-0.1, 0.1)
		turn_variety = clamp(turn_variety, -20, 20)
		no_mouse_time += delta
		bird_vy = get_parent().return_velocity().y
		bird_y = get_parent().return_pos().y
		#print(bird_y)
		#print(bird_vy)
		rot_v -= (bird_vy/20) + ((bird_y - auto_height + height_variety)/500)
		rot_h = lerp_angle(rot_h, 0 + turn_variety, 0.01)
	
	rot_v = clamp(rot_v, v_min, v_max)
	
	var h_cur = $h.rotation_degrees.y
	var v_cur = $h/v.rotation_degrees.x
	
	$h.rotation_degrees.y = lerp(h_cur, rot_h, 0.1)
	$h/v.rotation_degrees.x = lerp(v_cur, rot_v, 0.1)
