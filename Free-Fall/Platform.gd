extends StaticBody2D

var has_fallen = false

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	if has_fallen == false:
		has_fallen = true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if has_fallen:
		has_fallen = false
		queue_free()
