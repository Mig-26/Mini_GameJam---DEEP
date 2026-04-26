extends Control

# Replace this with the actual path to your first level
@export_file("*.tscn") var main_game_scene: String = "res://Scenes/main.tscn"

func _on_continue_pressed() -> void:
	# loading main level scene
	if main_game_scene != "":
		get_tree().change_scene_to_file(main_game_scene)
	else:
		print("Error: No main game scene assigned to the Continue button!")

func _on_quit_pressed() -> void:
	get_tree().quit()
