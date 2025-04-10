extends CharacterBody2D

var speed = 300
var player_chase = false
var can_shoot_player = true
var viruses_in_area = 0

var player = null
@onready var Level = get_node('/root/' + get_parent().name)
@onready var Camera2d = get_node('/root/' + get_parent().name + '/Camera2D')

var vial_bullet_scene = preload("res://Scenes and Scripts/vial_bullet.tscn")
@export var vial_bullet_count = 10
@export var vial_spawn_offset = 60	

func _ready() -> void:
	randomize()
	print('/root/' + get_parent().name)

func _physics_process(delta: float) -> void:
	if player_chase and player != null:
		if can_shoot_player:
			$AnimatedSprite2D.play()
			shoot()
			$vial_shoot_cooldown.start()
			can_shoot_player = false	
		if player.is_stealth_mode == true:
			player_chase = false					
	else:
		$AnimatedSprite2D.stop()
	
	if player != null:
		if player.is_stealth_mode == false:
			player_chase = true	
			
func shoot():
	if can_shoot_player:
		var angle_step = 2 * PI / vial_bullet_count
		
		var spawn_position = self.global_position
		
		var starting_angle = randf() * 2 * PI
		
		for i in range(vial_bullet_count):
			var vial_bullet_instance = vial_bullet_scene.instantiate()
			Level.add_child(vial_bullet_instance)
			vial_bullet_instance.global_position = spawn_position
			
			var angle = starting_angle + i * angle_step
			var direction = Vector2(cos(angle), sin(angle))
			vial_bullet_instance.dir = direction.normalized()
			vial_bullet_instance.position += direction * vial_spawn_offset 
		

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('viruses'):
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
	
	
