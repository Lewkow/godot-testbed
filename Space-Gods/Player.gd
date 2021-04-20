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
	if event in InputEventMouseButton and event.is_pressed():
		print('cat')
		if event.button_index == BUTTON_WHEEL_UP:
			if $Camera2D.zoom > Vector2(zoom_up_lim, zoom_up_lim):
				$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			if $Camera2D.zoom < Vector2(zoom_down_lim, zoom_down_lim):
				$Camera2D.zoom = $Camera2D.zoom-Vector2(zoom_diff, zoom_diff)

func _ready():
	screensize = get_viewport().get_visible_rect().size

func get_input():
	if Input.is_action_pressed("ui_up"):
		thrust = Vector2(0, -engine_thrust)
	else:
		thrust = Vector2()
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1

func _process(delta):
	get_input()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)


