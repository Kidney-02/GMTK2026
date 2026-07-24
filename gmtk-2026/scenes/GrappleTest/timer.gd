extends Label

@export var total_time:float = 7.


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
			$"../End Screen".visible = true
	
	
	var time = format_time(total_time)
	var display_time:String 
	
	if total_time >= 5.:
		display_time = "%02d : %02d" 
		display_time = display_time % [time["minutes"] , time["seconds"]]
	elif total_time > 0.:
		display_time = "%02d : %02d : %0.3f" 
		display_time = display_time % [time["minutes"] , time["seconds"] , time["miliseconds"]]
	elif total_time <= 0.:
		display_time = "GAME OVER" 
	
	self.set_text(display_time)
	
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
	
