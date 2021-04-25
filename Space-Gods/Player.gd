extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector2()
var thrust_min = 100
var rotation_dir = 0.0
var screensize
var zoom_up_lim = 0.1
var zoom_down_lim = 0.9
var zoom_diff = 0.005
var angular_velocity_lim = 1
var linear_velocity_lim = 10
var linear_velocity_min_lim = 1

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				$AutoPilot.move_to_this_position(event.position)
			elif event.button_index == BUTTON_WHEEL_UP:
				if $Camera2D.zoom > Vector2(zoom_up_lim, zoom_up_lim):
					$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if $Camera2D.zoom < Vector2(zoom_down_lim, zoom_down_lim):
					$Camera2D.zoom = $Camera2D.zoom+Vector2(zoom_diff, zoom_diff)

func _ready():
	screensize = get_viewport().get_visible_rect().size

func boost():
	thrust = Vector2(0, -engine_thrust)
	$MainThrusters.emitting = true

func yaw_cw(mag=1):
	rotation_dir += mag
	$YawLeftCW.emitting = true
	$YawRightCW.emitting = true

func yaw_ccw(mag=1):
	rotation_dir -= mag
	$YawLeftCCW.emitting = true
	$YawRightCCW.emitting = true

func get_manual_input():
	if Input.is_action_pressed("ui_up"):
		boost()
	elif Input.is_action_pressed("ui_right"):
		yaw_cw()
	elif Input.is_action_pressed("ui_left"):
		yaw_ccw()
	else:
		thrust = Vector2()
		$MainThrusters.emitting = false
		$YawLeftCCW.emitting = false
		$YawRightCCW.emitting = false
		$YawLeftCW.emitting = false
		$YawRightCW.emitting = false

func _process(delta):
	rotation_dir = 0
	get_manual_input()
	if $AutoPilot.auto_yaw_on:
		$AutoPilot.check_auto_yaw()
	elif $AutoPilot.auto_thrust_on:
		$AutoPilot.check_auto_thrust()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
