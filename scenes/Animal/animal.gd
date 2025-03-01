extends RigidBody2D

enum ANIMAL_STATE { READY, DRAG , RELEASE }

@onready var launch_sound: AudioStreamPlayer = $LaunchSound
@onready var stretch_sound: AudioStreamPlayer = $StretchSound
@onready var kick_sound: AudioStreamPlayer = $KickSound

@onready var arrow: Sprite2D = $Arrow

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX: float = 1200.0

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0
var _laste_collision_count: int = 0

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	_start = position

func _physics_process(delta: float) -> void:
	update(delta)

func get_impulse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULT
 
func set_new_state(new_state: ANIMAL_STATE) -> void:
	_state = new_state
	
	if _state == ANIMAL_STATE.RELEASE:
		arrow.hide()
		freeze = false
		apply_central_impulse(get_impulse())
		launch_sound.play()
	elif  _state == ANIMAL_STATE.DRAG:
		_drag_start = get_global_mouse_position()
		arrow.show()

func detect_release() -> bool:
	if  _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag") == true:
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false
	
func scale_arrow() -> void:
	var imp_len = get_impulse().length()
	var perc = imp_len / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	arrow.rotation = (_start - position).angle()

func play_stretch_sound() -> void:
	if (_last_dragged_vector - _dragged_vector).length() > 0:
		if stretch_sound.playing == false:
			stretch_sound.play()

func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start

func drag_in_limits() -> void:
	
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIM_MIN.y,
		DRAG_LIM_MAX.y
	)
	position = _start + _dragged_vector

func update_drag() -> void:
	
	if  detect_release() == true:
		return
	
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	play_stretch_sound()
	drag_in_limits()
	scale_arrow() 

func play_collision() -> void:
	if (
		_laste_collision_count == 0 and 
		get_contact_count() > 0 and  
		kick_sound.playing == false):
		kick_sound.play()
	_laste_collision_count = get_contact_count()

func update_flight() -> void:
	#play_collision()
	pass

func update(delta: float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()
		ANIMAL_STATE.RELEASE:
			update_flight()

func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)


func _on_sleeping_state_changed() -> void:
	if sleeping == true:
		call_deferred("die")
		
		

func _on_body_entered(body: Node) -> void:
	if kick_sound.playing == false:
		kick_sound.play()
