class_name Motion extends State

@onready var animation_player: AnimationPlayer = owner.get_node("AnimationPlayer")
@onready var finite_state_machine = get_parent()  as FiniteStateMachine

@export var gravity: float =  ProjectSettings.get_setting("physics/3d/default_gravity")
var direction := Vector3.ZERO


func physics_update(_delta):
	direction = get_input_direction()["direction"]
	

func get_input_direction() -> Dictionary:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return {
		"input_direction": input_dir,
		"direction": (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	} 


