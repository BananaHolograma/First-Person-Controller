class_name Interactor extends RayCast3D

@export var actor: CharacterBody3D

var current_interactable: Interactable
var focused := false
var interacting := false


func _enter_tree():
	enabled = true
	exclude_parent = true
	collision_mask = 32 # Interactive layer
	collide_with_areas = true
	collide_with_bodies = false


func _unhandled_input(_event: InputEvent):
	if InputMap.has_action("interact")\
	 and Input.is_action_just_pressed("interact")\
	 and current_interactable and not interacting:
		interact(current_interactable)
	

func _physics_process(_delta):
	if is_colliding():
		var detected_interactable = get_collider()
		if current_interactable == null or current_interactable != detected_interactable:
			current_interactable = detected_interactable
			if not focused:
				focus(current_interactable)
	else:
		if focused and not interacting and current_interactable:
			unfocus(current_interactable)
			current_interactable = null


func interact(interactable: Interactable) -> void:
	if interactable.is_scannable():
		interacting = true
		enabled = false

	if interactable.has_signal("interacted"):
		interactable.interacted.emit(self)


func cancel_interact(interactable: Interactable) -> void:
	interacting = false
	
	if interactable.is_scannable():
		enabled = true

	if interactable.has_signal("cancel_interact"):
		interactable.cancel_interact.emit(self)
		
	current_interactable = null
	

func focus(interactable: Interactable) -> void:
	if interactable.has_signal("focused"):
		interactable.focused.emit(self)
		
	focused = true


func unfocus(interactable: Interactable) -> void:
	if interactable.has_signal("unfocused"):
		interactable.unfocused.emit(self)
	focused = false
