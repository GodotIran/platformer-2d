class_name Character
extends CharacterBody2D

var gravity: float = ProjectSettings.get("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
