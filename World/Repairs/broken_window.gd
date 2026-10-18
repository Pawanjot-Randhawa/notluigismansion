extends Node3D

var is_open:bool = false

@onready var animation_player: AnimationPlayer = $window_tall2/AnimationPlayer
@onready var progress_bar: ProgressBar = $CanvasLayer/UI/ProgressBar

@export var mash_power: float = 0.12
@export var friction_decay: float = 0.25

var start_time: float = 1.22 
var current_time_pos: float = 1.22 
var is_active: bool = false

func _ready() -> void:
	animation_player.play("open")
	animation_player.seek(start_time, true)

func _process(delta: float) -> void:
	if not is_active:
		return

	current_time_pos += friction_decay * delta
	
	if Input.is_action_just_pressed("interact"):
		current_time_pos -= mash_power
		%InputSound.play()

	current_time_pos = clamp(current_time_pos, 0.0, start_time)
	animation_player.seek(current_time_pos, true)
	var closed_percentage = (1.0 - (current_time_pos / start_time)) * 100.0
	progress_bar.value = closed_percentage
	if current_time_pos <= 0.0:
		exit()

func exit():
	is_active = false 
	%UI.hide()
	await get_tree().create_timer(.5).timeout
	%Pass.restart()
	%FinalSound.play()
	Game.repair_compelted.emit()
	await %Pass.finished
	await get_tree().create_timer(.5).timeout
	Game.player.swap_cam_to_player(true)

func _on_interactable_interact() -> void:
	%Camera3D.make_current()
	Game.player.swap_cam_to_player(false)
	%Interactable.monitoring = false
	is_active = true
	%UI.show()
