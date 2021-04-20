extends Node

var star_scene = preload("res://Star.tscn")

var vpx
var vpy

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _ready():
	vpx = get_viewport().size.x
	vpy = get_viewport().size.y
	
	var star_x = vpx / 2.0
	var star_y = vpy / 2.0
	
	var star_instance = star_scene.instance()
	star_instance.position.x = star_x
	star_instance.position.y = star_y
	add_child(star_instance)
