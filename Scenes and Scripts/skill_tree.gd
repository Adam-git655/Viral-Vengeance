extends Control

func _process(delta: float) -> void:
	$DNA_points_Label.text = ("DNA POINTS: " + str(GameManager.DNA_points))

func _on_level_selector_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/level_selector_screen.tscn")
