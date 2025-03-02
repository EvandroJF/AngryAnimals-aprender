extends Node

const DEFAULT_SCORE: int = 1000

var _level_selected: int = 1
var _level_score: Dictionary = {}

func _ready() -> void:
	pass

func set_level_selected(ls: int) -> void:
	_level_selected = ls
	
func get_level_selected() -> int:
	return _level_selected

func check_and_add(level: String) -> void:
	if _level_score.has(level) == false:
		_level_score[level] = DEFAULT_SCORE
	
func set_score_for_nevel(score: int, level: String):
	check_and_add(level)
	if _level_score[level] > score:
		_level_score[level] = score

func get_best_for_level(level: String) -> int:
	check_and_add(level)
	return _level_score[level] 
