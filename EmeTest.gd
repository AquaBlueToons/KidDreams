extends CharacterBody2D

const drop = preload("res://dream_ball.tscn")
var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var knocked = false
func _ready():
	get_node("AnimatedSprite2D").play("Stand")
func _physics_process(delta):
	#gravity for monster
	velocity.y += gravity * delta
	if chase == true:
		player = get_node("../../Kid/Player")
		var direction = (player.global_position - self.global_position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
	move_and_slide()
	
	
	
func _on_player_decction_body_entered(body):
	if body.name == "Player":
		chase = true
		print()
	

func _on_player_decction_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_hit_body_entered(body):
	if body.name == "ball":
		chase = false
		get_node("AnimatedSprite2D").play("Knock Down")
		await get_node("AnimatedSprite2D").animation_finished
		print("done")
		self.queue_free()

func _on_owwie_zone_body_entered(body):
	if body.name == "Player":
		body.health -= 1
		chase = false


func _on_player_hit_area_entered(area):
	if area.name == "HitBox":
		chase = false
		knocked = true
		get_node("AnimatedSprite2D").play("Knock Down")
		await get_node("AnimatedSprite2D").animation_finished
		print("done")
		spawn_item()
		print("spawned")
		self.queue_free()
		
func spawn_item():
	var d = drop.instantiate()
	get_parent().add_child(d)
	d.position = self.global_position 
