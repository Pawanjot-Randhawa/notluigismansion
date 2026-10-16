class_name Room
extends Area3D

@export var roof: Node3D;

func _ready() -> void:
	self.body_entered.connect(_on_body_entered);
	self.body_exited.connect(_on_body_exited);
	
func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return;
	
	Game.room_entered.emit(self);
	
func _on_body_exited(body: Node3D) -> void:
	if not body is Player:
		return;
	
	Game.room_exited.emit(self);
