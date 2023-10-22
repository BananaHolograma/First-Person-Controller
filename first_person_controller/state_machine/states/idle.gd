class_name Idle extends Motion


func _enter():
	animation_player.play("idle")

func _exit():
	animation_player.stop()


	
func physics_update(delta):
	super.physics_update(delta)
