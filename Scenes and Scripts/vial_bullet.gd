extends Area2D

var dir 
var speed = 400
var vial_explosion_particles = preload("res://Scenes and Scripts/vial_explosion_particles.tscn")

func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('viruses'):
		#$AudioStreamPlayer.play()
		var instance = vial_explosion_particles.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = body.position
		instance.rotation = global_rotation
		instance.emitting = true

		body.queue_free()
				
	if body.name == 'TileMap':
	#	$AudioStreamPlayer.play()
		var instance = vial_explosion_particles.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = global_position
		instance.rotation = global_rotation
		instance.emitting = true
		queue_free()
		
		
	if body.is_in_group('human'):
	#	$AudioStreamPlayer.play()
		var instance = vial_explosion_particles.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = global_position
		instance.rotation = global_rotation
		instance.emitting = true
		queue_free()
		
