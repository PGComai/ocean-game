extends WorldEnvironment

@export var cloud_low = 145
@export var cloud_high = 260
@export var fog_dist_under_cloud = 3000

var cloud_mid = cloud_low + ((cloud_high - cloud_low)/2)

var blue_sky = Color('5e8ec6')
var grey_sky = Color('5a5a5c')
var white_sky = Color('f0f0f0')
var black_sky = Color('000000')

func _ready():
	pass

func _process(delta):
	pass


func _on_KinematicBody_above_clouds(loc):
	environment.fog_enabled = true
	environment.fog_color = environment.fog_color.lerp(white_sky, 0.01)
	environment.background_sky.sky_top_color = environment.background_sky.sky_top_color.lerp(blue_sky, 0.05)
	environment.background_sky.sky_horizon_color = environment.background_sky.sky_horizon_color.lerp(white_sky, 0.05)
	environment.background_sky.ground_horizon_color = environment.background_sky.ground_horizon_color.lerp(white_sky, 0.05)
	environment.background_sky.ground_bottom_color = environment.background_sky.ground_bottom_color.lerp(white_sky, 0.05)
	environment.ambient_light_color = white_sky
	environment.ambient_light_energy = lerp(environment.ambient_light_energy, 1, 0.05)
	environment.fog_depth_end = remap(loc, cloud_high, cloud_high + 30, 100, 2000)
	environment.fog_depth_begin = remap(loc, cloud_high, cloud_high + 30, 0, 25)


func _on_KinematicBody_below_clouds(loc):
	environment.fog_enabled = true
	environment.fog_color = environment.fog_color.lerp(grey_sky, 0.05)
	environment.background_sky.sky_top_color = environment.fog_color
	environment.background_sky.sky_horizon_color = environment.fog_color
	environment.background_sky.ground_horizon_color = environment.fog_color
	environment.background_sky.ground_bottom_color = environment.background_sky.ground_bottom_color.lerp(black_sky, 0.05)
	environment.ambient_light_color = environment.fog_color
	environment.ambient_light_energy = lerp(environment.ambient_light_energy, 0.3, 0.05)
	environment.fog_depth_end = remap(loc, cloud_low - 20, cloud_low, fog_dist_under_cloud, 100)
	environment.fog_depth_begin = remap(loc, cloud_low - 20, cloud_low, 25, 0)


func _on_KinematicBody_in_clouds(loc):
	environment.fog_enabled = true
	environment.fog_color = environment.fog_color.lerp(white_sky, 0.01)
	environment.fog_depth_end = lerp(environment.fog_depth_end, 50, 0.1)
	environment.fog_depth_begin = lerp(environment.fog_depth_begin, 0, 0.1)
	environment.background_sky.sky_top_color = environment.fog_color
	environment.background_sky.sky_horizon_color = environment.fog_color
	environment.background_sky.ground_horizon_color = environment.fog_color
	environment.background_sky.ground_bottom_color = environment.fog_color
	environment.ambient_light_color = environment.fog_color
	environment.ambient_light_energy = remap(loc, cloud_low, cloud_high, 0.3, 1)
	get_parent().get_node("water light").light_energy = remap(loc, cloud_low, cloud_high, 0.423, 1)
