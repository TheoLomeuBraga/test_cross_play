extends Control

func _ready() -> void:
	pass

func _on_start_pressed() -> void:
	if MultPlayerManager.create_server():
		$first.visible = false
		$start.visible = true
		
		$start/Label.text = MultPlayerManager.ip_port
	
	

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set($start/Label.text)

func _on_join_pressed() -> void:
	$first.visible = false
	$join.visible = true
	


func _on_join_game_pressed() -> void:
	if MultPlayerManager.create_client($join/TextEdit.text):
		#MultPlayerManager.change_level.rpc("res://game/game.tscn")
		visible = false
	else:
		print("fail to connect")



func _on_start_game_pressed() -> void:
	MultPlayerManager.change_level("res://game/game.tscn")
	visible = false


func _on_paste_pressed() -> void:
	$join/TextEdit.text = DisplayServer.clipboard_get()
