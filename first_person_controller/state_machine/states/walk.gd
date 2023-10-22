class_name Walk extends Motion

@export var speed := 2.2
	
func physics_update(delta):
	super.physics_update(delta)
	
	move(speed, delta)
	
	if owner.velocity.is_zero_approx():
		state_finished.emit("Idle", {})
		return
	
	if Input.is_action_pressed("run"):
		state_finished.emit("Run", {})
		
	detect_jump()
	detect_crouch()
	
	owner.move_and_slide()
	

