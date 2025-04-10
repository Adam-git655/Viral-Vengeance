extends Control

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.play()
	get_tree().change_scene_to_file("res://Scenes and Scripts/Main_Menu.tscn")
