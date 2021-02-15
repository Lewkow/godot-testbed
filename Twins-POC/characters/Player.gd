extends KinematicBody2D

const SPEED := 600

func _physics_process(delta: float) -> void:
	var velocity := Vector2()

	if (Input.is_action_pressed("ui_left")):
		velocity.x = -SPEED
	if (Input.is_action_pressed("ui_right")):
		velocity.x = SPEED
	if (Input.is_action_pressed("ui_up")):
		velocity.y = -SPEED
	if (Input.is_action_pressed("ui_down")):
		velocity.y = SPEED

	move_and_collide(velocity * delta)
	

