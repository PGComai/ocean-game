extends DirectionalLight3D


func _ready():
	pass


func _on_KinematicBody_above_clouds(loc):
	light_energy = lerp(light_energy, 1, 0.1)
	shadow_enabled = true


func _on_KinematicBody_below_clouds(loc):
	light_energy = lerp(light_energy, 0.423, 0.1)
	shadow_enabled = false


func _on_KinematicBody_in_clouds(loc):
	shadow_enabled = false
