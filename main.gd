extends Node

const ONE = preload("uid://cjm0bau1pduly")
const TWO = preload("uid://cm28kwgklc6k4")
const THREE = preload("uid://vgqraqm4xpnj")



var time: int = 0:
	set(value):
		time = value
		if time >= 10:
			lose()
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
	%MainMusic.play()
	Game.repair_compelted.connect(update_repairs)
	Game.start_clock.connect(start_level)

func start_level():
	%TimeTick.start()
	%MainMusic.stop()
	%LevelMusic.play()

func update_repairs():
	current_repairs += 1
	%RepairCount.text = str(current_repairs) + "/" + str(level_repairs)

func lose():
	%TimeTick.stop()
	await get_tree().create_timer(1.5).timeout
	%LevelMusic.stop()
	Game.player.pause_player()
	%LoseSound.play()
	await %LoseSound.finished
	update_win_stats()
	%StatusLabel.text = "LOSE"
	%MainMusic.play()
	%Stats.hide()
	%Menus.show()
	%EndScreen.show()

func victory():
	%TimeTick.stop()
	await get_tree().create_timer(1.5).timeout
	%LevelMusic.stop()
	Game.player.pause_player()
	%WinSound.play()
	await %WinSound.finished
	update_win_stats()
	%StatusLabel.text = "VICTORY"
	%MainMusic.play()
	%Stats.hide()
	%Menus.show()
	%EndScreen.show()

func update_win_stats():
	%EndStat.text = "Time: " + str(%Time.text) + "        Seconds: " + str(time/2)

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
	for child in %LevelContainer.get_children():
		child.queue_free()
	time = 0
	%LevelContainer.add_child(level)
	Game.spawn = level.get_node("Spawn")
	Game.player.position = Game.spawn.position
	Game.player.unpause_player()
	level_repairs = level.repairs

func ui_settings_on_start():
	%Menus.hide()
	%MainMenu.hide()
	%Levels.hide()
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
	%EndScreen.hide()
	%Menus.show()
	%MainMenu.show()


func _on_retry_pressed() -> void:
	if current_level == 1:
		_on_level_one_pressed()
	elif current_level == 2:
		_on_level_two_pressed()
	elif current_level == 3:
		_on_level_three_pressed()


func _on_tutoirial_pressed() -> void:
	%MainMenu.hide()
	%Tutorial.show()


func _on_back_pressed() -> void:
	%MainMenu.show()
	%Tutorial.hide()
