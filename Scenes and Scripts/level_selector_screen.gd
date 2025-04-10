extends Control

const LEVEL_BUTTON = preload("res://Scenes and Scripts/level_select_button.tscn")

@export_dir var directory_path 


@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	get_levels(directory_path)
	update_buttons()

func get_levels(path):
	
	#Go through each level in the directory path "res://Levels", and add it to the level selector scene as a new button
	
	var directory = DirAccess.open(path)
	if directory:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		
		if '.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')
		
		while file_name != "":
			create_level_button('%s/%s' % [directory.get_current_dir(), file_name], file_name)
			file_name = directory.get_next()
			
			if '.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			
		directory.list_dir_end()
	else:
		print("An Error occured while trying to access the path")


#Create the level button
func create_level_button(level_path: String, level_name: String):		
	var button = LEVEL_BUTTON.instantiate()
	button.text = level_name.trim_suffix(".tscn").replace("_", " ")
	button.level_path = level_path
	grid.add_child(button)

#Update the completed levels every time after opening the level selector screen
func update_buttons():
	for i in range(grid.get_child_count()):
		if i <= GameManager.completed_levels:
			grid.get_child(i).disabled = false
		else:
			grid.get_child(i).disabled = true

func _on_skill_tree_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/skill_tree.tscn")
