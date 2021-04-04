extends Area2D

var photon_velocity = 100

func _process(delta):
	position.x += photon_velocity * delta
	
