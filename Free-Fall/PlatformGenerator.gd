extends Node

var Platform = load("res://Platform.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func platform_engine():
	var player = get_parent().get_node("Player")
	var player_position = player.position
	var player_future = player_position.y + get_parent().get_viewport().size.y
	var random_percentage = rng.randf_range(0.0, 100.0)
	var tol = 10
	
	# generate platform in future
	if random_percentage <= tol:
		var randx = rng.randf_range(0.0, get_parent().get_viewport().size.x)
		var new_platform = Platform.instance()
		new_platform.position = Vector2(randx, player_future)
		get_parent().add_child(new_platform)

func _process(delta):
	platform_engine()
