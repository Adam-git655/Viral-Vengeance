extends Node

var completed_levels = 0
var is_level_end = false
var DNA_points:int = 0
var lived_viruses:int = 0 
var skills_unlocked = []
var levels_completed = []

func _process(_delta: float) -> void:
	if is_level_end:
		DNA_points += (lived_viruses/2)
		print(DNA_points)
		is_level_end = false
		
		
