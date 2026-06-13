class_name Player
extends Character

@export var speed: float = 300.0
@export var jump_force: float = 500.0
@export var max_jump_count: int = 2
@export var input_source: PlayerInputSource

var jump_count: int = 0
var input_data: PlayerInputData


func _physics_process(delta: float) -> void:
	update_input_data()

	super._physics_process(delta)

	if is_on_floor():
		jump_count = 0


func update_movement() -> void:
	if not input_data:
		return

	velocity.x = input_data.move_direction * speed


func update_jump() -> void:
	if not input_data:
		return

	if not input_data.jump_pressed:
		return

	if jump_count >= max_jump_count:
		return

	jump_count += 1
	velocity.y = -jump_force


#region Visual methods
# this methods call from state while enter or exit state
# use this methods for start of stop animations, audios or any visuals
func start_idle_visuals() -> void:
	pass


func stop_idle_visuals() -> void:
	pass


func start_walk_visuals() -> void:
	pass


func stop_walk_visuals() -> void:
	pass


func start_jump_visuals() -> void:
	pass


func stop_jump_visuals() -> void:
	pass


func start_fall_visuals() -> void:
	pass


func stop_fall_visuals() -> void:
	pass
#endregion


func update_input_data() -> void:
	if not input_source:
		push_error("Player input_source is null")
		return

	input_data = input_source.get_input()
