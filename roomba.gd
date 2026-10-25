extends CharacterBody2D

signal destroyed(roomba: CharacterBody2D)
signal playerHurt

@export var speed: float = 500

var turningRate = 20

func _ready():
	$Area2D.body_entered.connect(onBodyEntered)
	turningRate = randi_range(-20, 20)
	turningRate = 0
	
func onBodyEntered(body):
	if body.is_in_group("player"):
		playerHurt.emit()

func _physics_process(delta: float) -> void:
	velocity = Vector2.UP.rotated(rotation) * speed
	rotation += deg_to_rad(turningRate) * delta
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroyed.emit(self)
	queue_free()
