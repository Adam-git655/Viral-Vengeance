extends CharacterBody2D

var speed = 300
var player_chase = false
var can_shoot_player = true
var viruses_in_area = 0


var player = null
var vial_bullet_scene = preload("res://Scenes and Scripts/vial_bullet.tscn")
@onready var Level = get_node('/root/' + get_parent().name)
@onready var Camera2d = get_node('/root/' + get_parent().name + '/Camera2D')
@onready var raycast = $RayCast2D

func _ready() -> void:
	print('/root/' + get_parent().name)

func _physics_process(_delta: float) -> void:
	if player_chase and player != null:
		#if player.is_attacking == false:
		#var direction = (player.position - position).normalized()
		#velocity = direction * speed 
		#move_and_slide()
		#position += (player.position - position) / speed
		if can_shoot_player:
			$AnimatedSprite2D.play()
			if player.position.x > position.x:
				$AnimatedSprite2D.flip_h = false
			elif player.position.x <= position.x:
				$AnimatedSprite2D.flip_h = true
			var instance = vial_bullet_scene.instantiate()
			Level.add_child(instance)
			instance.position = position
			instance.dir = (player.position - position).normalized()
			$vial_shoot_cooldown.start()
			can_shoot_player = false	
		if player.is_stealth_mode == true:
			player_chase = false			
	else:
		$AnimatedSprite2D.stop()
	
	if player != null:
		if player.is_stealth_mode == false:
			player_chase = true	
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('viruses') :
		viruses_in_area += 1
		if viruses_in_area >= 1 and body.is_stealth_mode == false:
			player = body
			player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('viruses'):
		viruses_in_area -= 1
		if viruses_in_area == 0:
			player = null 
			player_chase = false


func _on_vial_shoot_cooldown_timeout() -> void:
	can_shoot_player = true
