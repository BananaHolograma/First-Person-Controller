class_name Motion extends State

@onready var finite_state_machine = get_parent()  as FiniteStateMachine
@onready var animation_player = owner.get_node("AnimationPlayer")
@onready var ceil_
@export var gravity: float =  ProjectSettings.get_setting("physics/3d/default_gravity")
@export var friction: float = 7.0
@export var fall_velocity_limit: float = 200.0

var direction := Vector3.ZERO

func physics_update(delta: float):
	direction = get_input_direction()["direction"]
	
	if not owner.is_on_floor():
		owner.velocity.y -= gravity * delta
		owner.velocity.y = clamp(owner.velocity.y, -fall_velocity_limit, fall_velocity_limit)
	

func move(speed: float, delta: float = get_physics_process_delta_time()):
	if direction:
		owner.velocity.x = direction.x * speed
		owner.velocity.z = direction.z * speed
	else:
		# https://github.com/godotengine/godot/pull/73873
		owner.velocity.x = lerp(owner.velocity.x, direction.x * speed, delta * friction)
		owner.velocity.z = lerp(owner.velocity.z, direction.z * speed, delta * friction)
		
		
func detect_jump():
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		state_finished.emit("Jump", {})

func detect_crouch():
	if Input.is_action_pressed("crouch") and owner.is_on_floor():
		state_finished.emit("Crouch", {})

	
func get_input_direction() -> Dictionary:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return {
		"input_direction": input_dir,
		"direction": (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	} 



