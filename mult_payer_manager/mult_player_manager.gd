extends Node


var ip_port : String

#const port : int = 49152
var server_port : int = 0

func get_avaliable_port(start_port = 7000, max_attempts = 1000) -> int:
	server_port = start_port
	var attempts = 0
	
	while attempts < max_attempts:
		var server = ENetMultiplayerPeer.new()
		
		var result = server.create_server(server_port, 1)
		
		if result == OK:
			print("port",server_port)
			return server_port
		
		
		server_port += 1
		attempts += 1
	
	return -1  # Nenhuma porta livre encontrada

var i = 0
func _ready() -> void:
	get_avaliable_port()
	ip_port = IP.get_local_addresses()[1] + ";" + str(server_port) 
	#ip_port = "127.0.0.1:" + str(port) 

@rpc("any_peer", "call_local", "reliable")
func present() -> void:
	print("player: ",multiplayer.get_unique_id()," has enterd")

func add_player() -> void:
	print("pear connected")
	#present()#.rpc_id(multiplayer.get_unique_id())
	present.rpc_id(multiplayer.get_unique_id())

func fail_to_connect() -> void:
	print("fail to connect")

signal upnp_completed(error)
func upnp_setup() -> int:
	# UPNP queries take some time.
	var upnp : UPNP = UPNP.new()
	var err : int = upnp.discover()
	
	if err != OK:
		push_error(str(err))
		return err
	
	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
		upnp_completed.emit(OK)
		return OK
	
	return OK

func create_server() -> bool:
	
	
	
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_server(server_port) != 0:
		printerr("can not create server")
		return false
	
	if upnp_setup() != OK:
		printerr("upnp_setup fail")
	
	multiplayer.multiplayer_peer = peer
	
	add_player()
	
	return true
	



func create_client(text : String) -> bool:
	
	if text.split(";").size() != 2:
		return false
	
	var ip : String = text.split(";")[0]
	var port : int = text.split(";")[1].to_int()
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_client(ip,port) != 0:
		print(port)
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




#func _process(delta: float) -> void:
#	print($MultPlayerNodes.get_child_count())
