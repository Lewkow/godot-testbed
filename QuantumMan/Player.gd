extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -350
export (int) var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var delta_x_walk = 0.01
var photon_speed = speed * 5
var velocity = Vector2.ZERO
var photon = load("res://Photon.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$AnimatedH.play()
	$AnimatedH.animation = "hydrogen-1-stand"

func _process(delta):
	var fx = float(velocity.x)
	if is_on_floor():
		if abs(fx) < delta_x_walk:
			$AnimatedH.animation = "hydrogen-1-stand"
		else:
			$AnimatedH.animation = "hydrogen-1-walk"
	else:
		$AnimatedH.animation = "hydrogen-1-air"

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			jump_photons()
			
	if Input.is_action_just_pressed("shoot"):
		shoot_photon()

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir*speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func shoot_photon():
	var n_shoot_photons = 3
	for i in range(n_shoot_photons):
		var new_photon = photon.instance()
		new_photon.position = self.position
		new_photon.rotation_degrees = rng.randf_range(-10.0, 10.0)
		new_photon.linear_velocity.x = photon_speed * cos(deg2rad(new_photon.rotation_degrees))
		new_photon.linear_velocity.y = -photon_speed * sin(deg2rad(new_photon.rotation_degrees))
		if self.velocity.x < 0:
			new_photon.linear_velocity.x *= -1
		get_tree().get_root().add_child(new_photon)

func jump_photons():
	var n_jump_photons = 15
	for i in range(n_jump_photons):
		var new_photon = photon.instance()
		new_photon.position = self.position
		new_photon.rotation_degrees = rng.randf_range(0.0, 360.0)
		new_photon.linear_velocity.x = photon_speed * cos(deg2rad(new_photon.rotation_degrees))
		new_photon.linear_velocity.y = photon_speed * sin(deg2rad(new_photon.rotation_degrees))
		get_tree().get_root().add_child(new_photon)

func end_game():
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	end_game()
	queue_free()
