class_name Player extends CharacterBody3D

@onready var neck: Node3D = %Neck
@onready var head: Node3D = %Head
@onready var eyes: Node3D = %Eyes
@onready var camera_3d: Camera3D = $Neck/Head/Eyes/Camera3D
@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine
@onready var standing_collision_shape_3d: CollisionShape3D = $StandingCollisionShape3D
@onready var crouch_collision_shape_3d: CollisionShape3D = $CrouchCollisionShape3D
@onready var crawl_collision_shape_3d: CollisionShape3D = $CrawlCollisionShape3D

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

@export_group("Head bobbing")
## Enable head bobbing for this FPS
@export var BOB_ENABLED := true
@export var BOB_VECTOR := Vector2.ZERO
@export var BOB_INDEX := 0.0
@export var BOB_LERP_SPEED := 10.0
@export var BOB_SPEED = 7.5
@export var BOB_INTENSITY = 0.1
@export var BOB_SPEED_RUN = 10.0
@export var BOB_INTENSITY_RUN = 0.15
@export var BOB_SPEED_CROUCH = 6.0
@export var BOB_INTENSITY_CROUCH = 0.05

@export_group("Swing head")
## Enable the swing head when move on horizontal axis (right & left)
@export var SWING_HEAD_ENABLED := false
## The rotation swing to apply in degrees
@export var SWING_HEAD_ROTATION := 5
@export var SWING_HEAD_ROTATION_LERP := 0.05
@export var SWING_HEAD_RECOVERY_LERP := 0.15

@export_group("Camera FOV")
@export var camera_fov_range = [2, 75.0, 85.0, 8.0]

@export_group("Mechanics")
@export var CAN_JUMP := false
@export var CAN_WALL_RUN := false
## Run needs to be active also to use the slide
@export var CAN_SLIDE := false
@export var CAN_RUN := true
@export var CAN_CROUCH := true
@export var CAN_CRAWL := true

var IS_FREE_LOOKING := false
var LOCKED := false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	standing_collision_shape_3d.disabled = false
	crouch_collision_shape_3d.disabled = true
	crawl_collision_shape_3d.disabled = true
	
	GlobalEvents.lock_player.connect(lock_player.bind(true))
	GlobalEvents.unlock_player.connect(lock_player.bind(false))


func _input(event: InputEvent):
	if not LOCKED:
		rotate_camera_smoothly(event)
		
	_switch_mouse_mode()
	

func _physics_process(delta):
	if not LOCKED:
		free_look(delta)
		bobbing(delta)
		camera_fov(delta)
		swing_head()
		adjust_collision_shapes()
		

func adjust_collision_shapes() -> void:
	match(finite_state_machine.current_state.name):
		"Crouch", "Slide":
			standing_collision_shape_3d.disabled = true
			crouch_collision_shape_3d.disabled = false
			crawl_collision_shape_3d.disabled = true
		"Crawl":
			standing_collision_shape_3d.disabled = true
			crouch_collision_shape_3d.disabled = true
			crawl_collision_shape_3d.disabled = false
		_:
			standing_collision_shape_3d.disabled = false
			crouch_collision_shape_3d.disabled = true
			crawl_collision_shape_3d.disabled = true

	
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
		if Input.is_action_pressed("free_look") or finite_state_machine.current_state_name_is("Slide"):
			IS_FREE_LOOKING = true
			camera_3d.rotation.z = deg_to_rad(head.rotation.y * FREE_LOOK_TILT)
		else:
			IS_FREE_LOOKING = false
			head.rotation.y = lerp(head.rotation.y, 0.0, delta * FREE_LOOKING_LERP_SPEED)
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * FREE_LOOKING_LERP_SPEED)


func bobbing(delta: float = get_physics_process_delta_time()) -> void:
	if BOB_ENABLED and is_on_floor():
		var current_state = finite_state_machine.current_state as State
		
		if not current_state.direction.is_zero_approx():
			## Default values for head bob
			var head_bobbing_speed = BOB_SPEED
			var head_bobbing_intensity = BOB_INTENSITY
			var head_bobbing_active := false
			
			## Activate head bobbing only on few states
			match(current_state.name):
				"Walk":
					head_bobbing_active = true
				"Run":
					head_bobbing_speed = BOB_SPEED_RUN
					head_bobbing_intensity = BOB_INTENSITY_RUN
					head_bobbing_active = true
				"Crouch", "Crawl":
					head_bobbing_speed = BOB_SPEED_CROUCH
					head_bobbing_intensity = BOB_INTENSITY_CROUCH
					head_bobbing_active = true
				_:
					head_bobbing_active = false
			
			if head_bobbing_active:
				BOB_INDEX += head_bobbing_speed * delta
			
				BOB_VECTOR.y = sin(BOB_INDEX)
				BOB_VECTOR.x = sin(BOB_INDEX / 2) * 0.5

				eyes.position = eyes.position.move_toward(Vector3(
					BOB_VECTOR.x * head_bobbing_intensity,
					BOB_VECTOR.y * (head_bobbing_intensity / 2.0),
					eyes.position.z
				), delta * BOB_LERP_SPEED)
		else:
			eyes.position.move_toward(Vector3.ZERO, delta * BOB_LERP_SPEED)


func swing_head() -> void:
	if SWING_HEAD_ENABLED:
		var direction := get_input_direction()

		if direction["input_direction"] in [Vector2.RIGHT, Vector2.LEFT]:
			neck.rotation.z = lerp_angle(neck.rotation.z, -sign(direction["input_direction"].x) * deg_to_rad(SWING_HEAD_ROTATION), SWING_HEAD_ROTATION_LERP)
		else:
			neck.rotation.z = lerp_angle(neck.rotation.z, 0.0, SWING_HEAD_RECOVERY_LERP)


func camera_fov(delta: float = get_physics_process_delta_time()) -> void:
	if finite_state_machine.current_state_name_is("Run"):
		camera_3d.fov = lerp(camera_3d.fov, camera_fov_range[2], delta * camera_fov_range[3])
	else:
		camera_3d.fov = lerp(camera_3d.fov, camera_fov_range[1], delta * camera_fov_range[3])
	

func lock_player(lock : bool) -> void:
	if lock:
		LOCKED = true
		finite_state_machine.lock_state_machine()
	else:
		LOCKED = false
		finite_state_machine.unlock_state_machine()


func get_input_direction() -> Dictionary:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return {
		"input_direction": input_dir,
		"direction": (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	} 

func _switch_mouse_mode() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
