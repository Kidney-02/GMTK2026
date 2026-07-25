extends Node2D

@onready var conveyer_belt = $Area2D

##########
## Possible Items
var spawnable = [
	preload("res://prefabs/Item/Class/item_base.tscn"),
	preload("res://prefabs/Item/Class/item_class.tscn"),

]
	

@export var push_force: float = -1.


var items = []


func _init() -> void:
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
		
func _physics_process(delta: float) -> void:
	
	
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	#for item in overlapping:
	if body is not Item:
		return
	
	items.append(body)
	#var pos = body.global_position
	body.add_constant_central_force(Vector2(push_force, 0.))
	pass
	
	
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	if body not in items:
		return
		
	body.constant_force = Vector2(0., 0.)
		
	items.erase(body)	
	
	
	pass # Replace with function body.
