extends CharacterBody2D

@export var animator: AnimatedSprite2D

const SPEED = 20.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := -1
	if direction:
		velocity.x = direction * SPEED
		animator.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animator.play("idle")
		
	move_and_slide()
