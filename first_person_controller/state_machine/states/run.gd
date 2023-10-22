class_name Run extends Motion

@export var speed := 3.5
@export var sprint_time := 4.0

var speed_timer: Timer;


func _ready():
	_create_speed_timer()


func _enter():
	speed_timer.start()


func _exit():
	speed_timer.stop()


func physics_update(delta):
	super.physics_update(delta)
	
	move(speed, delta)
	
	if Input.is_action_just_released("run"):
		if owner.velocity.is_zero_approx():
			state_finished.emit("Idle", {})
		else:
			state_finished.emit("Walk", {})
			
	if Input.is_action_just_pressed("crouch"):
		state_finished.emit("Slide", {})
		return
	
	detect_jump()
	detect_crouch()
	
	owner.move_and_slide()
	
func _create_speed_timer() -> void:
	if speed_timer == null:
		speed_timer = Timer.new()
		speed_timer.name = "RunSpeedTimer"
		speed_timer.wait_time = sprint_time
		speed_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
		speed_timer.autostart = false
		speed_timer.one_shot = true
		
		add_child(speed_timer)
		speed_timer.timeout.connect(on_speed_timeout)
		
	
func on_speed_timeout():
	state_finished.emit("Walk", {"catching_breath": true})
