extends CharacterBody2D
var speed
var speed_multiplier = 1.5
var direction = Vector2.ZERO
var is_attacking = false
var can_attack = false
var current_human = null
@onready var InfectingLabel = get_parent().get_parent().get_node('Camera2D/InfectionLabel')
@onready var StealthModeAvailableLabel = get_parent().get_parent().get_node('Camera2D/StealthModeAvailableLabel')
@onready var Player_Viruses = get_node('/root/' + get_parent().get_parent().name + '/Player_Viruses')
var virus_amount:int
@onready var Player_Virus = preload("res://Scenes and Scripts/virus.tscn")

var is_stealth_mode = false
var can_stealth = false
var stealth_duration = 5.0
var stealth_cooldown = 10.0

var duplicate_probability = 0

const Initial_human_death_wait_time = 3
const initial_wait_time = 3.0
const wait_time_decrease_rate = 0.1



func _ready() -> void:
	get_parent().get_parent().get_node('Camera2D/InfectionLabel').visible = false
	velocity = Vector2.ZERO
	$Human_death_timer.wait_time = Initial_human_death_wait_time
	
	#InfectionRateSkillInit
	for skill in GameManager.skills_unlocked:
		if skill == "InfectionRate":
			$Human_death_timer.wait_time -= 0.5
			
	#SpeedBoostSkillInit
	
	for skill in GameManager.skills_unlocked:
		if skill == "SpeedBoost":
			speed_multiplier += 0.5
			
	#StealthModeSkillInit		
	var count = GameManager.skills_unlocked.count("StealthMode")
	match count:
		1: 
			can_stealth = true
			stealth_duration = 5.0
		2: 
			can_stealth = true
			stealth_duration = 7.0
		3:
			can_stealth = true
			stealth_duration = 10.0
		_:
			can_stealth = false
			
	#RapidReplicationSkillInit
	for skill in GameManager.skills_unlocked:
		if skill == "RapidReplication":
			duplicate_probability += 0.25
			print(duplicate_probability)
			
	$Stealth_mode_duration_timer.wait_time = stealth_duration
	$Stealth_mode_cooldown_timer.wait_time = stealth_cooldown

func _physics_process(_delta: float) -> void:
	$AnimatedSprite2D.play()
	
	if can_attack:
		if Input.is_action_pressed("mouse_button"):
			attack_human()
	else:
		pass
		
	if !is_attacking:	
		direction = (get_global_mouse_position() - position)	
	else:
		if current_human.healthy:
			direction = (current_human.position - position)
		else:
			direction = (get_global_mouse_position() - position)

	var distance = direction.length()
	if distance > 0:
		speed = distance * speed_multiplier
	velocity = (direction.normalized() * speed)
	move_and_slide()

	if Input.is_action_pressed("Spacebar") and !is_stealth_mode and can_stealth and $Stealth_mode_cooldown_timer.is_stopped():
		activate_stealth_mode(stealth_duration)

func activate_stealth_mode(time):
	print(time)
	can_stealth = false
	is_stealth_mode = true
	$AnimatedSprite2D.modulate.a = 0.5
	$Stealth_mode_duration_timer.start(time)
	$Stealth_mode_cooldown_timer.stop()
	
func deactivate_stealth_mode(time):
	is_stealth_mode = false
	$AnimatedSprite2D.modulate.a = 1.0
	$Stealth_mode_cooldown_timer.start(time)
	print("cooldown timer started")

func _on_stealth_mode_duration_timer_timeout() -> void:
	deactivate_stealth_mode(stealth_cooldown)
	
func _on_stealth_mode_cooldown_timer_timeout() -> void:
	print("cooldown timer ended")
	can_stealth = true
	StealthModeAvailableLabel.text = "Stealth mode available!"
	StealthModeAvailableLabel.show()
	$StealthModeAvailableLabelHideTimer.start()

func _on_stealth_mode_available_label_hide_timer_timeout() -> void:
	StealthModeAvailableLabel.hide()
	
func attack_human():
	can_attack = false
	is_attacking = true
	InfectingLabel.visible = true
	$Human_death_timer.start()

func _on_human_death_timer_timeout() -> void:
	can_attack = false
	is_attacking = false
	InfectingLabel.visible = false
	current_human.healthy = false
	
	duplicate_virus()
	
	
func duplicate_virus():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var copies_to_make = 1
	if rng.randf() < duplicate_probability:
		print(rng.randf())
		print("copies are 2")
		copies_to_make = 2
		
	var instance = Player_Virus.instantiate()
	Player_Viruses.add_child(instance)
	instance.position = position
	instance.sync_stealth_state(is_stealth_mode, $Stealth_mode_cooldown_timer.is_stopped() ,$Stealth_mode_duration_timer.time_left, $Stealth_mode_cooldown_timer.time_left)
	
	if copies_to_make == 2:
		var instance2 = Player_Virus.instantiate()
		Player_Viruses.add_child(instance2)
		instance2.position = position + Vector2(2, 2)
		instance2.sync_stealth_state(is_stealth_mode, $Stealth_mode_cooldown_timer.is_stopped() ,$Stealth_mode_duration_timer.time_left, $Stealth_mode_cooldown_timer.time_left)

func _on_virus_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('scientist'):
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('human'):
		if body.healthy:
			current_human = get_node('/root/' + get_parent().get_parent().name + '/Humans/' + body.name)
			can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('human'):
		can_attack = false

func sync_stealth_state(stealth_state, not_in_cooldown_state, stealth_state_remaining_time, cooldown_state_remaining_time):
	if stealth_state:
		activate_stealth_mode(stealth_state_remaining_time)
	elif not_in_cooldown_state == false:
		deactivate_stealth_mode(cooldown_state_remaining_time)
	else:
		is_stealth_mode = false
		$AnimatedSprite2D.modulate.a = 1.0
		





