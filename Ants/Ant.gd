extends RigidBody2D

signal nest_signal(x, y)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func _physics_process(delta):
	var next_step = random_next_step()
	position.x += next_step[0]
	position.y += next_step[1]
	emit_signal("nest_signal", position.x, position.y)


func random_next_step():
	var rand_step = [[0,1], [0,-1], [1, 0], [-1, 0]]
	return rand_step[randi() % len(rand_step)]
