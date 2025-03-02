extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var level_numeber: int = 1

@onready var lavel_label: Label = $MC/VBoxContainer/LavelLabel
@onready var score: Label = $MC/VBoxContainer/Score

var _level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lavel_label.text = str(level_numeber)
	_level_scene = load("res://scenes/level/level%s.tscn" % level_numeber)



func _on_pressed() -> void:
	ScoreManager.set_level_selected(level_numeber)
	get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered() -> void:
	scale = HOVER_SCALE


func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
