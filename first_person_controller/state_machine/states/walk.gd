class_name Walk extends Motion

@export var speed := 2.2
@export var catching_breath_recovery_time := 3.0

var catching_breath_timer : Timer

func _enter():
	catching_breath()


func _ready():
	_create_sprint_recovery_timer()
	
	
func physics_update(delta):
	super.physics_update(delta)
	
	move(speed, delta)
	
	if direction.is_zero_approx() or owner.velocity.is_zero_approx():
		state_finished.emit("Idle", {})
		return
	
	if Input.is_action_pressed("run") and catching_breath_timer.is_stopped() and owner.CAN_RUN:
		state_finished.emit("Run", {})
		return
		
	detect_jump()
	detect_crouch()
	
	owner.move_and_slide()

func catching_breath():
	if params.has("catching_breath") and params["catching_breath"] and catching_breath_timer.is_stopped():
		catching_breath_timer.start()
		
		
func _create_sprint_recovery_timer() -> void:
	catching_breath_timer = Timer.new()
	catching_breath_timer.name = "SprintRecoveryTimer"
	catching_breath_timer.wait_time = catching_breath_recovery_time
	catching_breath_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	catching_breath_timer.autostart = false
	catching_breath_timer.one_shot = true
	
	add_child(catching_breath_timer)
