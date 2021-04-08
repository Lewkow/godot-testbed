extends Node


func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
	
	
