extends GdUnitTestSuite

const STATE_MACHINE := Character.CharacterStateMachine

var runner: GdUnitSceneRunner
var character: Character
var state_machine: StateMachine


func test_character_fall() -> void:
	# res://tests/test_character/test_character_fall.tscn
	runner = scene_runner("uid://cammaal3yklai")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.FallState,
		),
	).is_true()


func test_character_fall_to_idle() -> void:
	# res://tests/test_character/test_character_fall_to_idle.tscn
	runner = scene_runner("uid://claoagn2dw3ro")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()


func test_character_fall_to_walk() -> void:
	# res://tests/test_character/test_character_fall_to_walk.tscn
	runner = scene_runner("uid://i54eemm7b20g")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.WalkState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.WalkState,
		),
	).is_true()


func test_character_idle_to_walk() -> void:
	# res://tests/test_character/test_character_idle_to_walk.tscn
	runner = scene_runner("uid://dfa8hsnntq6b1")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()

	character.movement_direction = 1

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.IdleState,
			STATE_MACHINE.WalkState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.WalkState,
		),
	).is_true()


func test_character_idle_to_jump() -> void:
	# res://tests/test_character/test_character_idle_to_jump.tscn
	runner = scene_runner("uid://bwvxu7tmyc3xy")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()

	character.set_jumping(true)

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.IdleState,
			STATE_MACHINE.JumpState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.JumpState,
		),
	).is_true()


func test_character_idle_to_fall() -> void:
	# res://tests/test_character/test_character_idle_to_fall.tscn
	runner = scene_runner("uid://dr2ev1gndcmkf")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.IdleState,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.FallState,
		),
	).is_true()


func test_character_walk_to_idle() -> void:
	# res://tests/test_character/test_character_walk_to_idle.tscn
	runner = scene_runner("uid://dg8y8ag2f0jkd", true)

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.WalkState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.WalkState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.WalkState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()


func test_character_walk_to_jump() -> void:
	# res://tests/test_character/test_character_walk_to_jump.tscn
	runner = scene_runner("uid://dhbybtfldv1f8")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.WalkState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.WalkState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.WalkState,
			STATE_MACHINE.JumpState,
		],
	)
	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.JumpState,
		),
	).is_true()


func test_character_walk_to_fall() -> void:
	# res://tests/test_character/test_character_walk_to_fall.tscn
	runner = scene_runner("uid://c1qax1q6k4unt")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.WalkState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.WalkState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.WalkState,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.FallState,
		),
	).is_true()


func test_character_jump_to_fall() -> void:
	# res://tests/test_character/test_character_jump_to_fall.tscn
	runner = scene_runner("uid://6nsfd8jslw1g")

	character = runner.find_child("Character")
	state_machine = character.state_machine

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			null,
			STATE_MACHINE.FallState,
		],
	)

	assert_bool(
		state_machine.is_state(
			Character.CharacterStateMachine.FallState,
		),
	).is_true()

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.FallState,
			STATE_MACHINE.IdleState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.IdleState,
		),
	).is_true()

	character.set_jumping(true)

	await await_signal_on(
		state_machine,
		"state_changed",
		[
			STATE_MACHINE.IdleState,
			STATE_MACHINE.JumpState,
		],
	)

	assert_bool(
		state_machine.is_state(
			STATE_MACHINE.JumpState,
		),
	).is_true()
