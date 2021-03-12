extends "res://objects/Asteroid.gd"

var asteroid_small_scene := load("res://objects/AsteroidSmall.tscn")

var is_exploded := false

func _spawn_asteroid_small():
	var asteroid_small = asteroid_small_scene.instance()
	asteroid_small.position = self.position
	get_parent().add_child(asteroid_small)

func explode():
	if is_exploded:
		return

	is_exploded = true
	_spawn_asteroid_small()

	get_parent().remove_child(self)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
