extends Node

const ONE = preload("uid://cjm0bau1pduly")
const TWO = preload("uid://cm28kwgklc6k4")
const THREE = preload("uid://vgqraqm4xpnj")



var time: int = 0
var end_time:int = 0

var current_level:int = 0

var level_repairs = 0
var current_repairs = 0:
	set(value):
		current_repairs = value
		if current_repairs == level_repairs and current_repairs > 0:
			victory()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Game.spawn = %Spawn
	Game.repair_compelted.connect(update_repairs)
	Game.start_clock.connect(start_level)

func start_level():
	%TimeTick.start()

func update_repairs():
	current_repairs += 1
	%RepairCount.text = str(current_repairs) + "/" + str(level_repairs)

func victory():
	%Stats.hide()
	%Menus.show()
	%EndScreen.show()

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


func _on_levels_pressed() -> void:
	%MainMenu.hide()
	%Levels.show()


func level_settings(level):
	%LevelContainer.add_child(level)
	Game.spawn = level.get_node("Spawn")
	Game.player.position = Game.spawn.position
	level_repairs = level.repairs

func ui_settings_on_start():
	%Menus.hide()
	%RepairCount.text = str(current_repairs) + "/" + str(level_repairs)
	%Stats.show()

func _on_level_one_pressed() -> void:
	var level = ONE.instantiate()
	current_level = 1
	level_settings(level)
	ui_settings_on_start()


func _on_level_two_pressed() -> void:
	var level = TWO.instantiate()
	current_level = 2
	level_settings(level)
	ui_settings_on_start()


func _on_level_three_pressed() -> void:
	var level = THREE.instantiate()
	current_level = 3
	level_settings(level)
	ui_settings_on_start()


func _on_main_menu_pressed() -> void:
	%Menus.show()
