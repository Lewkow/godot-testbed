extends RigidBody2D

const equilibrium = 200
const spring_const = 1
const object_mass = 10
const local_gravity = 10

func _physics_process(delta):
	var distance = position.y
	var displacement = distance - equilibrium
	var force = -spring_const * displacement 
	var acceleration = force / float(object_mass) + local_gravity
	
	print(displacement)
	linear_velocity.y += acceleration * delta
	position.y += linear_velocity.y * delta
	
