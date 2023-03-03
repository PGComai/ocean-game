extends Node3D
#tool

var wingLhome = Vector3.ZERO
var wingRhome = Vector3.ZERO
var cycles = {}
var flap = 0
var flapspeed = 1
# cycles: {id: [iterator value, multiplier]}

func _ready():
	wingLhome = $albatross/LWingHandle.position
	wingRhome = $albatross/RWingHandle.position
	$albatross/Armature/Skeleton3D/SkeletonIKL.start(false)
	$albatross/Armature/Skeleton3D/SkeletonIKR.start(false)

func _process(delta):
	flap = flap_engine(delta, flap, flapspeed)
	
	print(flap)
	
func flap_engine(delta, num, flapspeed):
	num += delta * flapspeed
	if num >= 360:
		num -= 360
	return num
