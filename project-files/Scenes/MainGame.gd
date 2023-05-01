extends Node2D

@onready var TRACK_BOUND_UPPER = 307
@onready var TRACK_BOUND_LOWER = 711 # yeah yeah, magic numbers

# Called when the node enters the scene tree for the first time.
func _ready():
	$Conductor.load_track("res://Assets/Audio/VeryCopyright/Swingin Spathiphyllums.ogg",
		"res://Assets/Audio/VeryCopyright/Swingin Spathiphyllums.json")
	$Conductor.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		remove_bottom_track()
	elif Input.is_action_just_pressed("ui_focus_next"):
		add_bottom_track()
	elif Input.is_action_just_pressed("ui_select"):
		add_top_track()
	elif Input.is_action_just_pressed("ui_cancel"):
		remove_top_track()


# Deletable
func add_test_boulder():
	spawn_data({
		track=randi_range(0,4),
		type="obstacle_static",
		obst_type="boulder"})
func add_test_point():
	spawn_data({track=randi_range(0,4), type="point"})

func end_song_failure():
	print("you are dead")

func zip_with_idx(data:Array):
	var res = []
	var idx = 0.0 # doesn't need to be a float, but doesn't hurt anything
	for e in data:
		res.push_back(Vector2(idx, e))
		idx += 1
	return res
		
# Deque implementation
@export var TrainTrack: PackedScene
@onready var max_tracks = 7
@onready var min_tracks = 1
@onready var tracks = $TrainTracks
# @onready var sorted_tracks = zip_with_idx(tracks.get_children())
@onready var lowest_track_pos = tracks.get_children().map(func(e): return e.position.y).max()
@onready var highest_track_pos = tracks.get_children().map(func(e): return e.position.y).min()
@onready var num_tracks_active = tracks.get_child_count()
func add_track(to_top:bool, flip_y:bool):
	print("adding. To top? ", to_top)
	assert(tracks.get_child_count() + 1 <= max_tracks, "Too many train tracks!")
	if num_tracks_active != tracks.get_child_count():
		return # already adding/removing a track
	num_tracks_active += 1
	var tt = TrainTrack.instantiate()
	if to_top:
		tt.position.y = highest_track_pos - tt.HEIGHT - tt.HEIGHT_OFFSET
		tracks.add_child(tt)
		highest_track_pos = tt.position.y
	else:
		tt.position.y = lowest_track_pos + tt.HEIGHT + tt.HEIGHT_OFFSET
		tracks.add_child(tt)
		lowest_track_pos = tt.position.y
	tt.scale.y = -1 if flip_y else 1
	tt.add_self()
	
func remove_track(from_top:bool):
	print("Removing. From top? ", from_top)
	assert(tracks.get_child_count() - 1 >= min_tracks, "Too few train tracks!")
	if num_tracks_active != tracks.get_child_count():
		return # already in the process of adding/removing a track
	num_tracks_active -= 1
	
	var cur_positions = zip_with_idx(
		tracks.get_children().map(func(e): return e.position.y))
	print(cur_positions)
	cur_positions.sort_custom(func(a, b): return a.y > b.y)
	print(cur_positions)
	var tt = null
	if from_top:
		var last = cur_positions.size() - 1
		tt = tracks.get_child(cur_positions[last].x)
		highest_track_pos = cur_positions[last - 1].y
		TRACK_BOUND_UPPER += tt.HEIGHT
		if $Player.position.y < TRACK_BOUND_UPPER:
			$Player.position.y += tt.HEIGHT
	else:
		tt = tracks.get_child(cur_positions[0].x)
		lowest_track_pos = cur_positions[1].y
		TRACK_BOUND_LOWER -= tt.HEIGHT
		if $Player.position.y > TRACK_BOUND_LOWER:
			$Player.position.y -= tt.HEIGHT
	tt.remove_self()

# ---- Commands ----
## Track Commands
func add_top_track_inaccessible():
	add_track(true, false)
func add_top_track():
	add_track(true, true)
	TRACK_BOUND_UPPER -= tracks.get_child(0).HEIGHT
func add_bottom_track():
	add_track(false, false)
	TRACK_BOUND_LOWER += tracks.get_child(0).HEIGHT
func remove_top_track():
	remove_track(true)
func remove_bottom_track():
	remove_track(false)

## Spawner
func spawn_data(data):
	match(data['type']):
		'point':
			spawn_point(data)
		'obstacle_static':
			spawn_obstacle(data)
		'obstacle_blocking':
			spawn_blocking_obstacle(data)
		_:
			pass
func spawn_point(data):
	$DataSpawner.create_point(
		tracks.get_child(
			data['track']).position.y,
			data['track'])
func spawn_obstacle(data):
	$DataSpawner.create_static_obstacle(
		tracks.get_child(data['track']).position.y,
		data['obst_type'])
func spawn_blocking_obstacle(data):
	pass
