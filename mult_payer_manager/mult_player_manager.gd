extends Node


var ip_port : String

const port : int = 49152

var i = 0
func _ready() -> void:
	ip_port = IP.get_local_addresses()[0] + ":" + str(port) 
	


func add_player() -> void:
	print("pear connected")

func fail_to_connect() -> void:
	print("fail to connect")

func create_server() -> bool:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_server(port) != 0:
		printerr("can not create server")
		return false
	multiplayer.multiplayer_peer = peer
	
	return true
	



func create_client(text : String) -> bool:
	if text.split(":").size() != 2:
		return false
	
	var ip : String = text.split(":")[0]
	var port : int = text.split(":")[1].to_int()
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_client(ip,port) != 0:
		printerr("can not connect to server")
		return false
	
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(add_player)
	multiplayer.connection_failed.connect(fail_to_connect)

	
	
	return true

var level_node : Node


func change_level(level : String):
	if is_instance_valid(level_node):
		level_node.queue_free()
	
	level_node = load(level).instantiate()
	print("level: ",level)
	
	$MultPlayerNodes.add_child(level_node,true)


func _on_spawned(node: Node) -> void:
	print("A")

#func _process(delta: float) -> void:
#	print($MultPlayerNodes.get_child_count())
