class_name PlayerInputSource
extends InputProvider

var current_input: PlayerInputData


func _ready() -> void:
	current_input = PlayerInputData.new()


func get_input() -> PlayerInputData:
	current_input.move_direction = Input.get_axis("left", "right")

	current_input.jump_pressed = Input.is_action_just_pressed("jump")

	current_input.dash_pressed = Input.is_action_just_pressed("dash")

	return current_input
