extends Node3D

var total_repairs:int = 10
var current_repairs:int = 0

func _ready() -> void:
	Game.repair_compelted.connect(func(): current_repairs += 1)
