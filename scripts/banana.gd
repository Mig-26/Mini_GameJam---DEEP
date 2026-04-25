extends Area2D

@export var value: int = 1  # how many points this banana gives

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_score(value)  # ✅ send score to player
		queue_free()