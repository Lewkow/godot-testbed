extends RigidBody2D

var screen_size
var speed

func _ready():
	screen_size = get_viewport_rect().size
	speed = 100
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "hydrogen-1-stand"


func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.animation = "hydrogen-1-walk"
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.animation = "hydrogen-1-walk"
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		$AnimatedSprite.animation = "hydrogen-1-stand"

#	position += velocity * delta
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)
		
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
