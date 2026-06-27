extends GdUnitTestSuite

func test_trait_server_auto_adds_to_root() -> void:
	assert_that(TraitServer.get_singleton()).is_not_null()


func test_add_trait_to_target() -> void:
	var target := TestCharacter.new()
	add_child(target)

	assert_bool(TraitServer.has_host(target)).is_false()

	var new_trait := TestTrait.new(target)

	assert_bool(TraitServer.has_host(target)).is_true()

	var host := TraitServer.get_host(target)

	assert_bool(host.has_trait(new_trait)).is_true()


func test_add_duplicate_trait_ignored() -> void:
	var target := TestCharacter.new()
	add_child(target)

	TestTrait.new(target)
	TestTrait.new(target)

	var host := TraitServer.get_host(target)

	assert_that(host.get_trait_count()).is_equal(1)


func test_remove_trait_from_target() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	assert_bool(TraitServer.has_host(target)).is_true()

	var host := TraitServer.get_host(target)

	assert_bool(host.has_trait(new_trait)).is_true()

	TraitServer.remove_trait(target, new_trait)

	assert_bool(host.has_trait(new_trait)).is_false()


func test_remove_last_trait_leaves_empty_host() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	assert_bool(TraitServer.has_host(target)).is_true()

	var host := TraitServer.get_host(target)

	assert_bool(host.has_trait(new_trait)).is_true()

	TraitServer.remove_trait(target, new_trait)

	assert_bool(host.is_empty()).is_true()
	assert_bool(host.has_trait(new_trait)).is_false()


func test_trait_validity() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	assert_bool(new_trait.is_valid()).is_true()

	target.queue_free()
	await await_idle_frame()

	assert_bool(new_trait.is_valid()).is_false()


func test_notification_forwarding() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	await await_millis(100)

	assert_int(new_trait.process_count).is_greater(0)
	assert_int(new_trait.physics_process_count).is_greater(0)
	assert_bool(new_trait.has_been_notified).is_true()


func test_auto_remove_on_target_deletion() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	assert_bool(TraitServer.has_host(target)).is_true()

	var host := TraitServer.get_host(target)

	assert_bool(host.has_trait(new_trait)).is_true()

	TraitServer.remove_trait(target, new_trait)

	assert_bool(host.is_empty()).is_true()
	assert_bool(host.has_trait(new_trait)).is_false()
	assert_bool(TraitServer.has_host(target)).is_false()


func test_get_owner_method() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	var trait_owner := new_trait.owner
	assert_that(trait_owner).is_equal(target)

	target.queue_free()

	await await_idle_frame()

	trait_owner = new_trait.owner
	assert_that(trait_owner).is_null()


func test_trait_host_from_trait() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)

	var host: TraitServer.TraitHost = TraitServer.TraitHost.from_trait(
		target,
		new_trait,
	)

	assert_that(host.object).is_equal(target)
	assert_bool(host.has_trait(new_trait)).is_true()


func test_trait_host_add_remove() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var host := TraitServer.TraitHost.new(target)

	var new_trait := TestTrait.new(target)
	host.add_trait(new_trait)

	assert_bool(host.has_trait(new_trait)).is_true()

	host.remove_trait(new_trait)

	assert_bool(host.has_trait(new_trait)).is_false()
	assert_bool(host.is_empty()).is_true()


func test_remove_host_manually() -> void:
	var target := TestCharacter.new()
	add_child(target)

	TestTrait.new(target)
	assert_bool(TraitServer.has_host(target)).is_true()

	TraitServer.remove_host(target)
	assert_bool(TraitServer.has_host(target)).is_false()


func test_auto_remove_host_on_tree_exiting() -> void:
	var target := TestCharacter.new()
	add_child(target)

	TestTrait.new(target)
	assert_bool(TraitServer.has_host(target)).is_true()

	var target_id := target.get_instance_id()

	target.queue_free()

	await await_idle_frame()

	assert_bool(TraitServer.has_host_id(target_id)).is_false()


func test_remove_trait_by_id() -> void:
	var target := TestCharacter.new()
	add_child(target)

	var new_trait := TestTrait.new(target)
	var host := TraitServer.get_host(target)
	var id := target.get_instance_id()

	assert_bool(host.has_trait(new_trait)).is_true()

	TraitServer.remove_trait_id(id, new_trait)

	assert_bool(host.has_trait(new_trait)).is_false()
	assert_bool(host.is_empty()).is_true()
	assert_bool(TraitServer.has_host(target)).is_false()


func test_get_host_returns_null_for_untracked_target() -> void:
	var target := TestCharacter.new()
	add_child(target)

	assert_that(TraitServer.get_host(target)).is_null()


func test_has_host_false_for_untracked_target() -> void:
	var target := TestCharacter.new()
	add_child(target)

	assert_bool(TraitServer.has_host(target)).is_false()


class TestTrait extends TraitServer.BaseTrait:
	var owner: Object:
		get = _get_owner
	var process_count: int = 0
	var physics_process_count: int = 0
	var has_been_notified: bool = false


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PROCESS:
				process_count += 1
				has_been_notified = true
			NOTIFICATION_PHYSICS_PROCESS:
				physics_process_count += 1
				has_been_notified = true


	func _get_owner() -> Object:
		return super()


class TestCharacter extends CharacterBody2D:
	pass
