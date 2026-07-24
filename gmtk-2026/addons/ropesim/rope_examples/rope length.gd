extends Node2D

var additional_length:float
var segment_length:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	segment_length = $Rope.rope_length / float($Rope.num_segments)
	$Rope.max_endpoint_distance = $Rope.rope_length + 20.
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	
	if Input.is_action_pressed("ui_down"):
		additional_length += 10.
		$Rope.rope_length += additional_length
		$Rope.max_endpoint_distance = $Rope.rope_length + 20.
		$Rope.rope_length += int(additional_length / segment_length)
	#if Input.is_action_pressed("ui_up"):
	
	pass
