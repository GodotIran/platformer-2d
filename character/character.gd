class_name Character
extends CharacterBody2D

@export_group("Movement", "movement_")
@export var movement_speed: float = 350:
	set = set_movement_speed
@export var movement_friction: float = 0.1:
	set = set_movement_friction
@export_group("Jump", "jump_")
@export var jump_force: float = 980:
	set = set_jump_force
@export_group("Weight", "weight_")
@export var weight_mass: float = 2:
	set = set_weight_mass

var state_machine := CharacterStateMachine.new()
var _is_jumping: bool

@onready var movement := TraitServer.Movement.new(
	self,
	movement_speed,
	movement_friction,
)
@onready var weight := TraitServer.Weight.new(
	self,
	weight_mass,
)
@onready var jump := TraitServer.Jump.new(
	self,
	jump_force,
)


func _enter_tree() -> void:
	if not state_machine.get_parent():
		add_child(state_machine, true, Node.INTERNAL_MODE_FRONT)


func set_jumping(value: bool) -> void:
	_is_jumping = value


func is_jumping() -> bool:
	return _is_jumping


func is_moving() -> bool:
	return (
			movement.direction != 0
			and movement.speed > 0
	)


func set_movement_speed(value: float) -> void:
	movement_speed = value
	if not is_node_ready():
		await ready

	movement.speed = movement_speed


func set_movement_friction(value: float) -> void:
	movement_friction = value
	if not is_node_ready():
		await ready

	movement.friction = movement_friction


func set_jump_force(value: float) -> void:
	jump_force = value
	if not is_node_ready():
		await ready

	jump.force = jump_force


func set_weight_mass(value: float) -> void:
	weight_mass = value
	if not is_node_ready():
		await ready

	weight.mass = weight_mass


class CharacterStateMachine extends StateMachine:
	func _register_states() -> Array[GDScript]:
		return [
			IdleState,
			WalkState,
			JumpState,
			FallState,
		]


	@abstract class CharacterState extends BaseState:
		var character: Character:
			get = _get_owner


		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_PHYSICS_PROCESS:
					character.move_and_slide()


		func _get_owner() -> Character:
			return super()


	class IdleState extends CharacterState:
		func _to_string() -> String:
			return "IdleState"


		func _is_conditions() -> bool:
			return (
					character.is_on_floor()
					and not character.is_moving()
					and not character.is_jumping()
			)


	class WalkState extends CharacterState:
		func _to_string() -> String:
			return "WalkState"


		func _is_conditions() -> bool:
			return (
					character.is_on_floor()
					and character.is_moving()
					and not character.is_jumping()
			)


	class JumpState extends CharacterState:
		func _to_string() -> String:
			return "JumpState"


		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_ENTER:
					character.jump.apply_force()
				NOTIFICATION_PHYSICS_PROCESS:
					character.set_jumping(false)


		func _is_conditions() -> bool:
			return (
					character.is_on_floor()
					and character.is_jumping()
			)


	class FallState extends CharacterState:
		func _to_string() -> String:
			return "FallState"


		func _is_conditions() -> bool:
			return not character.is_on_floor()
