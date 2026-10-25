extends Control

@onready var scoreText = $score

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _ready() -> void:
	scoreText.text = "score: " + str(GameData.finalScore)
