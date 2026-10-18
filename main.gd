extends Node

var time: int = 0
var current_level: int = 1
var current_repairs = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.spawn = %Spawn
	Game.repair_compelted.connect(update_repairs)
	%RepairCount.text = "0/8"

func update_repairs():
	current_repairs += 1
	%RepairCount.text = str(current_repairs) + "/8"


func _on_time_tick_timeout() -> void:
	time += 1
	var hour:int = time / 60
	var min:int = time % 60
	if hour == 0:
		hour = 12
	if min < 10:
		%Time.text = str(hour) + ":0" + str(min) + " AM"
	else:
		%Time.text = str(hour) + ":" + str(min) + " AM"
