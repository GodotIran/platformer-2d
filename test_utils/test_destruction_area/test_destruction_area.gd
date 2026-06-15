extends Area2D

@export var source: Character
@export var target: Node2D
@export var delay: float


func _enter_tree() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(node: Node2D) -> void:
	if node == source:
		await get_tree().create_timer(delay).timeout
		target.queue_free()
		self.queue_free()
