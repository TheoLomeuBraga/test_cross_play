extends Node3D

var cube_sceane : PackedScene = preload("res://game/cube.tscn")

var my_color : Color

func _ready() -> void:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	my_color.r = rng.randf_range(0.0,1.0)
	my_color.g = rng.randf_range(0.0,1.0)
	my_color.b = rng.randf_range(0.0,1.0)

@rpc("any_peer", "call_local", "reliable")
func add_cube(pos : Vector3, color : Color) -> void:
	var cube : ColorfullCube = cube_sceane.instantiate()
	MultPlayerManager.get_node("/root/MultPlayerManager/MultPlayerNodes").add_child(cube,true)
	cube.global_position = pos
	cube.global_position.y = 1.0
	cube.color = color

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		add_cube.rpc_id(1,$Camera3D.project_ray_origin(get_viewport().get_mouse_position()),my_color) 
