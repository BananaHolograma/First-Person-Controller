class_name Jump extends Motion

@export var jump_velocity := 5.0
@export var air_speed := 2.0


func _enter():
	owner.velocity.y = jump_velocity

func physics_update(delta):
	super.physics_update(delta)
	
	if owner.is_on_floor():
		if direction:
			state_finished.emit("Walk", {})
		else:
			state_finished.emit("Idle", {})

	move(air_speed, delta)
	
	owner.move_and_slide()
	
