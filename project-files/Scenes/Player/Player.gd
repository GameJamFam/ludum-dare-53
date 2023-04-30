extends Node2D
@export var speed: float
@export var streak_increment_amt: float
@export var streak_decrement_amt: float

@onready var score = 0
@onready var streak_pct = 0.0
@onready var streak_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if streak_pct == 100.0:
		streak_mode = true
	if streak_mode:
		streak_pct = maxf(0.0, streak_pct - streak_decrement_amt)
		streak_mode = streak_pct == 0.0

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= delta * speed
		position.y = max(get_parent().TRACK_BOUND_UPPER, position.y)
	elif Input.is_action_pressed("ui_down"):
		position.y += delta * speed
		position.y = min(get_parent().TRACK_BOUND_LOWER, position.y)

func die():
	get_parent().end_song_failure()

func hurt(damage:int):
	if streak_mode:
		return
	if streak_pct - damage < 0:
		die()
	else:
		streak_pct -= damage
	
func add_point(amount=1):
	if streak_mode:
		score += ceil(1.5 * amount)
		return
	else:
		score += amount
		streak_pct = minf(100.0, streak_pct + streak_increment_amt)
	print(score)
