extends StaticBody2D

export var max_ants = 1000

var Ant = load("res://Ant.tscn")
var ant_time = 0
var rng = RandomNumberGenerator
var ants_released = 0

onready var color_grid = get_node('ColorGrid')

func _process(delta):
	ant_time += delta
	if (int(ant_time) % 2 == 0) and (ants_released < max_ants):
		add_ant()
#		get_ants()


func add_ant():
	var new_ant = Ant.instance()
	new_ant.position = self.position
	var new_ant_init_vel = new_ant.random_next_step()
	new_ant.linear_velocity.x = new_ant_init_vel[0]
	new_ant.linear_velocity.y = new_ant_init_vel[1]
	get_parent().add_child(new_ant)
	ants_released += 1

func get_ants():
	var z = get_parent().get_children()
	print(z)
	

func _on_Ant_nest_signal(x, y):
#	color_grid.update_grid()
	print(x, ', ', y)
#	$ColorGrid.update_grid()
