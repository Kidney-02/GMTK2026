extends Node2D

@onready var conveyer_belt = $Area2D
@onready var spawn_pos = $"StaticBody2D/Spawn Location"
##########
## Possible Items
var spawnable = [
	#preload("res://prefabs/Item/Class/item_base.tscn"),
	
	preload("res://prefabs/Item/item_aquarium.tscn"),
	preload("res://prefabs/Item/item_bomb.tscn"),
	preload("res://prefabs/Item/item_box.tscn"),
	preload("res://prefabs/Item/item_cans.tscn"),
	preload("res://prefabs/Item/item_creatures.tscn"),
	preload("res://prefabs/Item/item_grandma.tscn"),
	preload("res://prefabs/Item/item_piano.tscn"),
	preload("res://prefabs/Item/item_small_bomb.tscn"),
	preload("res://prefabs/Item/item_sofa.tscn"),
	preload("res://prefabs/Item/item_TV.tscn"),

]
	
@export var item_container:Node
@export var push_force: float = -100.
@export var spawn_timer:float = 4.2
@export var spawn_rand:float = 0.75

var items = []

var timer = spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_container = get_tree().root if not item_container else item_container
	timer = spawn_timer
	spawn_rand = clamp(spawn_rand, 0, 1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
		
func _physics_process(delta: float) -> void:
	
	timer -= delta
	if timer <= 0:
		timer = spawn_timer - randf() * spawn_timer * spawn_rand
		var to_spawn = spawnable.pick_random()
		var item = to_spawn.instantiate()
		item.global_position = spawn_pos.global_position
		item_container.add_child(item)
		#print(to_spawn)
		
		
	for item in items:
		item.linear_velocity = Vector2(push_force, 0.)
		
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	#for item in overlapping:
	if body is not Item:
		return
	#print(body)
	#body.freeze = true
	items.insert(0, body)
	#var pos = body.global_position
	#body.add_constant_central_force(Vector2(push_force, 0.))
	pass


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	if body not in items:
		return
	#body.freeze = false
	#body.constant_force = Vector2(0., 0.)		
	items.erase(body)		
	pass # Replace with function body.
