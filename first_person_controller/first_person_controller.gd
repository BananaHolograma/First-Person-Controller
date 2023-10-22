class_name Player extends CharacterBody3D

@onready var neck: Node3D = %Neck
@onready var head: Node3D = %Head
@onready var eyes: Node3D = %Eyes
@onready var camera_3d: Camera3D = $Neck/Head/Eyes/Camera3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine

## MOUSE AND CAMERA SENSITIVITY
@export_group("Sensitivity")
## The global sensitivity with the mouse that is applied in the entire game camera movement
@export var MOUSE_SENSITIVITY = GlobalSettings.MOUSE_SENSITIVITY
## The camera sensitivity to balance the smoothness of the rotation
@export_range(0, 1, 0.01) var CAMERA_SENSITIVITY := 0.3

## FREE LOOK FEATURE ##
@export_group("Free look")
## Free look feature is active for the controller
@export var FREE_LOOK_ENABLED := true
## The smoothness applied when neck is rotated on free look
@export var FREE_LOOKING_LERP_SPEED := 10.0
## The tilt on degrees for the neck when free look is active
@export var FREE_LOOK_TILT := 5.0
## The initial rotation when free look is active, set to max value to rotate directly the neck to the maximum rotation
@export var FREE_LOOK_INITIAL_ROTATION := 0
## The maximum neck rotation when the character is free looking
@export var FREE_LOOK_MAXIMUM_ROTATION := 120


var IS_FREE_LOOKING := false
var LOCKED := false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	animation_player.play("idle")


func _input(event: InputEvent):
	rotate_camera_smoothly(event)
	
func _physics_process(delta):
	free_look(delta)
	
## Rotate the neck of the CharacterBody3D
# to achieve a realistic head movement on the first person controller.
# This function also detects if free looking is active to move only the head
##
func rotate_camera_smoothly(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var twist_input = event.relative.x / 1000 * MOUSE_SENSITIVITY 
		var pitch_input = event.relative.y / 1000 * MOUSE_SENSITIVITY 
		
		var target_rotation_y = rotation.y - twist_input # Body rotation
		var target_rotation_x = neck.rotation.x - pitch_input # Neck rotation
		target_rotation_x = clamp(target_rotation_x , PI / -2, PI / 2)
		
		if IS_FREE_LOOKING:
			head.rotation.y -= twist_input
			head.rotation.y = clamp(head.rotation.y, deg_to_rad(-FREE_LOOK_MAXIMUM_ROTATION), deg_to_rad(FREE_LOOK_MAXIMUM_ROTATION))
		else:
			rotation.y =  lerp_angle(rotation.y, target_rotation_y, CAMERA_SENSITIVITY)
			
		neck.rotation.x = lerp_angle(neck.rotation.x, target_rotation_x, CAMERA_SENSITIVITY)


func free_look(delta: float = get_physics_process_delta_time()):
	if FREE_LOOK_ENABLED:
		if Input.is_action_pressed("free_look"):
			IS_FREE_LOOKING = true
			camera_3d.rotation.z = deg_to_rad(head.rotation.y * FREE_LOOK_TILT)
		else:
			IS_FREE_LOOKING = false
			head.rotation.y = lerp(head.rotation.y, 0.0, delta * FREE_LOOKING_LERP_SPEED)
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * FREE_LOOKING_LERP_SPEED)


func _switch_mouse_mode() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
