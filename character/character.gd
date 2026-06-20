class_name Character
extends CharacterBody2D

@export_group("Movement", "movement_")
@export var movement_speed: float = 150
@export var movement_direction: float
@export var movement_friction: float = 0.1
@export_group("Jump", "jump_")
@export var jump_force: float = 490
@export_group("Gravity", "gravity_")
@export var gravity_force: float = 980
@export var gravity_direction: Vector2 = Vector2.DOWN:
	set = set_gravity_direction
@export var health:int = 100
var visited_tile_cache: String

var state_machine := CharacterStateMachine.new()
var _is_jumping: bool


func _enter_tree() -> void:
	if not state_machine.get_parent():
		add_child(state_machine, true, Node.INTERNAL_MODE_FRONT)


func apply_gravity() -> void:
	if not is_on_floor():
		var delta := get_physics_process_delta_time()
		velocity += gravity_direction * gravity_force * delta


func apply_friction() -> void:
	if is_on_floor():
		velocity = velocity.lerp(Vector2.ZERO, movement_friction)


func apply_movement() -> void:
	var movement_vector := (
			-gravity_direction.rotated(PI / 2) *
			movement_direction * movement_speed
	)
	var gravity_component := velocity.project(gravity_direction)
	velocity = gravity_component + movement_vector
	_is_hit()

func apply_jump_force() -> void:
	velocity = (
			velocity.slide(gravity_direction) -
			gravity_direction * jump_force
	)


func set_gravity_direction(value: Vector2) -> void:
	gravity_direction = value.normalized()
	up_direction = gravity_direction.rotated(PI).normalized()


func set_jumping(jump: bool) -> void:
	_is_jumping = jump


func is_jumping() -> bool:
	return _is_jumping


func is_moving() -> bool:
	return (
			movement_direction != 0
			and movement_speed > 0
	)

func _is_hit()->void:
	var last_collision = get_last_slide_collision()

	if(last_collision is KinematicCollision2D):
		var collider = last_collision.get_collider() as TileMapLayer
		var local_pos:Vector2 = collider.to_local(last_collision.get_position())
		var cell_pos:Vector2i = collider.local_to_map(local_pos)

		# Create unique ID for this tile
		var source_id = collider.get_cell_source_id(cell_pos)
		var atlas_coords = collider.get_cell_atlas_coords(cell_pos)
		var alternative = collider.get_cell_alternative_tile(cell_pos)
		var tile_unique_id = "%d_%d_%d_%d_%d_%d" % [source_id, atlas_coords.x, atlas_coords.y, alternative, cell_pos.x, cell_pos.y]

		if visited_tile_cache != tile_unique_id:
			# Add to cache
			visited_tile_cache = tile_unique_id

			var tile_data = collider.get_cell_tile_data(cell_pos)
			if tile_data:
				var damage: int = tile_data.get_custom_data("damage")
				var heal: int = tile_data.get_custom_data("heal")
				if damage:
					health -=damage
				if heal:
					health += heal

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


		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_PHYSICS_PROCESS:
					character.apply_friction()


		func _is_conditions() -> bool:
			return (
					character.is_on_floor()
					and not character.is_moving()
					and not character.is_jumping()
			)


	class WalkState extends CharacterState:
		func _to_string() -> String:
			return "WalkState"


		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_PHYSICS_PROCESS:
					character.apply_movement()


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
					character.apply_jump_force()
				NOTIFICATION_PHYSICS_PROCESS:
					character.apply_movement()
					character.set_jumping(false)


		func _is_conditions() -> bool:
			return (
					character.is_on_floor()
					and character.is_jumping()
			)


	class FallState extends CharacterState:
		func _to_string() -> String:
			return "FallState"


		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_PHYSICS_PROCESS:
					character.apply_gravity()
					character.apply_movement()


		func _is_conditions() -> bool:
			return not character.is_on_floor()
