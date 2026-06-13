class_name JumpState
extends StateMachine.BaseState

var player: Player:
	get:
		if not player:
			player = _get_owner() as Player
		return player


func _notification(what: int) -> void:
	match what:
		StateMachine.BaseState.NOTIFICATION_ENTER:
			player.start_jump_visuals()
		StateMachine.BaseState.NOTIFICATION_PHYSICS_PROCESS:
			player.update_movement()
			player.update_jump()
		StateMachine.BaseState.NOTIFICATION_EXIT:
			player.stop_jump_visuals()


func _priority() -> int:
	return 0


func _is_conditions() -> bool:
	return (
			is_valid()
			and not player.is_on_floor()
			and player.velocity.y < 0.0
	)
