extends Node2D

var orbital_space_scene = load("res://OrbitalSpace.tscn")

var rng = RandomNumberGenerator.new()

export var ring_inner_radius = 100
export var ring_outer_radius = 200

var orbital_period
var ring_mid_radius
var ring_center
var max_orbital_spaces = 8
var chunk_theta
var orbital_spaces_list = []
var orbital_frequency
var orbital_time = 0
var orbital_period_const = 0.1

func _ready():
	rng.randomize()
	ring_mid_radius = ring_inner_radius + \
		(ring_outer_radius - ring_inner_radius) / 2.0
	orbital_period = orbital_period_const * pow(ring_mid_radius, 3/2.0)
	orbital_frequency = 2.0 * PI / float(orbital_period)
	var counter = 0
	chunk_theta = 2.0 * PI / max_orbital_spaces
	var new_child
	for space in range(max_orbital_spaces):
		var new_orbital_space = orbital_space_scene.instance()
		new_orbital_space.position.x = ring_mid_radius * \
			cos((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0)
		new_orbital_space.position.y = -ring_mid_radius * \
			sin((counter*chunk_theta + (counter+1)*chunk_theta) / 2.0)
		if rng.randi() % 2 == 0:
			new_orbital_space.add_turret()
		else:
			new_orbital_space.add_commsat()
		counter += 1
		add_child(new_orbital_space)

func _physics_process(delta):
	var counter = 0
	var orbital_angle_rad
	
	for orbital_space in get_children():
		orbital_angle_rad = ((counter*chunk_theta+(counter+1)*chunk_theta)/2.0)
		orbital_time += delta
		orbital_space.position.x = ring_mid_radius \
			* cos(orbital_angle_rad + orbital_frequency*orbital_time)
		orbital_space.position.y = ring_mid_radius \
			* sin(orbital_angle_rad + orbital_frequency*orbital_time)
		counter += 1

func _process(delta):
	var current_r
	for orbital_space in get_children():
		orbital_space.update_label()


