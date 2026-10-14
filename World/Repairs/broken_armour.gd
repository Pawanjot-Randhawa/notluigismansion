extends StaticBody3D

var in_range:bool = false
var is_broken:bool = true
@onready var broken_armour: Node3D = $"broken-armour"
@onready var good_armour: Node3D = $good_armour

func _ready() -> void:
	destroy(is_broken)

func destroy(broken:bool):
	if broken:
		broken_armour.visible = true
		good_armour.visible = false
	else:
		broken_armour.visible = false
		good_armour.visible = true


func _on_interactable_interact() -> void:
	is_broken = !is_broken
	destroy(is_broken)
