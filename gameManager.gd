extends Node2D

@export var numCookies: int = 3
@export var cookieScene: PackedScene
@export var minDistance: int = 200
@export var minCookieSpacing: int = 200

@onready var player = $player
@onready var healthBar = $healthBar

var heartTexture = load("res://heart.png")
var hurtHeartTexture = load("res://heartUsed.png")

var lives: int = 3
var score: int = 0
var activeCookies: Array[Node2D] = []
@onready var scoreLabel = $scoreLabel
@onready var heartSprites: Array[Node] = healthBar.get_children()

var width = 1152
var height = 648

@export var roombaScene: PackedScene
@export var bladeScene: PackedScene

@export var roombasAtOnce: int = 1
@export var bladesAtOnce: int = 2
@export var minEnemyDist: int = 400
var activeRoombas: Array[Node] = []
var activeBlades: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numCookies):
		spawnCookie()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activeRoombas.size() < roombasAtOnce:
		spawnEnemy("roomba")
	if activeBlades.size() < bladesAtOnce:
		spawnEnemy("blade")

func spawnEnemy(entity: String):
	var randomPos = getRandomSafePos()
	var direction = randomPos.direction_to(Vector2(width/2, height/2))
	var entityObj: CharacterBody2D
	if entity == "roomba":
		entityObj = roombaScene.instantiate()
		print("rooomba")
	elif entity == "blade":
		entityObj = bladeScene.instantiate()
		print("blade")
		
	add_child(entityObj)
	entityObj.position = randomPos
	if entity == "blade":
		entityObj.velocityDir = direction
	else:
		entityObj.rotation = direction.angle() + PI/2 + deg_to_rad(randf_range(-20,20))
	entityObj.destroyed.connect(entityDestroyed)
	
	if entity == "blade":
		activeBlades.append(entityObj)
	else:
		activeRoombas.append(entityObj)
	entityObj.playerHurt.connect(playerHurt)

func spawnCookie():
	var cookie = cookieScene.instantiate()
	add_child(cookie)
	
	cookie.position = getCookiePos()
	cookie.collectedCookie.connect(cookieCollected)
	
	activeCookies.append(cookie)

func entityDestroyed(entity: Node) -> void:
	activeBlades.erase(entity)
	activeRoombas.erase(entity)
	
func getRandomPos() -> Vector2:
	var side = randi_range(0, 3)
	var padding = 100
	
	match side:
		0: #top
			return Vector2(randf_range(0, width), -padding)
		1: #bottom
			return Vector2(randf_range(0, width), height + padding)
		2: #left
			return Vector2(-padding, randf_range(0, height))
		3: #right
			return Vector2(width + padding, randf_range(0, height))

	return Vector2.ZERO

func getRandomSafePos() -> Vector2:
	var currentPos: Vector2
	while true:
		currentPos = getRandomPos()
		var distance = currentPos.distance_to(player.position)
		if distance >= minEnemyDist:
			break
	return currentPos

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

func playerHurt():
	lives -= 1
	for i in range(heartSprites.size()):
		var heart = heartSprites[i]
		if i <= (lives - 1):
			heart.texture = heartTexture
		else:
			heart.texture = hurtHeartTexture
	if lives <= 0:
		GameData.finalScore = score
		get_tree().change_scene_to_file("res://game_over.tscn")

func cookieCollected(cookie: Node2D):
	activeCookies.erase(cookie)
	score += 1
	scoreLabel.text = str(score)
	print(score)
	spawnCookie()
