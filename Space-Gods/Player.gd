extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector2()
var thrust_min = 100
var rotation_dir = 0.0
var screensize
var zoom_up_lim = 0.1
var zoom_down_lim = 0.5
var zoom_diff = 0.005
var angular_velocity_lim = 1
var linear_velocity_lim = 10
var linear_velocity_min_lim = 1
var auto_destination = Vector2()
var auto_destination_piece
var auto_yaw_on = false
var auto_yaw_dot = 0
var auto_thrust_on = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				move_to_this_position(event.position)
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				print("button wheel up")
				if $Camera2D.zoom > Vector2(zoom_up_lim, zoom_up_lim):
					$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				print("button wheel down")
				if $Camera2D.zoom < Vector2(zoom_down_lim, zoom_down_lim):
					$Camera2D.zoom = $Camera2D.zoom+Vector2(zoom_diff, zoom_diff)

func _ready():
	screensize = get_viewport().get_visible_rect().size

func check_auto_yaw():
	var unit_dir = Vector2.UP.rotated(rotation)
	var move_path = auto_destination - position
	var position_dot = unit_dir.dot(move_path.normalized())
	var angle_diff = move_path.angle_to(unit_dir)
	if position_dot >= 0.99:
		angular_velocity = 0
		auto_yaw_on = false
		if move_path.length() > 10:
			auto_thrust_on = true
	else:
		if (angle_diff < 0) and (abs(angular_velocity) < angular_velocity_lim):
			yaw_cw()
		elif (angle_diff > 0) and (abs(angular_velocity) < angular_velocity_lim):
			yaw_ccw()

func check_auto_thrust():
	var move_path = auto_destination - position
	var move_len = move_path.length()
	if (auto_yaw_dot == 1) and \
	   (move_len > 2*auto_destination_piece) and \
	   (linear_velocity.length() < linear_velocity_lim):
		boost()
	elif (auto_yaw_dot == 1) and \
		 (move_len < 2*auto_destination_piece):
		auto_thrust_on = false
		auto_yaw_dot = -1
		yaw_ccw(10)
		auto_yaw_on = true
	elif (auto_yaw_dot == -1) and \
		 (linear_velocity.length() > linear_velocity_min_lim):
		boost()
	elif (auto_yaw_dot == -1) and (move_len < 5):
		linear_velocity = Vector2.ZERO
		auto_thrust_on = false
		auto_yaw_on = false

func move_to_this_position(this_position):
	auto_destination = this_position
	var move_path = auto_destination - position
	var move_dist = move_path.length()
	auto_destination_piece = move_dist / 3.0
	var unit_dir = Vector2.UP.rotated(rotation)
	var angle_diff = move_path.angle_to(unit_dir)
	print("pos: ({x}, {y})".format({"x": position.x, "y": position.y}))
	print("unt: ({x}, {y})".format({"x": unit_dir.x, "y": unit_dir.y}))
	print("des: ({x}, {y})".format({"x": auto_destination.x, "y": auto_destination.y}))
	print("pth: ({x}, {y})".format({"x": move_path.x, "y": move_path.y}))
	print("dot: {d}".format({"d": unit_dir.dot(move_path.normalized())}))
	print("ang: {d}".format({"d": angle_diff}))
	auto_yaw_on = true
	auto_yaw_dot = 1.0

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
	if auto_yaw_on:
		check_auto_yaw()
	elif auto_thrust_on:
		check_auto_thrust()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
