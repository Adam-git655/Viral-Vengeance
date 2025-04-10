extends Node2D
@onready var VirusPlayer = preload("res://Scenes and Scripts/virus.tscn")
@onready var Virus = get_node("Player_Viruses/Virus")
@onready var Player_Viruses = get_node("Player_Viruses")
@onready var camera2d = $Camera2D
@onready var TopRightLabel = $Camera2D/StealthModeAvailableLabel
var can_check_infected_humans = false
var infected_humans:int = 0
var all_humans_infected = false
var can_move_to_next_level = true
var can_die = true
@onready var next_level_number = (int(self.name.substr(6,6)) + 1)


func _ready() -> void:
	can_move_to_next_level = true
	can_check_infected_humans = false
	infected_humans = 0
	all_humans_infected = false
	can_die = true
	GameManager.lived_viruses = 0
	print(self.name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(_delta: float) -> void:
	$GameOverFlag/AnimatedSprite2D.play()
	
	#Reload level when all virus particles are ded
	if Player_Viruses.get_child_count() < 1 and can_die == true:
		get_tree().change_scene_to_file("res://Levels/" + self.name + ".tscn")
		can_die = false
		
	#Logic to keep the camera position at the centre of the virus horde
	var total_position = Vector2.ZERO
	for child in Player_Viruses.get_children():
		total_position += child.global_position
	var centre_point = total_position / Player_Viruses.get_child_count()
	camera2d.position = centre_point
	
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes and Scripts/level_selector_screen.tscn")

func _on_level_complete_body_entered(body: Node2D) -> void:
	if body.is_in_group('viruses'):
		if can_move_to_next_level: 
			
			CheckNumberOfInfectedHumans()			
						
			#If all humans in the map are infected
			if infected_humans >= $Humans.get_child_count(): 
				
				#Check if we are at the last level or not
				if self.name != 'Level_4':
					
					#If the level we just completed has been completed before then directly switch to next level
					if GameManager.levels_completed.has(self.name):
						call_deferred("SwitchToNextLevel")
						
					#If the level we just completed has been completed for the first time then do some other stuff and then switch to the next level
					else:
						GameManager.lived_viruses = Player_Viruses.get_child_count()
						GameManager.is_level_end = true
						GameManager.completed_levels += 1		
						GameManager.levels_completed.append(self.name)	
						
						TopRightLabel.show()
						TopRightLabel.text = ("+ " + str(GameManager.lived_viruses/2) + " DNA Points")
						call_deferred("SwitchToNextLevel")
				
				#If at the last level then you won yay
				else:
					call_deferred("OnGameWon")
			
			#If all humans in map are not infected, then tell the player just that by a label
			else:
				$Camera2D/Label.visible = true
				$Timer.start()

				
func CheckNumberOfInfectedHumans() -> void:
	infected_humans = 0
	for human in $Humans.get_children():
		if !human.healthy:
			infected_humans += 1
			
func OnGameWon() -> void:
	GameManager.completed_levels += 1
	get_tree().change_scene_to_file("res://Scenes and Scripts/GameWon.tscn")
	can_move_to_next_level = false
					
func SwitchToNextLevel() -> void:
	await get_tree().create_timer(0.7).timeout
	TopRightLabel.hide()
	get_tree().change_scene_to_file("res://Levels/" + self.name.substr(0, 6) + str(next_level_number) + '.tscn')
	can_move_to_next_level = false
			
func _on_timer_timeout() -> void:
	$Camera2D/Label.visible = false
