extends GdUnitTestSuite

var player: Player
var mock_input: MockInputSource


func before_test() -> void:
	mock_input = MockInputSource.new()
	player = Player.new()
	player.input_source = mock_input
	add_child(player)
	player.update_input_data()
	player.gravity = Vector2(0, 980) # get_gravity only work on a real scene


func after_test() -> void:
	remove_child(player)
	player.free()
	mock_input.free()


func test_update_movement_sets_velocity_x() -> void:
	mock_input.set_move(1.0)
	player.update_input_data()
	player.update_movement()
	assert_float(player.velocity.x).is_equal(player.speed)


func test_update_movement_negative_direction() -> void:
	mock_input.set_move(-1.0)
	player.update_input_data()
	player.update_movement()
	assert_float(player.velocity.x).is_equal(-player.speed)


func test_update_movement_no_input_is_zero() -> void:
	player.velocity.x = 200.0
	mock_input.set_move(0.0)
	player.update_input_data()
	player.update_movement()
	assert_float(player.velocity.x).is_equal(0.0)


func test_update_movement_without_input_data_does_nothing() -> void:
	player.input_source = null
	player.input_data = null
	player.velocity.x = 150.0
	player.update_movement()
	assert_float(player.velocity.x).is_equal(150.0)


func test_update_jump_first_jump() -> void:
	mock_input.set_jump(true)
	player.update_input_data()
	player.update_jump()
	assert_int(player.jump_count).is_equal(1)
	assert_float(player.velocity.y).is_equal(-player.jump_force)


func test_update_jump_double_jump() -> void:
	mock_input.set_jump(true)
	player.update_input_data()
	player.update_jump()
	player.update_jump()
	assert_int(player.jump_count).is_equal(2)


func test_update_jump_cannot_exceed_max_jump_count() -> void:
	mock_input.set_jump(true)
	player.update_input_data()
	for i in player.max_jump_count + 1:
		player.update_jump()
	assert_int(player.jump_count).is_equal(player.max_jump_count)


func test_update_jump_no_press_does_nothing() -> void:
	mock_input.set_jump(false)
	player.update_input_data()
	player.update_jump()
	assert_int(player.jump_count).is_equal(0)
	assert_float(player.velocity.y).is_equal(0.0)


func test_update_jump_without_input_data_does_nothing() -> void:
	player.input_source = null
	player.input_data = null
	player.update_jump()
	assert_int(player.jump_count).is_equal(0)


func test_update_jump_at_max_count_does_nothing() -> void:
	mock_input.set_jump(true)
	player.update_input_data()
	player.jump_count = player.max_jump_count
	var velocity_before := player.velocity.y
	player.update_jump()
	assert_float(player.velocity.y).is_equal(velocity_before)


func test_apply_gravity_increases_velocity_y() -> void:
	player.velocity.y = 0.0
	player.apply_gravity(0.1)
	assert_float(player.velocity.y).is_greater(0.0)


func test_input_data_default_values() -> void:
	var data := PlayerInputData.new()
	assert_float(data.move_direction).is_equal(0.0)
	assert_bool(data.jump_pressed).is_false()
	assert_bool(data.dash_pressed).is_false()


class MockInputSource extends PlayerInputSource:
	var _data := PlayerInputData.new()


	func get_input() -> PlayerInputData:
		return _data


	func set_move(dir: float) -> void:
		_data.move_direction = dir


	func set_jump(pressed: bool) -> void:
		_data.jump_pressed = pressed


	func set_dash(pressed: bool) -> void:
		_data.dash_pressed = pressed
