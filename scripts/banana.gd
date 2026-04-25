class_name Banana extends Area2D

var banana_level: int = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		banana_level += 1
		queue_free()
