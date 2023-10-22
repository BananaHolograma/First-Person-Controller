class_name WallRun extends Motion

@export var speed := 3.0

var wall_direction: Vector3 = Vector3.ZERO
var wall_normal: Vector3 = Vector3.ZERO
var decrease_rate := 1.0
var wall_gravity = 0.01

func _enter():
	wall_direction = params["wall_direction"]
	wall_normal = params["wall_normal"]
	owner.velocity.y = wall_gravity

func physics_update(delta):
	super.physics_update(delta)
	
	owner.velocity.y -= wall_gravity * delta

#	owner.velocity.x = wall_direction.x * speed
	owner.velocity.z = -wall_normal.z * speed
	
	if Input.is_action_just_pressed("jump"):
		state_finished.emit("Jump", {"wall_normal": wall_normal})
	
	owner.move_and_slide()
	
	if owner.is_on_floor() or not owner.is_on_wall() or Input.is_action_just_released("run"):
		if direction:
			state_finished.emit("Walk", {})
		else:
			state_finished.emit("Idle", {})
			
	if owner.is_on_wall():
		var collision = owner.get_slide_collision(0)
		wall_normal = collision.get_normal()
		wall_direction = Vector3.UP.cross(wall_normal)
		
		
	


