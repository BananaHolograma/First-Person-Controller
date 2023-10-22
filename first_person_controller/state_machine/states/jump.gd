class_name Jump extends Motion

## The height of the jump
@export var jump_velocity := 5.0
@export var jump_times := 1
## The speed when moves horizontally in the air
@export var air_speed := 2.0
## Will be multiplied by delta
@export var lerp_smoothness := 3.0

var jump_count := 1

func _enter():
	if not previous_states.is_empty() and previous_states.back() is Slide:
		animation_player.play_backwards("crouch")
	
	owner.velocity.y = jump_velocity

func _exit():
	jump_count = 1

func physics_update(delta):
	super.physics_update(delta)
	
	if owner.is_on_floor():
		if direction:
			state_finished.emit("Walk", {})
		else:
			state_finished.emit("Idle", {})
	
	owner.velocity.x = lerp(owner.velocity.x, direction.x * air_speed, delta * lerp_smoothness)
	owner.velocity.z = lerp(owner.velocity.z, direction.z * air_speed, delta * lerp_smoothness)
	
	if Input.is_action_just_pressed("jump") and jump_times > 1 and jump_count < jump_times:
		owner.velocity.y = jump_velocity
		jump_count += 1
		
	if Input.is_action_just_released("jump"):
		shorten_jump()
		
	owner.move_and_slide()


func shorten_jump():
	var new_jump_velocity = jump_velocity / 2

	if owner.velocity.y > new_jump_velocity:
		owner.velocity.y = new_jump_velocity


