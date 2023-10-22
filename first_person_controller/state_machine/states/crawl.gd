class_name Crawl extends Motion

@export var speed := 0.8
@onready var ceil_shape_cast: ShapeCast3D = owner.get_node("CeilShapeCast3D")

func _enter() -> void:
	if animation_player:
		animation_player.play("crawl")
		

func _exit() -> void:
	animation_player.play_backwards("crawl")
	

func physics_update(delta):
	super.physics_update(delta)
	
	if not Input.is_action_pressed("crawl") and not ceil_shape_cast.is_colliding():
		state_finished.emit("Crouch", {})
	
	move(speed, delta)
	owner.move_and_slide()
