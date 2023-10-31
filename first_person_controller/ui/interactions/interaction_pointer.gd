extends Control

@onready var pointer_icon = %PointerIcon

var default_pointer: CompressedTexture2D = preload("res://first_person_controller/ui/crosshairs/default_pointer.png")

func _ready():
	GlobalEvents.interacted.connect(on_interacted_interactable)
	GlobalEvents.focused.connect(on_focused_interactable)
	GlobalEvents.unfocused.connect(on_unfocused_interactable)
	
	pointer_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pointer_icon.custom_minimum_size = default_pointer.get_size()

func on_interacted_interactable(interactable: Interactable):
	if interactable.interact_pointer:
		_transition_pointer(interactable.interact_pointer)
	else:
		_transition_pointer(default_pointer)
	
func on_focused_interactable(interactable: Interactable):
	if interactable.focus_pointer:
		_transition_pointer(interactable.focus_pointer)


func on_unfocused_interactable(_interactable: Interactable):
	_transition_pointer(default_pointer)


func _transition_pointer(new_pointer: CompressedTexture2D):
	pointer_icon.texture  = new_pointer
	
	var tween = create_tween()
	tween.tween_property(pointer_icon, "custom_minimum_size", new_pointer.get_size(), 0.2).from(Vector2(0, 0))\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
