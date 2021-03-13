extends KinematicBody2D

const SPEED := 600

func _physics_process(delta: float) -> void:
	var velocity := Vector2()

	if (Input.is_action_pressed("ui_left")):
		velocity.x = -SPEED
	if (Input.is_action_pressed("ui_right")):
		velocity.x = SPEED

	move_and_collide(velocity * delta)

func _unhandled_key_input(event: InputEventKey) -> void:
	if (event.is_action_pressed("shoot")):
		$LaserWeapon.shoot()


func _on_Hitbox_body_entered(body: Node) -> void:
	if (!self.is_queued_for_deletion() && body.is_in_group("asteroids")):
		queue_free()
