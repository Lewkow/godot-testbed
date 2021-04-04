extends RigidBody2D

var photon_scene = load("res://Photon.tscn")

var rng = RandomNumberGenerator.new()
var body_time = 0
var body_equilibrium = 0
var body_amp = 100
var body_k = 1
var body_w0 = body_k / float(mass)

func _ready():
	body_time = 0
	body_equilibrium = get_viewport().size.y/float(2)
	position = Vector2(100, get_viewport().size.y/2.0);

#func _physics_process(delta):
#	body_time += delta
#	position.y = body_equilibrium + body_amp * cos(body_w0*body_time)

func _process(delta):
	rng.randomize()
	var my_random_number = rng.randf_range(0, 1)
	body_time += delta
	position.y = body_equilibrium + body_amp * cos(body_w0*body_time)
	if my_random_number > 0.99:
		var new_photon = photon_scene.instance()
		new_photon.position = self.position
		get_tree().get_root().add_child(new_photon)
