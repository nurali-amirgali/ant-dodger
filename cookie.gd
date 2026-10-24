extends Area2D

signal collectedCookie

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(onBodyEntered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onBodyEntered(body):
	if body.is_in_group("player"):
		collectedCookie.emit()
		queue_free()
