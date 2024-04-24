extends RigidBody2D

var picked = false

func _physics_process(_delta):
	
	if picked == true:
		self.queue_free()
		
		
func _input(_event):
	if Input.is_action_just_pressed("ui_pickup"):
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and get_node("../../Kid/Player").canPick == true:
				picked = true
				print("picked up")
				get_node("../../Kid/Player").canPick = false
				
