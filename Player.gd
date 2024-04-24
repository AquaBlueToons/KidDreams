extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -450.0
const DreamBall = preload("res://dream ball 2.tscn")
const holdb = preload("res://dream_ball.tscn")
var canPick = true
var firing = false
var health = 5
var jump_count = 0
var max_jump = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var platVel = Vector2(0,0)
@onready var anim = get_node("AnimationPlayerKid")

func _physics_process(delta):
		
	if is_on_floor():
		jump_count = 0
		max_jump = 1
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jump:
		velocity.y = JUMP_VELOCITY
		velocity.x = platVel.x
		jump_count += 1
		
		if canPick == false:
			max_jump = 2
			anim.play("Hold")
			if Input.is_action_just_pressed("ui_accept") and canPick == false and jump_count == 2:
				canPick = true
				anim.play("Jump")
		elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
				anim.play("Lift")
		else:
			anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		if firing == false:
				get_node("AnimatedSprite2D").flip_h = true
				if sign($BallHere.position.x) == 1:
					$BallHere.position.x *= -1
		elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
			anim.play("Lift")
	elif direction == 1:
		if firing == false:
			get_node("AnimatedSprite2D").flip_h = false
			if sign($BallHere.position.x) == -1:
				$BallHere.position.x *= -1
		elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
			anim.play("Lift")
	if direction:
		if firing == false:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				if canPick == false:
					anim.play("Hold walking")
				else:
					anim.play("Walk")
		elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
			anim.play("Lift")
	else:
		if firing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				if canPick == false:

					anim.play("Hold")
				elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
					anim.play("Lift")
				else:
					anim.play("Idle")
			if velocity.y > 0:
				if canPick == false:
					anim.play("Hold")
				elif Input.is_action_just_pressed("ui_pickup") and canPick == true:
					anim.play("Lift")
				else:
					anim.play("Fall")
			if health <= 0:
				queue_free()
				get_tree().change_scene_to_file("res://game_over.tscn")
				
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	platVel = get_platform_velocity()
	fire()
	
func fire():
	if Input.is_action_just_pressed("ui_action") and canPick == false and firing == false:
		canPick = true
		firing = true
		var direction = 1 if not $AnimatedSprite2D.flip_h else -1
		anim.play("Throw")
		var b = DreamBall.instantiate()
		b.direction = direction
		get_parent().add_child(b)
		b.position = $BallHere.global_position
		

func _on_animation_player_kid_animation_finished(_Throw):
	firing = false
	
