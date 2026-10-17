extends Node3D

@export var SPEED_SLOW_MODIFIER: int = 3
var _player: Player;

func _on_area_3d_body_entered(body: Node3D) -> void:
	var player = body as Player
	if Player:
		_player = player
		player.slow_movement_by(SPEED_SLOW_MODIFIER)


func _on_area_3d_body_exited(body: Node3D) -> void:
	var player = body as Player
	if player and not player.is_slowed():
		player.reset_movement_speed()

func on_free():
	if _player and _player.is_slowed():
		_player.reset_movement_speed()
	call_deferred("queue_free")
