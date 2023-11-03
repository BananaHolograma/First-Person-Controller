extends Node3D

signal picked(picked_object: Interactable)
signal dropped(picked_object: Interactable)
signal throwed(picked_object: Interactable)

@export var maximum_lift_mass = 10

@onready var hand: Generic6DOFJoint3D = $Hand
@onready var hand_limit: StaticBody3D = $HandLimit

var picked_object: Interactable

func _ready():
	GlobalEvents.interacted.connect(on_interact)
	drop()


func _unhandled_input(_event: InputEvent):
	if picked_object:
		if InputMap.has_action("interact") and Input.is_action_just_pressed("interact"):
			drop()
		
		if InputMap.has_action("throw") and Input.is_action_just_pressed("throw"):
			throw()


func _physics_process(delta):
	if picked_object:
		picked_object.target.linear_velocity = (hand_limit.global_position - picked_object.target.global_position) * picked_object.parameters.pull_power
	

func pick(interactable: Interactable):
	picked_object = interactable

	var tween = create_tween()
	tween.tween_property(picked_object.target, "global_position", hand_limit.global_position, 0.4).from(picked_object.target.global_position)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(func():
		set_process_unhandled_input(true)
		hand.node_b = picked_object.target.get_path()
		picked.emit(picked_object)
	)

	
func drop():
	set_process_unhandled_input(false)
	
	if picked_object:
		picked_object.actor.cancel_interact(picked_object)
		dropped.emit(picked_object)
		picked_object = null
		hand.node_b = NodePath("")


func throw():
	if picked_object:
		var direction = global_position.direction_to(picked_object.target.global_position)
		picked_object.target.apply_impulse(direction * picked_object.parameters.throw_power)
		throwed.emit(picked_object)
		drop()

		
func on_interact(interactable: Interactable):
	if interactable.is_pickable():
		pick(interactable)
		
