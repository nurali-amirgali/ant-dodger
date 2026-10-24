extends Node2D

@export var numCookies: int = 3
@export var cookieScene: PackedScene
@export var minDistance: int = 150
@export var minCookieSpacing: int = 50

@onready var player = $player

var score: int = 0
var activeCookies: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numCookies):
		spawnCookie()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnCookie():
	var cookie = cookieScene.instantiate()
	add_child(cookie)
	
	cookie.position = getCookiePos()
	cookie.collectedCookie.connect(cookieCollected)
	
	activeCookies.append(cookie)

func getCookiePos() -> Vector2:
	var randomPos: Vector2
	while true:
		randomPos = Vector2(randf_range(50, 1100), randf_range(50, 600))
		var distance = randomPos.distance_to(player.position)
		if distance >= minDistance:
			var isSafe = true
			for cookie in activeCookies:
				if randomPos.distance_to(cookie.position) < minCookieSpacing:
					isSafe = false
					break
			if isSafe:
				break
	return randomPos

func cookieCollected(cookie: Node2D):
	activeCookies.erase(cookie)
	score += 1
	print(score)
	spawnCookie()
