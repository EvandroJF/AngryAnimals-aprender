extends Node2D

const ANIMAL = preload("res://scenes/Animal/animal.tscn")

@onready var animal_start: Marker2D = $AnimalStart
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spaw_animal()
	SignalManager.on_animal_died.connect(spaw_animal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spaw_animal() -> void:
	var new_animal = ANIMAL.instantiate()
	new_animal.position = animal_start.position
	add_child(new_animal)
