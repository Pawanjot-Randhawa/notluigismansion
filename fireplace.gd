extends StaticBody3D

@onready var ui_container: Control = $CanvasLayer/UI
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var prompts: Array = [
	$CanvasLayer/UI/HBoxContainer/TextureRect,
	$CanvasLayer/UI/HBoxContainer/TextureRect2,
	$CanvasLayer/UI/HBoxContainer/TextureRect3
]
# Grabs the specific nested ring child from each prompt button
@onready var rings: Array = [
	$CanvasLayer/UI/HBoxContainer/TextureRect/TextureRect4,
	$CanvasLayer/UI/HBoxContainer/TextureRect2/TextureRect5,
	$CanvasLayer/UI/HBoxContainer/TextureRect3/TextureRect6
]

@export var shrink_speed: float = 1.3
var current_stage: int = 0
var is_active: bool = false
var accept_input: bool = false

func _ready() -> void:
	ui_container.visible = false

func _process(delta: float) -> void:
	if not is_active:
		return
	#shrink
	var active_ring = rings[current_stage]
	active_ring.scale -= Vector2(delta, delta) * shrink_speed

	# 2. Input check (Sweet spot window when scale shrinks between 0.6 and 0.4)
	if accept_input and Input.is_action_just_pressed("interact"):
		if active_ring.scale.x >= 0.9 and active_ring.scale.x <= 1.1:
			%Sparks.restart()
			pass_stage()
		else:
			fail_minigame()

	# 3. Auto-fail if the ring shrinks completely past the prompt
	if active_ring.scale.x <= 0.35:
		fail_minigame()

func start_stage() -> void:	
	var active_ring = rings[current_stage]
	active_ring.scale = Vector2(2, 2)
	active_ring.visible = true
	
	is_active = true
	accept_input = false
	await get_tree().create_timer(0.1).timeout 
	accept_input = true

func pass_stage() -> void:
	is_active = false
	prompts[current_stage].modulate = Color.GREEN 
	rings[current_stage].visible = false         
	if current_stage < 2:
		%SparkNoise.play(0.2)
		current_stage += 1
		start_stage()
	else:
		win_game()

func fail_minigame() -> void:
	reset()
	start_stage()

func win_game() -> void:
	is_active = false
	ui_container.visible = false
	%fire.show()
	%FireNoise.play()
	%BurningNoise.play()
	animation_player.play("burn")
	await get_tree().create_timer(1.25).timeout
	%Pass.restart()
	await %Pass.finished
	await get_tree().create_timer(1).timeout
	Game.player.swap_cam_to_player(true)

func reset():
	current_stage = 0
	for prompt in prompts: prompt.modulate = Color.WHITE
	for r in rings: r.visible = false

func _on_interactable_interact() -> void:
	%Camera3D.make_current()
	Game.player.swap_cam_to_player(false)
	%Interactable.monitoring = false
	reset()
	ui_container.visible = true
	start_stage()
