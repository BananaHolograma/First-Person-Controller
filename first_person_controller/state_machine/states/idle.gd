class_name Idle extends Motion


func physics_update(delta):
	super.physics_update(delta)
	
	if not direction.is_zero_approx():
		state_finished.emit("Walk", {})
		
	detect_jump()

