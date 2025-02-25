extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	pass

func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()
