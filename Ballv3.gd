extends CharacterBody2D



func _physics_process(_delta):
	
	
	if  get_node("../../Kid/Player").canPick == false:
		self.position = get_node("../../Player/hold").position
		
		
	if  get_node("../../Kid/Player").canPick == true:
		queue_free()
