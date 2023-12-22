class_name Hurtbox extends Area3D

signal hitbox_detected(hitbox: Hitbox)


func _init() -> void:
	monitorable = false
	collision_mask = 32
	

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(hitbox: Hitbox) -> void:
	hitbox_detected.emit(hitbox)
