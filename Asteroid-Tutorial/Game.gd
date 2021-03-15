extends Node2D

var is_game_over := false
var player_scene = load("res://characters/Player.tscn")

func _respawn_player():
	var player = player_scene.instance()
	player.position = Vector2(626, 680)
	add_child(player)
	
func _unhandled_input(event: InputEvent) -> void:
	if (is_game_over and event.is_action_released("restart_game")):
		_restart_game()

func _restart_game():
	_undo_game_over()
	_respawn_player()
	$AsteroidSpawner.restart()
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.reset()
	is_game_over = false

func _undo_game_over():
	$GameOverLabel.visible = false
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_03_-_Towel_Defence_Ingame.ogg")
	$MusicPlayer.stream.loop = true
	$MusicPlayer.volume_db = -10
	$MusicPlayer.play(0)

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
	is_game_over = true
