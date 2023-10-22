class_name Jump extends Motion

## The height of the jump
@export var jump_velocity := 5.0
## The speed when moves horizontally in the air
@export var air_speed := 2.0
## Will be multiplied by delta
@export var lerp_smoothness := 3.0

func _enter():
	owner.velocity.y = jump_velocity

func physics_update(delta):
	super.physics_update(delta)
	
	if owner.is_on_floor():
		if direction:
			state_finished.emit("Walk", {})
		else:
			state_finished.emit("Idle", {})
	
	owner.velocity.x = lerp(owner.velocity.x, direction.x * air_speed, delta * lerp_smoothness)
	owner.velocity.z = lerp(owner.velocity.z, direction.z * air_speed, delta * lerp_smoothness)
	
	owner.move_and_slide()
	
