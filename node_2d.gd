extends Node2D

@export var numCookies: int = 3
@export var cookieScene: PackedScene

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numCookies):
		var cookie = cookieScene.instantiate()
		add_child(cookie)
		
		cookie.position = Vector2(randf_range(50, 1100), randf_range(50, 600))
		cookie.collectedCookie.connect(cookieCollected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cookieCollected():
	score += 1
	print(score)
