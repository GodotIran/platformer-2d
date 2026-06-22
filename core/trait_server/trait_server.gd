class_name TraitServer
extends Node

static var _singleton: TraitServer
static var _traits: Dictionary[int, TraitHost]


static func _static_init() -> void:
	_singleton = TraitServer.new()
	_singleton.name = "TraitServer"

	_get_tree().node_added.connect(
		_root_node_added,
		CONNECT_ONE_SHOT,
	)


static func get_singleton() -> TraitServer:
	return _singleton


static func add_trait(target: Object, new_trait: BaseTrait) -> void:
	add_trait_id(target.get_instance_id(), new_trait)


static func add_trait_id(target: int, new_trait: BaseTrait) -> void:
	if _traits.has(target):
		var host := _traits[target]
		if host.has_trait(new_trait):
			return

		host.add_trait(new_trait)
	else:
		var instance := instance_from_id(target)
		_traits.set(
			target,
			TraitHost.from_trait(instance, new_trait),
		)
		if instance is Node:
			var node_target := instance as Node
			node_target.tree_exiting.connect(
				remove_host.bind(node_target),
				CONNECT_ONE_SHOT,
			)


static func get_host(target: Object) -> TraitHost:
	return get_host_id(target.get_instance_id())


static func get_host_id(target: int) -> TraitHost:
	if _traits.has(target):
		return _traits[target]

	return null


static func has_host(target: Object) -> bool:
	return has_host_id(target.get_instance_id())


static func has_host_id(target: int) -> bool:
	return _traits.has(target)


static func remove_trait(target: Object, pre_trait: BaseTrait) -> void:
	remove_trait_id(target.get_instance_id(), pre_trait)


static func remove_trait_id(target: int, pre_trait: BaseTrait) -> void:
	if _traits.has(target):
		var host := _traits[target]
		if not host.has_trait(pre_trait):
			return

		host.remove_trait(pre_trait)
		if host.is_empty():
			_traits.erase(target)


static func remove_host(target: Object) -> void:
	remove_host_id(target.get_instance_id())


static func remove_host_id(target: int) -> void:
	if _traits.has(target):
		_traits.erase(target)


static func _get_tree() -> SceneTree:
	return Engine.get_main_loop() as SceneTree


static func _get_root() -> Window:
	return _get_tree().root


static func _root_node_added(_node: Node) -> void:
	_get_root().add_child(_singleton)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			set_process(true)
			set_physics_process(true)
		NOTIFICATION_PROCESS:
			for t: TraitHost in _traits.values():
				t.notification(what)
		NOTIFICATION_PHYSICS_PROCESS:
			for t: TraitHost in _traits.values():
				t.notification(what)


class TraitHost:
	const NOTIFICATION_PROCESS: int = 17
	const NOTIFICATION_PHYSICS_PROCESS: int = 16

	var object: Object
	var traits: Dictionary[GDScript, BaseTrait]


	static func from_trait(target: Object, new_trait: BaseTrait) -> TraitHost:
		var host := TraitHost.new(target)
		host.add_trait(new_trait)

		return host


	func _init(target: Object) -> void:
		object = target


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PROCESS:
				for t: BaseTrait in traits.values():
					t.notification(what)
			NOTIFICATION_PHYSICS_PROCESS:
				for t: BaseTrait in traits.values():
					t.notification(what)


	func add_trait(new_trait: BaseTrait) -> void:
		if new_trait:
			var type: GDScript = new_trait.get_script()
			traits.set(type, new_trait)


	func remove_trait(new_trait: BaseTrait) -> void:
		if new_trait:
			var type: GDScript = new_trait.get_script()
			traits.erase(type)


	func get_trait_count() -> int:
		return traits.size()


	func has_trait(prev_trait: BaseTrait) -> bool:
		if prev_trait:
			var type: GDScript = prev_trait.get_script()
			return has_trait_type(type)

		return false


	func has_trait_type(type: GDScript) -> bool:
		return traits.has(type)


	func is_empty() -> bool:
		return traits.is_empty()


## Abstract base class for trais in a trait server.
## All traits should inherit from this class.
@abstract class BaseTrait:
	const NOTIFICATION_PROCESS: int = 17
	const NOTIFICATION_PHYSICS_PROCESS: int = 16

	var _owner: WeakRef
	var _owner_id: int


	func _init(new_owner: Object = null) -> void:
		_owner = weakref(new_owner)
		_owner_id = new_owner.get_instance_id()

		TraitServer.add_trait(new_owner, self)


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PREDELETE:
				TraitServer.remove_trait_id(_owner_id, self)


	## Checks whether the owner is still valid and exists in the scene.
	## return true if the owner is valid, false otherwise.
	func is_valid() -> bool:
		return is_instance_valid(_get_owner())


	## A virtual method to get the trait owner with static typing.
	## Change the return value type if needed.
	## [codeblock]
	## func _get_owner() -> Character:
	##     return super()
	## [/codeblock]
	func _get_owner() -> Object:
		return _owner.get_ref()


@abstract class CharacterBodyTrait extends BaseTrait:
	var object: CharacterBody2D:
		get = _get_owner


	func _get_owner() -> CharacterBody2D:
		return _owner.get_ref()


class Movement extends CharacterBodyTrait:
	var speed: float:
		set = set_speed, get = get_speed
	var direction: float:
		set = set_direction, get = get_direction
	var friction: float:
		set = set_friction, get = get_friction


	func _init(
			new_owner: Object = null,
			new_speed: float = 0,
			new_friction: float = 0,
	) -> void:
		super(new_owner)
		speed = new_speed
		friction = new_friction


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PHYSICS_PROCESS:
				apply_movement()


	func _get_owner() -> CharacterBody2D:
		return super()


	func apply_movement() -> void:
		if not is_valid():
			return

		var is_on_floor := object.is_on_floor()
		if direction:
			var loss := speed * friction if is_on_floor else 0.0
			var velocity := (speed - loss) * direction
			object.velocity.x = velocity
		else:
			object.velocity.x = lerpf(object.velocity.x, 0, friction)


	func set_speed(value: float) -> void:
		speed = value


	func get_speed() -> float:
		return speed


	func set_direction(value: float) -> void:
		direction = value


	func get_direction() -> float:
		return direction


	func set_friction(value: float) -> void:
		friction = value


	func get_friction() -> float:
		return friction


class Weight extends CharacterBodyTrait:
	const AIR_DENSITY: float = 1.225
	const DRAG_COEFFICIENT: float = 0.01
	const FRONTAL_AREA: float = 1.0

	var mass: float


	func _init(
			new_owner: Object = null,
			new_mass: float = 0.0,
	) -> void:
		super(new_owner)
		mass = new_mass


	func _get_owner():
		return super()


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PHYSICS_PROCESS:
				apply_weight_and_drag()


	func apply_weight_and_drag() -> void:
		if not is_valid():
			return

		var delta: float = object.get_physics_process_delta_time()
		var velocity := object.velocity
		var gravity := object.get_gravity()

		velocity.y += gravity.y * mass * delta

		var vertical_speed := velocity.y
		if vertical_speed != 0:
			var drag_force := (
					0.5 * AIR_DENSITY * DRAG_COEFFICIENT *
					FRONTAL_AREA * vertical_speed * vertical_speed)
			var drag_accel := drag_force / mass
			var drag_direction := -1.0 if vertical_speed > 0 else 1.0
			velocity.y += drag_direction * drag_accel * delta

		object.velocity = velocity


	func get_weight_force() -> Vector2:
		if not is_valid():
			return Vector2.ZERO

		var gravity := object.get_gravity()
		return Vector2(0, gravity.y * mass)


	func get_terminal_velocity() -> float:
		if DRAG_COEFFICIENT == 0 or FRONTAL_AREA == 0:
			return INF

		var gravity: float = object.get_gravity().y
		if gravity == 0:
			return INF

		return sqrt(
			(2 * mass * absf(gravity)) /
			(AIR_DENSITY * DRAG_COEFFICIENT * FRONTAL_AREA),
		)


class Jump extends CharacterBodyTrait:
	var force: float


	func _init(
			new_owner: Object = null,
			new_force: float = 0.0,
	) -> void:
		super(new_owner)
		force = new_force


	func apply_force() -> void:
		object.velocity.y = object.up_direction.y * force
