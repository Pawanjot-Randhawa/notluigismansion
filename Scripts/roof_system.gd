extends Node

func _ready() -> void:
	Game.room_entered.connect(_on_room_entered);
	Game.room_exited.connect(_on_room_exited);

func _on_room_entered(room: Room) -> void:
	room.roof.hide();

func _on_room_exited(room: Room) -> void:
	room.roof.show();
