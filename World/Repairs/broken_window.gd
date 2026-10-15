extends Node3D

var is_open:bool = false

@onready var animation_player: AnimationPlayer = $window_tall2/AnimationPlayer

func _ready() -> void:
	toggle_window(is_open)


func toggle_window(open:bool):
	if open:
		animation_player.play_section("open", 1.22, -1)
	else:
		animation_player.play_section("open", -1, 1.22)

func _on_interactable_interact() -> void:
	is_open = !is_open
	toggle_window(is_open)
