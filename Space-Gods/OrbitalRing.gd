extends Node2D

var orbital_space_scene = load("res://OrbitalSpace.tscn")

var ring_inner_radius = 100
var ring_outer_radius = 200
var ring_mid_radius
var ring_center
var max_orbital_spaces = 8
var chunk_theta
var orbital_spaces_list = []
var orbital_period = 100
var orbital_frequency = 2.0 * PI / float(orbital_period)
var orbital_time = 0

func _ready():
	ring_mid_radius = ring_inner_radius + (ring_outer_radius - ring_inner_radius) / 2.0
	var counter = 0
	chunk_theta = 2.0 * PI / max_orbital_spaces
	var new_child
	for space in range(max_orbital_spaces):
		var new_orbital_space = orbital_space_scene.instance()
		new_orbital_space.position.x = ring_mid_radius * cos((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0)
		new_orbital_space.position.y = -ring_mid_radius * sin((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0)
		new_orbital_space.add_turret()
		counter += 1
		add_child(new_orbital_space)

func _physics_process(delta):
	var counter = 0
	for orbital_space in get_children():
		orbital_time += delta
		orbital_space.position.x = ring_mid_radius * cos(((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0) + orbital_frequency*orbital_time)
		orbital_space.position.y = ring_mid_radius * sin(((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0) + orbital_frequency*orbital_time)
#		if counter == 0:
#			print(delta, ' : ', orbital_space.position.x, ' - ', orbital_space.position.y)
		counter += 1
