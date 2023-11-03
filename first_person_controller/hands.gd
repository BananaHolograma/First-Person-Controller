extends Node3D

@onready var hand: SliderJoint3D = $Hand
@onready var hand_limit: StaticBody3D = $HandLimit

var picked_object: Interactable

func _ready():
	GlobalEvents.interacted.connect(on_interact)
	drop()


func _unhandled_input(_event: InputEvent):
	if picked_object is Interactable:
		if InputMap.has_action("interact") and Input.is_action_just_pressed("interact"):
			drop()
			
		if InputMap.has_action("throw") and Input.is_action_just_pressed("throw"):
			throw()
		
		
func on_interact(interactable: Interactable):
	if interactable.is_pickable():
		pick(interactable)
		
		
func pick(interactable: Interactable):
	set_process_unhandled_input(true)
	
	picked_object = interactable
	
	var tween = create_tween()
	tween.tween_property(picked_object.target, "global_position", hand_limit.global_position, 0.4).from(picked_object.target.global_position)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	hand.node_b = picked_object.target.get_path()
	
	
func drop():
	picked_object = null
	set_process_unhandled_input(false)


func throw():
	var direction = picked_object.target.global_position.direction_to(global_position)
	picked_object.apply_impulse(direction * picked_object.throw_power)
	drop()
