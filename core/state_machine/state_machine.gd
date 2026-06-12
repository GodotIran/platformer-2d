class_name StateMachine
extends Node

var state: BaseState:
	set = _set_state
var _states: Dictionary[GDScript, BaseState]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var parent := get_parent()
			for type in _register_states():
				var new_state: BaseState = type.new(parent)
				if new_state:
					_states.set(type, new_state)

			if not _states.is_empty():
				set_process(true)
				set_physics_process(true)
		NOTIFICATION_PROCESS:
			if state and state.is_conditions():
				state.notification(BaseState.NOTIFICATION_PROCESS)
			else:
				_find_next_valid_state()
		NOTIFICATION_PHYSICS_PROCESS:
			if state and state.is_conditions():
				state.notification(BaseState.NOTIFICATION_PHYSICS_PROCESS)
			else:
				_find_next_valid_state()


func has_state(type: GDScript) -> bool:
	return _states.has(type)


func is_state(type: GDScript) -> bool:
	return state and state.get_script() == type


func get_state(type: GDScript) -> BaseState:
	if has_state(type):
		return _states[type]

	return null


func append_state(type: GDScript) -> void:
	if has_state(type):
		return

	var parent := get_parent()
	var new_state: BaseState = type.new(parent)
	if new_state:
		_states.set(type, new_state)

	if not _states.is_empty():
		set_process(true)
		set_physics_process(true)


func remove_state(type: GDScript) -> void:
	if not has_state(type):
		return

	var deleted_state := _states[type]
	if state == deleted_state and deleted_state.is_active():
		state = null

	_states.erase(type)

	if _states.is_empty():
		if not "_process" in self:
			set_process(false)

		if not "_physics_process" in self:
			set_physics_process(false)


func _find_next_valid_state() -> void:
	var not_validated_states := _states.values()
	var valid_states := not_validated_states.filter(_is_valid_state)

	valid_states.sort_custom(_has_priority)

	if valid_states.is_empty():
		state = null
	else:
		var queue_state: BaseState = valid_states.front()
		if queue_state.is_active():
			return

		state = queue_state


func _is_valid_state(not_validated_state: BaseState) -> bool:
	return (
			not_validated_state
			and not_validated_state.is_conditions()
			and not not_validated_state.is_disabled()
	)


func _has_priority(state_a: BaseState, state_b: BaseState) -> bool:
	return state_a.get_priority() < state_b.get_priority()


func _set_state(value: BaseState) -> void:
	if state:
		state.notification(BaseState.NOTIFICATION_EXIT)
		state.set_active(false)

	state = value
	if state:
		state.notification(BaseState.NOTIFICATION_ENTER)
		state.set_active(true)


func _register_states() -> Array[GDScript]:
	return []


## Abstract base class for states in a state machine.
## All states should inherit from this class.
@abstract class BaseState:
	const NOTIFICATION_ENTER: int = -1
	const NOTIFICATION_PROCESS: int = -2
	const NOTIFICATION_PHYSICS_PROCESS: int = -3
	const NOTIFICATION_EXIT: int = -4

	var _owner: WeakRef
	var _disabled: bool
	var _active: bool


	func _init(new_owner: Object = null) -> void:
		_owner = weakref(new_owner)


	## Checks whether the owner is still valid and exists in the scene.
	## return true if the owner is valid, false otherwise.
	func is_valid() -> bool:
		return is_instance_valid(_get_owner())


	## Determines if this state can be entered or exited.
	func is_conditions() -> bool:
		return _is_conditions()


	func set_disabled(value: bool) -> void:
		_disabled = value


	func set_active(value: bool) -> void:
		_active = value


	func is_disabled() -> bool:
		return _is_disabled()


	func is_active() -> bool:
		return _active


	func get_priority() -> int:
		return _priority()


	## A virtual method to get the state owner with static typing.
	## Change the return value type if needed.
	## [codeblock]
	## func _get_owner() -> Character:
	##     return super()
	## [/codeblock]
	func _get_owner() -> Object:
		return _owner.get_ref()


	func _priority() -> int:
		return 0


	## Virtual method
	func _is_conditions() -> bool:
		return is_valid()


	func _is_disabled() -> bool:
		return _disabled
