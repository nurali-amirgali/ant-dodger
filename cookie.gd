extends Area2D

signal collectedCookie(cookie: Node2D)

@export var popUpTime: float = 0.1
@export var fullScale: int = 2.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(onBodyEntered)
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(fullScale, fullScale), popUpTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onBodyEntered(body):
	if body.is_in_group("player"):
		collectedCookie.emit(self)
		queue_free()
