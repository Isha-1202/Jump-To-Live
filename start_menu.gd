extends CenterContainer





func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
