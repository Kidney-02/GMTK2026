extends Node2D
class_name Player


@onready var rope = $SliderBase/GrooveJoint2D/GrapplerBase/Rope
@onready var rope_line = $SliderBase/GrooveJoint2D/GrapplerBase/Rope/Line2D
@onready var grab_area = $SliderBase/GrabberHand/GrabArea
@onready var grabber = $SliderBase/GrabberHand
@onready var grabber_sprite = $SliderBase/GrabberHand/Icon
@onready var grabber_base = $SliderBase/GrooveJoint2D/GrapplerBase

@export var item_container:Node2D


@export var max_speed:float 			= 800.
@export var speed_up:float 				= 50.
@export var speed_down:float 			= 800.

var input_threshold:float 				= 0.01

var input_move_dir:float = 0.
var input_rope_dir:float = 0.
var force:Vector2 = Vector2(0,0)

var rope_length = 300.
@export var rope_length_target = 300.
@export var segment_length = 50.
@export var rope_min = 150.
@export var rope_max = 1500.
@export var lowering_speed = 100.
@export var raising_speed = 100.


var grabbing:bool = false
var grabbed_items = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	grabber_base.apply_central_force(Vector2(20, 0))
	update_rope_length(0.)
	
	if not item_container:
		item_container == get_tree().root
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	
	## Redraw Rope smoothed
	var rel_points = []
	for p in rope._points.duplicate():
		p -= rope.global_position
		rel_points.append(p)
	var smooth_points = catmull_rom_spline(rel_points)
	rope_line.points = smooth_points
	#
	pass

func _physics_process(delta: float) -> void:
	process_input(delta)
	grabber_base.apply_central_force(force)
	
	#print (delta)
	update_rope_length(delta)
	
	
func _input(_event: InputEvent) -> void:
	input_move_dir = Input.get_axis("left", "right")	
	input_rope_dir = Input.get_axis("lower", "raise")
	
	if Input.is_action_just_pressed("grab_drop"):
		
		grab_release()
		pass
	

############################################
func process_input(_delta:float):
	## Move
	if abs(input_move_dir) > 0. or abs(force.x) > 0.:
		if abs(input_move_dir) > input_threshold :
			## Moving
			force.x += input_move_dir * speed_up if abs(force.x) < max_speed else 0.
		else:
			## Breaking
			var cur_dir = sign(force.x)
			force.x -= cur_dir * speed_down if abs(force.x) >= speed_down else force.x
	
	
	#if abs(input_rope_dir) > 0. :
	rope_length_target -= input_rope_dir * lowering_speed * _delta if input_rope_dir < 0 else input_rope_dir * raising_speed * _delta
	rope_length_target = clamp(rope_length_target, rope_min, rope_max)

	
		
func update_rope_length(_delta:float):
	
	var diff = rope_length - rope_length_target
	
	if _delta >= 0.001 and abs(diff) > 0.1:
		var dir = sign(diff)
		rope_length += lowering_speed * _delta if dir < 0 else -1 * raising_speed * _delta

		#print(diff)
		
	else: 
		rope_length = rope_length_target
		
	rope_length = clamp(rope_length, rope_min, rope_max)
		
	rope.rope_length = rope_length
	#rope.num_segments = int(rope_length / segment_length)
	#rope.max_endpoint_distance = rope_length + 50.
	pass
	
func grab_release():
	
	grabbing = not grabbing
	
	if grabbing:
		var overlapping = grab_area.get_overlapping_bodies()
		
		print(overlapping)
		if overlapping:
			for item in overlapping:
				if item is not Item:
					continue
				print (item)
				item.freeze = true
				item.reparent(grabber)
				var collisions = []
				for child in item.get_children():
					if child is CollisionShape2D:
						var col = child.duplicate()
						grabber.add_child(col)
						col.global_transform = child.global_transform
						collisions.append(col)
				print(item.get_parent())
				grabbed_items.merge({item:collisions})
		else:
			grabbing = false
	else:
		print (grabbed_items)
		for item in grabbed_items.keys():
			## item is a dict of {item : collisions}
			#var item = item_dict[0]
			item.freeze = false
			item.reparent(item_container)
			for col in grabbed_items[item]:
				col.queue_free()
			
		grabbed_items.clear()
		
	grabber_sprite.modulate = Color(2.0, 0.10, 0.0, 1.0) if grabbing else Color(1., 1., 1., 1.0)
	
	pass
	

#####################################
## Create a smoothed point array usign catmul rom algorithm
func catmull_rom_spline(
				_points: Array, resolution: int = 10, extrapolate_end_points = true
			) -> PackedVector2Array:
		
	if _points.size() <= 1:
		return _points
				
	var points = _points.duplicate()
	if extrapolate_end_points:
		points.insert(0, points[0] - (points[1] - points[0]))
		points.append(points[-1] + (points[-1] - points[-2]))
		

	var smooth_points := PackedVector2Array()
	if points.size() < 4:
		return points

	for i in range(1, points.size() - 2):
		var p0 = points[i - 1]
		var p1 = points[i]
		var p2 = points[i + 1]
		var p3 = points[i + 2]

		for t in range(0, resolution):
			var tt = t / float(resolution)
			var tt2 = tt * tt
			var tt3 = tt2 * tt

			var q = (
				0.5
				* (
					(2.0 * p1)
					+ (-p0 + p2) * tt
					+ (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * tt2
					+ (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * tt3
				)
			)

			smooth_points.append(q)
			
	## force_end_points:		
	smooth_points[-1] = (points[-2])
	return smooth_points

#####################################
