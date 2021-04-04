extends RigidBody2D

var init_position = position
var init_velocity = Vector2(700.0, 0.0)

func _ready():
	linear_velocity = init_velocity

func _process(delta):
	pass

