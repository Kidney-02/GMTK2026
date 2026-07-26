## Items that can be picked up
class_name Item extends RigidBody2D

#func _init() -> void:

@onready var audio_player = $AudioStreamPlayer2D

var audio_threshold = 150.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func get_grabbed():
	



func _on_body_entered(body: Node) -> void:
	
	if self.linear_velocity.length() <= audio_threshold:
		return
	audio_player.play()
	pass # Replace with function body.
