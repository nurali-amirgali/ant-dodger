extends CharacterBody2D

@export var speed: float = 250.0
@export var rotationSpeed: float = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		"moveLeft",
		"moveRight",
		"moveUp",
		"moveDown"
	)
	
	if direction != Vector2.ZERO:
		var targetDirection = direction.angle() + deg_to_rad(90)
		rotation = lerp_angle(rotation, targetDirection, rotationSpeed * delta)
		
		anim.play("run")
	else:
		anim.play("stand")
		
	velocity = direction * speed
	move_and_slide()
