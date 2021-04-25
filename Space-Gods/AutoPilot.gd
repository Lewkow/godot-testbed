extends Control

var autopilot_on = false
var auto_yaw_on = false
var auto_thrust_on = false
var auto_destination = Vector2()
var auto_destination_piece
var auto_yaw_dot = 0
var auto_pilot_type

func check_auto_yaw():
	var unit_dir = Vector2.UP.rotated(get_parent().rotation)
	var move_path = auto_destination - get_parent().position
	var position_dot = unit_dir.dot(move_path.normalized())
	var angle_diff = move_path.angle_to(unit_dir)
	if position_dot >= 0.99:
		get_parent().angular_velocity = 0
		auto_yaw_on = false
		if move_path.length() > 10:
			auto_thrust_on = true
	else:
		if (angle_diff < 0) and \
		   (abs(get_parent().angular_velocity) < get_parent().angular_velocity_lim):
			get_parent().yaw_cw()
		elif (angle_diff > 0) and \
			 (abs(get_parent().angular_velocity) < get_parent().angular_velocity_lim):
			get_parent().yaw_ccw()

func check_auto_thrust():
	var move_path = auto_destination - get_parent().position
	var move_len = move_path.length()
	if (auto_yaw_dot == 1) and \
	   (move_len > 2*auto_destination_piece) and \
	   (get_parent().linear_velocity.length() < get_parent().linear_velocity_lim):
		get_parent().boost()
	elif (auto_yaw_dot == 1) and \
		 (move_len < 2*auto_destination_piece):
		auto_thrust_on = false
		auto_yaw_dot = -1
		get_parent().yaw_ccw(10)
		auto_yaw_on = true
	elif (auto_yaw_dot == -1) and \
		 (get_parent().linear_velocity.length() > get_parent().linear_velocity_min_lim):
		get_parent().boost()
	elif (auto_yaw_dot == -1) and (move_len < 5):
		get_parent().linear_velocity = Vector2.ZERO
		auto_thrust_on = false
		auto_yaw_on = false

func move_to_this_position(this_position):
	auto_destination = this_position
	var move_path = auto_destination - get_parent().position
	var move_dist = move_path.length()
	auto_destination_piece = move_dist / 3.0
	var unit_dir = Vector2.UP.rotated(get_parent().rotation)
	var angle_diff = move_path.angle_to(unit_dir)
	print("pos: ({x}, {y})".format({"x": get_parent().position.x, "y": get_parent().position.y}))
	print("unt: ({x}, {y})".format({"x": unit_dir.x, "y": unit_dir.y}))
	print("des: ({x}, {y})".format({"x": auto_destination.x, "y": auto_destination.y}))
	print("pth: ({x}, {y})".format({"x": move_path.x, "y": move_path.y}))
	print("dot: {d}".format({"d": unit_dir.dot(move_path.normalized())}))
	print("ang: {d}".format({"d": angle_diff}))
	auto_yaw_on = true
	auto_yaw_dot = 1.0
