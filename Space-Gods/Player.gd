extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector2()
var rotation_dir = 0.0
var screensize
var zoom_up_lim = 0.1
var zoom_down_lim = 0.75
var zoom_diff = 0.05
var angular_velocity_lim = 5
var linear_velocity_lim = 10
var auto_destination = Vector2()
var auto_yaw_rad = 0.0
var auto_yaw_on = false
var auto_thrust_on = false

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

func check_auto_yaw():
	var move_path = auto_destination - position
	var angle_diff = move_path.angle_to(Vector2.UP.rotated(rotation))
	if abs(angle_diff) < 0.01:
		angular_velocity = 0
		auto_yaw_on = false
	else:
		if angle_diff < 0 and abs(angular_velocity) < angular_velocity_lim:
			# rotate CW
			yaw_cw()
		elif angle_diff > 0 and abs(angular_velocity) < angular_velocity_lim:
			# rotate CCW
			yaw_ccw()

func check_auto_thrust():
	var thrust_min = 100
	var move_path = auto_destination - position
	var move_len = move_path.length()
	if move_len > thrust_min and abs(linear_velocity.length()) < linear_velocity_lim:
		auto_boost()

func move_to_this_position(this_position):
	auto_destination = this_position
	var move_path = auto_destination - position
	var move_dist = move_path.length()
	var unit_dir = Vector2.UP.rotated(rotation)
	var angle_diff = move_path.angle_to(unit_dir)
	print("pos: ({x}, {y})".format({"x": position.x, "y": position.y}))
	print("unt: ({x}, {y})".format({"x": unit_dir.x, "y": unit_dir.y}))
	print("des: ({x}, {y})".format({"x": auto_destination.x, "y": auto_destination.y}))
	print("pth: ({x}, {y})".format({"x": move_path.x, "y": move_path.y}))
	print("ang: {d}".format({"d": angle_diff}))
	auto_yaw_rad = angle_diff
	auto_yaw_on = true
	auto_thrust_on = true
	if angle_diff < 0:
		# rotate CW
		yaw_cw()
	else:
		# rotate CCW
		yaw_ccw()

func auto_boost():
	thrust = Vector2(0, -engine_thrust)
	$MainThrusters.emitting = true

func yaw_cw():
	rotation_dir += 1
	$YawLeftCW.emitting = true
	$YawRightCW.emitting = true

func yaw_ccw():
	rotation_dir -= 1
	$YawLeftCCW.emitting = true
	$YawRightCCW.emitting = true

func get_input():
	if Input.is_action_pressed("ui_up"):
		auto_boost()
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
	get_input()
	if auto_yaw_on:
		check_auto_yaw()
	elif auto_thrust_on:
		check_auto_thrust()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
