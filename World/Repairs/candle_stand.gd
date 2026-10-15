extends StaticBody3D

@onready var broken_candle: Node3D = $"broken-candle"
@onready var candle: Node3D = $candle


var is_lit:bool = false

func _ready() -> void:
	toggle_light(is_lit)


func toggle_light(lit:bool):
	if lit:
		candle.visible = true
		broken_candle.visible = false
	else:
		candle.visible = false
		broken_candle.visible = true



func _on_interactable_interact() -> void:
	is_lit = !is_lit
	toggle_light(is_lit)
