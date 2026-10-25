extends Control

func _on_play_pressed() -> void:
	print("PLAY BUTTON CLICKED")
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
