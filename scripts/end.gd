extends Control

@export_file("*.tscn") var main_game_scene: String = "res://Scenes/main.tscn"

func _on_play_again_pressed() -> void:
	if main_game_scene != "":
		get_tree().change_scene_to_file(main_game_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
