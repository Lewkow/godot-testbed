extends "res://objects/Asteroid.gd"

func _ready() -> void:
	var main_camera = get_node("/root/Game/MainCamera")
	self.connect("explode", main_camera, "asteroid_small_exploded")

func explode():
	if is_exploded:
		return

	is_exploded = true
	emit_signal("explode")
	get_parent().remove_child(self)
	queue_free()

