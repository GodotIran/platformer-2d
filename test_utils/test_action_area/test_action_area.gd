extends Area2D

const ACTION := PlayerController.Action
const INPUT_MAP := PlayerController.INPUT_MAP

@export var action: ACTION
@export var target: Character
@export var release: bool = false
@export var press_duration: float = 0.0


func _enter_tree() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(node: Node2D) -> void:
	if node == target:
		_trigger_action(true)

		if release and press_duration > 0:
			await get_tree().create_timer(press_duration).timeout
			_trigger_action(false)


func _on_body_exited(node: Node2D) -> void:
	if node == target and not release:
		_trigger_action(false)


func _trigger_action(p_pressed: bool) -> void:
	var input := InputEventAction.new()
	input.action = INPUT_MAP[action]
	input.pressed = p_pressed
	Input.parse_input_event(input)
