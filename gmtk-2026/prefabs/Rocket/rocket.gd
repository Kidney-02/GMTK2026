extends Area2D

@onready var audio_player = $AudioStreamPlayer
var aud_rocket_takeoff = preload("res://audio/sfx/Rocket.wav")


@export var anim_player:AnimationPlayer
@export var timer:Label
@export var takeoff_delay: float = 3.0
@export var required_items:int = 10

var lid_placed = false
var lid:Node2D
var delay:float = takeoff_delay

var kill_delay:float = 0.0
var launched:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	launched = false


func _physics_process(delta: float) -> void:
	
	print(lid)
	if lid:	
		if lid.sleeping:
			delay -= delta
		else:
			delay = takeoff_delay
			
		if delay <= 0. and not launched:
			launch_rocket()
		
	if launched:
		kill_delay -= delta		
		#print(kill_delay)
		if kill_delay <= 0.:
			anim_player.stop()
			self.queue_free()
		

func launch_rocket():
	
	
	print("Launching")
	if launched:
		return
	var overlapping = self.get_overlapping_bodies()
	var items = []
	for item in overlapping:
		if item is Item:
			item.freeze = true
			item.reparent(self)
			items.append(item)
	if lid:
		lid.freeze = true
	
	$Rocket_Collision.set_collision_layer_value(2, false)
	$Rocket_Collision.set_collision_layer_value(1, false)
	
	if anim_player:
		anim_player.active = true
		anim_player.play("Takeoff")
		
		kill_delay = anim_player.get_current_animation_length()
	launched = true
	#print("a")
	timer.launch(check_win_codition(items))
	
	### Play Audio
	
	audio_player.play(0.)
	
	
func check_win_codition(_items:Array) -> bool:
	if _items.size() >= required_items:
		return true
	return false
	

######################

func _on_lid_area_body_entered(body: Node2D) -> void:
	if body is Lid:
		lid = body
		lid_placed = true
	pass # Replace with function body.


func _on_lid_area_body_exited(body: Node2D) -> void:
	if body is Lid:

		lid_placed = false
	pass # Replace with function body.
	
