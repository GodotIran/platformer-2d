class_name PlayerController
extends Node

enum Action {
	WALK_LEFT,
	WALK_RIGHT,
	JUMP,
}

const INPUT_MAP: Dictionary[int, StringName] = {
	Action.WALK_LEFT: "ui_left",
	Action.WALK_RIGHT: "ui_right",
	Action.JUMP: "ui_accept",
}

@export var character: Character:
	set = set_character


func _enter_tree() -> void:
	if not character:
		character = get_parent() as Character


func _unhandled_input(_event: InputEvent) -> void:
	character.movement.direction = Input.get_axis(
		INPUT_MAP[Action.WALK_LEFT],
		INPUT_MAP[Action.WALK_RIGHT],
	)
	if character.is_on_floor() and Input.is_action_just_pressed(
		INPUT_MAP[Action.JUMP],
	):
		character.set_jumping(true)


func set_character(value: Character) -> void:
	character = value
	set_process_unhandled_input(
		is_instance_valid(character),
	)
