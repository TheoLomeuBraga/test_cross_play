extends MeshInstance3D
class_name ColorfullCube

var on : bool = false
func _ready() -> void:
	visible = false
	on = true

@export var color : Color :
	set(value):
		color = value
		if on:
			var material : StandardMaterial3D = get_surface_override_material(0)
			material.albedo_color = color
			set_surface_override_material(0,material)
			visible = true
