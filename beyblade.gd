extends CharacterBody2D

@export var speed: int = 100
@export var rotationSpeed: float = 2.5
@export var lingerTime: float = 15.0

@onready var camera = get_viewport().get_camera_2d()

var velocityDir: Vector2 = Vector2.UP
var startTurning: bool = false
var stopTurning: bool = false
var elapsed: float = 0

signal playerHurt

@export var stopTurnTime: float = 2
@export var turnActivationDist = 50
@export var lingerTurnSpeed: float = 0.8

@onready var sprite = $Sprite2D

signal destroyed(blade: CharacterBody2D)

func _ready():
	$Area2D.body_entered.connect(onBodyEntered)
	
func onBodyEntered(body):
	if body.is_in_group("player"):
		playerHurt.emit()

func _physics_process(delta: float) -> void:
	velocity = velocityDir * speed
	rotation = rotationSpeed
	sprite.rotation += deg_to_rad(rotationSpeed * delta * 360)
	
	var distance = position.distance_to(Vector2(576,324))
	if distance <= turnActivationDist and not startTurning:
		startTurning = true
		start_linger_timer()
	
	if stopTurning:
		elapsed += delta
		lingerTurnSpeed = lerp(lingerTurnSpeed, 0.0, min(elapsed/stopTurnTime, 1.0))
	
	if startTurning:
		velocityDir = velocityDir.rotated(min(distance/turnActivationDist, 1) * deg_to_rad(lingerTurnSpeed))

	move_and_slide()

func start_linger_timer() -> void:
	await get_tree().create_timer(lingerTime).timeout
	disableTurn()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if stopTurning:
		print("destroyed")
		destroyed.emit(self)
		queue_free()

func disableTurn() -> void:
	stopTurning = true
