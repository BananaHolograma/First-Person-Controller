extends Control

@onready var title: Label = %Title
@onready var description: Label = %Description

@export_group("Zoom")
@export_range(1.0, 125.0, 0.5) var initial_zoom := 55.0
@export_range(1.0, 125.0, 0.5) var max_zoom = 35.0

@export_group("Displayed information")
@export_range(150, 250, 1) var max_description_size = 200

@export_group("Misc")
@export var current_camera: Camera3D
@export var interactive_spot: Marker3D
@export var scan_light: SpotLight3D

var rotator_component_scene: PackedScene = preload("res://first_person_controller/interactions/rotation/rotator_component.tscn")

var current_interactable: Interactable
var original_camera_fov := 0

var scanning := false
var interactable_original_position := Vector3.ZERO
var interactable_original_rotation := Vector3.ZERO


func _unhandled_input(_event: InputEvent):
	if scanning and current_interactable and Input.is_action_just_pressed("interact"):
		stop_scan(current_interactable)


func _ready():
	hide()
	
	GlobalEvents.interacted.connect(on_interact)
	
	if current_camera:
		original_camera_fov = current_camera.fov
		
	title.text = ""
	description.text = ""
		
	set_process_unhandled_input(false)


func _physics_process(delta: float):
	if scanning and current_interactable and current_camera:
		if Input.is_action_pressed("zoom"):
			current_camera.fov = lerp(current_camera.fov, max_zoom, delta * 5.0)
		else:
			current_camera.fov = lerp(current_camera.fov, initial_zoom, delta * 5.0)

	
func _position_interactable_on_screen(interactable: Interactable):
	interactable.target.add_child(rotator_component_scene.instantiate())
	
	if interactive_spot:
		interactable.target.rotation = interactive_spot.rotation
		var tween = create_tween()
		tween.tween_property(interactable.target, "global_position", interactive_spot.global_position, 0.4).from(interactable.target.global_position).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	if current_camera:
		var tween = create_tween()
		tween.tween_property(current_camera, "fov", initial_zoom, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


func stop_scan(interactable: Interactable) -> void:
	set_process_unhandled_input(false)
	scanning = false
	
	if scan_light:
		scan_light.hide()
		
	_reset_camera_fov()
	_reset_interactable_position()
	hide()
	
	
func _adjust_displayed_text(interactable: Interactable) -> void:
	title.text = interactable.parameters.title
	description.text = interactable.parameters.description
	
	description.custom_minimum_size.x = min(description.size.x, max_description_size)

	if description.size.x > max_description_size:
		description.autowrap_mode = TextServer.AUTOWRAP_WORD
		description.custom_minimum_size.y = description.size.y


func _reset_camera_fov() -> void:
	if current_camera:
		var tween = create_tween()
		tween.tween_property(current_camera, "fov", original_camera_fov, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	
	
func _reset_interactable_position() -> void:
	if current_interactable:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(current_interactable.target, "global_position", interactable_original_position, 0.4).from(interactive_spot.global_position).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(current_interactable.target, "rotation", interactable_original_rotation, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		
		current_interactable.target.get_node("RotatorComponent").queue_free()
		current_interactable.actor.cancel_interact(current_interactable)
		current_interactable = null
		interactable_original_position = Vector3.ZERO
		interactable_original_rotation = Vector3.ZERO
		
## SIGNALS CALLBACKS ##
func on_interact(interactable: Interactable):
	if interactable.is_scannable():
		set_process_unhandled_input(true)
		show()
	
		scanning = true
		current_interactable = interactable
		interactable_original_position = interactable.target.global_position
		interactable_original_rotation =  interactable.target.rotation
		
		if scan_light:
			scan_light.show()
		
		_adjust_displayed_text(current_interactable)
		_position_interactable_on_screen(current_interactable)

