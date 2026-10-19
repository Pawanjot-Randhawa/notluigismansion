extends Node3D

@export var repairs:int = 11

func _on_spawn_area_body_exited(body: Node3D) -> void:
	if body is Player:
		Game.start_clock.emit()
