extends StaticBody3D

@onready var broken_candle: Node3D = $"broken-candle"
@onready var candle: Node3D = $candle

@onready var qt: ColorRect = $UI/QT
@onready var candles = [%C1, %C2, %C3, %C4, %C5]

var is_lit:bool = false

var target_start: float = 0.0
var target_length:float = 0.12
var event_duration:float = 0.5
var current_needle_progress: float = 0.0
var speed: float = 0.5
var running:bool = false

var count:int = 0


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and running:
		print("run")
		qte_result()

func _process(delta: float) -> void:
	if not running:
		return
	current_needle_progress += speed * delta
	qt.material.set_shader_parameter("needle_position", current_needle_progress)
	if current_needle_progress >= 1.0:
		qte_result()

func toggle_light(lit:bool):
	if lit:
		candle.visible = true
		broken_candle.visible = false
	else:
		candle.visible = false
		broken_candle.visible = true

func qt_animation():
	if count > 4:
		%UI.hide()
		exit()
		return
	%UI.show()
	target_start = randf_range(0.0, 1.0 - target_length) #picking random spot
	
	# 2. Update the shader parameters programmatically
	var mat = qt.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("arc_start", target_start)
		mat.set_shader_parameter("arc_length", target_length)
	
	# 3. Reset the rotating needle pointer
	current_needle_progress = 0.0
	running = true

func qte_result():
	running = false
	var target_end = target_start + target_length
	if current_needle_progress >= target_start and current_needle_progress <= target_end:
		print("pass")
		if count < candles.size():
			candles[count].visible = true
		count += 1
		target_length -= 0.02
		await get_tree().create_timer(1.0).timeout
		qt_animation()
	else:
		print("fail")
		await get_tree().create_timer(.5).timeout
		qt_animation()

func animation_order():
	call_deferred("qt_animation")

func exit():
	%Pass.restart()
	await %Pass.finished
	await get_tree().create_timer(.5).timeout
	Game.player.swap_cam_to_player(true)

func _on_interactable_interact() -> void:
	%Camera3D.make_current()
	Game.player.swap_cam_to_player(false)
	
	%Interactable.monitoring = false
	animation_order()
	#is_lit = !is_lit
	#toggle_light(is_lit)
