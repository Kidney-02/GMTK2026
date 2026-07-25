extends Label

@export var total_time:float = 7.
@export var required_items: int = 5
var held_items: int = 0
@onready var end_screen = $"End Screen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if total_time > 0.:
		total_time -= delta
		if total_time <= 0.:
			total_time = 0.
			
			
			## Game Over script here
			end_screen.visible = true
	
	
	var time = format_time(total_time)
	var display_time:String 
	
	if total_time >= 5.:
		display_time = "%02d : %02d" 
		display_time = display_time % [time["minutes"] , time["seconds"]]
	elif total_time > 0.:
		display_time = "%02d : %02d : %0.3f" 
		display_time = display_time % [time["minutes"] , time["seconds"] , time["miliseconds"]]
	elif total_time <= 0.:
		if held_items >= required_items:
			display_time = "WIN"
		else: 
			display_time = "GAME OVER" 
	
	self.set_text(display_time)
	
	pass



func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("escape"):
		end_screen.visible = not end_screen.visible
	pass

###############################################################################
func format_time(_seconds:float) -> Dictionary:
	
	var s:int = int(_seconds) % int(60.)
	var m:int = _seconds / 60.
	var h:int = m / 60.
	m = m % 60	
	var ms = fmod(_seconds, 1.)
	
	var _time = {
		"hours": h,
		"minutes": m,
		"seconds": s,
		"miliseconds": ms	
	}

	return _time


###############################################################################

func _on_rocket_body_entered(body: Node2D) -> void:
	if body is Item:
		print ("aenter")
		held_items += 1
	else:
		pass
		#print(body.get_class())
		#print("b")
	
	pass # Replace with function body.


func _on_rocket_body_exited(body: Node2D) -> void:
	if body is Item:
		print ("left")
		held_items -= 1
	else:
		pass
	
	pass # Replace with function body.
	
	
	pass # Replace with function body.
