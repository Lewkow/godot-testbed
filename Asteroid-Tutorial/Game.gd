extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Game Over
func _on_Player_player_died() -> void:
	
	# stop gameplay music and load "game over" music
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_06_-_Towel_Defence_Jingle_Loose.ogg")
	$MusicPlayer.stream.loop = false
	$MusicPlayer.volume_db = -5

	# stop new asteroids from spawning
	$AsteroidSpawner/SpawnTimer.stop()

	# turn off "roaring" sound for every already-spawned asteroid
	for a in get_tree().get_nodes_in_group("asteroids"):
		if (!a.is_queued_for_deletion() and a.has_node("AudioStreamPlayer2D")):
			a.get_node("AudioStreamPlayer2D").stop()

	$GameOverTimer.start()

func _on_GameOverTimer_timeout() -> void:
	# play "game over" music and show "game over" screen
	$MusicPlayer.play(0)
	$GameOverLabel.visible = true
