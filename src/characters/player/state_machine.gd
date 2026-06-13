extends StateMachine


func _register_states() -> Array[GDScript]:
	return [
		JumpState,
		FallState,
		WalkState,
		IdleState,
	]
