extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector2()
var rotation_dir = 0
var screensize
var zoom_up_lim = 0.1
var zoom_down_lim = 0.75
var zoom_diff = 0.05


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		move_to_this_position(event.position)
#	if event in InputEventMouseButton and event.is_pressed():
#		if event.button_index == BUTTON_WHEEL_UP:
#			if $Camera2D.zoom > Vector2(zoom_up_lim, zoom_up_lim):
#				$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)
#		elif event.button_index == BUTTON_WHEEL_DOWN:
#			if $Camera2D.zoom < Vector2(zoom_down_lim, zoom_down_lim):
#				$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)

func _ready():
	screensize = get_viewport().get_visible_rect().size

func move_to_this_position(this_position):
	var move_path = this_position - position
	var move_dist = move_path.length()
	var angle_diff = move_path.angle_to(Vector2.UP.rotated(rotation))
	print(angle_diff)
	
	

func get_input():
	if Input.is_action_pressed("ui_up"):
		thrust = Vector2(0, -engine_thrust)
		$MainThrusters.emitting = true
	else:
		thrust = Vector2()
		$MainThrusters.emitting = false

	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
		$YawLeftCW.emitting = true
		$YawRightCW.emitting = true
	elif Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
		$YawLeftCCW.emitting = true
		$YawRightCCW.emitting = true
	else:
		$YawLeftCCW.emitting = false
		$YawRightCCW.emitting = false
		$YawLeftCW.emitting = false
		$YawRightCW.emitting = false

func _process(delta):
	get_input()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)


