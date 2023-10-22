class_name Crouch extends Motion

@export var speed := 1.0

func _enter() -> void:
	if previous_states.is_empty() or not previous_states.back().name in ["Crawl", "Slide"]:
		animation_player.play("crouch")

	
func _exit() -> void:
	animation_player.play_backwards("crouch")
		

func physics_update(delta):
	super.physics_update(delta)
	
	if not Input.is_action_pressed("crouch") and not ceil_shape_cast.is_colliding():
		if owner.velocity.is_zero_approx():
			state_finished.emit("Idle", {})
		else:
			state_finished.emit("Walk", {})
	
	if Input.is_action_just_pressed("crawl") and not animation_player.is_playing():
		state_finished.emit("Crawl", {})
		
	move(speed, delta)
	owner.move_and_slide()

