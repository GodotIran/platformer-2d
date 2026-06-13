class_name Character
extends CharacterBody2D

var gravity: Vector2


func _ready() -> void:
	await get_tree().process_frame
	gravity = get_gravity()


func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta
