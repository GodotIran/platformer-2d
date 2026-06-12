extends GdUnitTestSuite

var state_machine: StateMachine


func test_state_machine_not_has_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)

	assert_object(state_machine.state).is_null()


func test_state_machine_state_registration() -> void:
	state_machine = TestStateMachine.new()
	add_child(state_machine)

	assert_bool(state_machine.has_state(TestPassiveState)).is_true()


func test_state_machine_valid_state() -> void:
	state_machine = TestStateMachine.new()
	add_child(state_machine)

	await await_idle_frame()

	assert_object(state_machine.state).is_not_null()


func test_state_machine_state_activation() -> void:
	state_machine = auto_free(TestStateMachine.new())
	add_child(state_machine)

	await await_idle_frame()

	assert_bool(state_machine.state.is_active()).is_true()


func test_state_machine_state_append() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state_machine.has_state(TestPassiveState)).is_true()


func test_state_machine_picking_disable_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)
	var state: TestPassiveState = state_machine.get_state(TestPassiveState)
	state.set_disabled(true)

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestPassiveState)).is_false()
	state.set_disabled(false)

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestPassiveState)).is_true()


func test_state_machine_picking_is_conditions_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestConditionState)
	var state: TestConditionState = state_machine.get_state(TestConditionState)

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestConditionState)).is_false()
	state.condition = true

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestConditionState)).is_true()
	state.condition = false

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestConditionState)).is_false()


func test_state_machine_same_state_logic() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)
	state_machine.append_state(TestSecondState)

	await await_idle_frame()

	assert_bool(state_machine.has_state(TestPassiveState)).is_true()
	assert_bool(state_machine.has_state(TestSecondState)).is_true()

	assert_bool(state_machine.is_state(TestPassiveState)).is_true()

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestPassiveState)).is_true()

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestSecondState)).is_false()


func test_state_machine_high_priority_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)
	state_machine.append_state(TestSecondState)
	state_machine.append_state(TestHightPriorityState)

	await await_idle_frame()

	assert_bool(state_machine.is_state(TestHightPriorityState)).is_true()


func test_state_machine_remove_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state_machine.has_state(TestPassiveState)).is_true()
	state_machine.remove_state(TestPassiveState)

	assert_bool(state_machine.has_state(TestPassiveState)).is_false()


func test_state_machine_process() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)

	assert_bool(state_machine.is_processing()).is_false()
	assert_bool(state_machine.is_physics_processing()).is_false()

	await await_idle_frame()

	state_machine.append_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state_machine.is_processing()).is_true()
	assert_bool(state_machine.is_physics_processing()).is_true()

	await await_idle_frame()

	state_machine.remove_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state_machine.is_processing()).is_false()
	assert_bool(state_machine.is_physics_processing()).is_false()


func test_state_machine_process_override() -> void:
	state_machine = auto_free(TestStateMachine.new())
	add_child(state_machine)

	assert_bool(state_machine.is_processing()).is_true()
	assert_bool(state_machine.is_physics_processing()).is_true()

	await await_idle_frame()

	state_machine.remove_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state_machine.is_processing()).is_true()
	assert_bool(state_machine.is_physics_processing()).is_true()


func test_state_machine_notification_state() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestPassiveState)
	state_machine.append_state(TestHightPriorityState)

	var state: TestPassiveState = state_machine.get_state(TestPassiveState)

	assert_bool(state.entered).is_false()
	assert_bool(state.processed).is_false()
	assert_bool(state.physics_processed).is_false()
	assert_bool(state.exited).is_false()

	await await_idle_frame()

	assert_bool(state.entered).is_false()
	assert_bool(state.processed).is_false()
	assert_bool(state.physics_processed).is_false()
	assert_bool(state.exited).is_false()

	state_machine.remove_state(TestHightPriorityState)

	await await_millis(100) # wait for new state and update

	assert_bool(state.entered).is_true()
	assert_bool(state.processed).is_true()
	assert_bool(state.physics_processed).is_true()
	assert_bool(state.exited).is_false()

	state_machine.remove_state(TestPassiveState)

	await await_idle_frame()

	assert_bool(state.exited).is_true()


func test_state_machine_no_valid_state_after_condition_false() -> void:
	state_machine = auto_free(TestEmptyStateMachine.new())
	add_child(state_machine)
	state_machine.append_state(TestConditionState)
	var state: TestConditionState = state_machine.get_state(TestConditionState)
	state.condition = true

	await await_idle_frame()
	assert_bool(state_machine.is_state(TestConditionState)).is_true()

	state.condition = false
	await await_idle_frame()
	assert_that(state_machine.state).is_null()


class TestEmptyStateMachine extends StateMachine:
	func _register_states() -> Array[GDScript]:
		return []


class TestStateMachine extends StateMachine:
	func _process(_delta: float) -> void:
		pass


	func _physics_process(_delta: float) -> void:
		pass


	func _register_states() -> Array[GDScript]:
		return [
			TestPassiveState,
		]


class TestPassiveState extends StateMachine.BaseState:
	var entered: bool
	var processed: bool
	var physics_processed: bool
	var exited: bool


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_ENTER:
				entered = true
			NOTIFICATION_PROCESS:
				processed = true
			NOTIFICATION_PHYSICS_PROCESS:
				physics_processed = true
			NOTIFICATION_EXIT:
				exited = true


class TestSecondState extends StateMachine.BaseState:
	pass


class TestConditionState extends StateMachine.BaseState:
	var condition: bool


	func _is_conditions() -> bool:
		return condition


class TestHightPriorityState extends StateMachine.BaseState:
	func _priority() -> int:
		return -1
