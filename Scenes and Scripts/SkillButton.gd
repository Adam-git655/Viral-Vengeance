extends TextureButton
class_name SkillNode

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D
@onready var DescriptionPanel = get_node("/root/SkillTree/DescriptionPanel")

func _ready() -> void:
	DescriptionPanel.hide()
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
		
	if GameManager.skills_unlocked != null:
		for i in GameManager.skills_unlocked:
			if i == self.name:
				level += 1
				self.disabled = false
				panel.show_behind_parent = true
				line_2d.default_color = Color(0.12050797790289, 0.55710220336914, 0.11587921530008)
				enable_child_skills()
				

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"
				


func _on_pressed() -> void:
	if GameManager.DNA_points > 0 and level < 3:
		level = min(level+1, 3)
		panel.show_behind_parent = true
		line_2d.default_color = Color(0.12050797790289, 0.55710220336914, 0.11587921530008)
		GameManager.skills_unlocked.append(self.name)
		GameManager.DNA_points -= 1
		enable_child_skills()
		
				
func enable_child_skills():
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and  level == 1:
			skill.disabled = false



func _on_mouse_entered() -> void:
	DescriptionPanel.show()
	if self.name == "InfectionRate":
		DescriptionPanel.get_child(0).text = "INFECTION RATE BOOST"
		DescriptionPanel.get_child(1).text = "Decreases the time required for infecting a human"
		DescriptionPanel.get_child(2).text = "-0.5 seconds for each skill level"
	elif self.name == "StealthMode":
		DescriptionPanel.get_child(0).text = "STEALTH MODE"
		DescriptionPanel.get_child(1).text = "Induces a DNA mutation in the viruses granting them the ability to become undetectable from scientists for a short duration of time. Press Spacebar to use."
		DescriptionPanel.get_child(2).text = "Skill Level 1: 5 seconds
												Skill Level 2: 7 seconds
												Skill Level 3: 10 seconds"
	elif self.name == "SpeedBoost":
		DescriptionPanel.get_child(0).text = "SPEED BOOST"
		DescriptionPanel.get_child(1).text = "Increases the move speed of the virus horde"
		DescriptionPanel.get_child(2).text = "+0.5 speed for each skill level "
	elif self.name == "RapidReplication":
		DescriptionPanel.get_child(0).text = "RAPID REPLICATION"
		DescriptionPanel.get_child(1).text = "Increases the amount of viruses replicated after each infection"
		DescriptionPanel.get_child(2).text = "Skill Level 1: 25% Chance of Extra viruses
												Skill Level 2: 50% Chance of Extra viruses
												Skill Level 3: 75% Chance of Extra viruses"
	else:
		DescriptionPanel.get_child(0).text = "NA (to be added)"
		DescriptionPanel.get_child(1).text = "NA"
		DescriptionPanel.get_child(2).text = "NA"


func _on_mouse_exited() -> void:
	DescriptionPanel.hide()
