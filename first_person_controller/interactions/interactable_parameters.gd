class_name InteractableParameters extends Resource

enum CATEGORY {
	DOOR,
	WINDOW,
	OBJECT,
	ITEM,
	WEAPON,
	KEY
}

@export_group("Information")
@export var title: String
@export var description: String
@export var category: CATEGORY

@export_group("Scan")
@export var scannable := false

@export_group("Pickup")
@export var pickable := false
@export var pickup_message: String
@export var throw_power := 10.0

@export_group("Player")
@export var lock_player := false

