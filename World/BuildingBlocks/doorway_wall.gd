extends StaticBody3D

@onready var animation_player: AnimationPlayer = $door_panel2/AnimationPlayer
var open:bool = false



func _on_open_zone_body_entered(body: Node3D) -> void:
	if body is Player and not open:
		animation_player.play_section("open", -1, 1.2)
		open = true


func _on_open_zone_body_exited(body: Node3D) -> void:
	if body is Player and open:
		animation_player.play_section("open", 1.2, -1)
		open = false
