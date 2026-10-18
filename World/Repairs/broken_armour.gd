extends StaticBody3D

@onready var good_armour: Node3D = $good_armour
@onready var armour_pieces: Node3D = $ArmourPieces
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hints = [%H1, %H2, %H3, %H4, %H5]


var valid:bool = false
var count:int = 0


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if valid:
			success()

func toggle_valid():
	valid = !valid
	print(valid)

func animation_order():
	valid = false
	for i in range(hints.size()):
		hints[i].visible = (i == count)
	if count == 0:
		animation_player.play("bootL")
	elif count == 1:
		animation_player.play("bootR")
	elif count == 2:
		animation_player.play("body")
	elif count == 3:
		animation_player.play("helm")
	elif count == 4:
		animation_player.play("spear")
	else:
		%FinishSound.play()
		animation_player.play("pass")
		await animation_player.animation_finished
		Game.player.swap_cam_to_player(true)

func success():
	animation_player.pause()
	count += 1
	%CorrectSound.play(.25)
	Game.repair_compelted.emit()
	animation_order()

func fail():
	animation_player.stop()
	animation_order()

func _on_interactable_interact() -> void:
	%Camera3D.make_current()
	Game.player.swap_cam_to_player(false)
	animation_order()
	%Interactable.monitoring = false
