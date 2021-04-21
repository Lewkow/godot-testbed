extends Node

var star_scene = preload("res://Star.tscn")
var player_scene = preload("res://Player.tscn")
var rng = RandomNumberGenerator.new()
var vpx
var vpy

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _ready():
	rng.randomize()
	vpx = get_viewport().size.x
	vpy = get_viewport().size.y

	var star_instance = star_scene.instance()
	star_instance.position.x = vpx / 2.0
	star_instance.position.y = vpy / 2.0
	add_child(star_instance)

	var player = player_scene.instance()
#	player.position.x = rng.randf_range(0, vpx)
#	player.position.y = rng.randf_range(0, vpy)
	player.position.x = vpx / 2.0
	player.position.y = vpy / 2.0
	add_child(player)
