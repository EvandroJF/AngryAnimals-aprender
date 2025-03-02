extends Node

var _level_selected: int = 1

func _ready() -> void:
	pass

func set_level_selected(ls: int) -> void:
	_level_selected = ls
	
func get_level_selected() -> int:
	return _level_selected
