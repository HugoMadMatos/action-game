extends Node
class_name InputController

## Controller de Inputs
## Centraliza todos os inputs de teclado e gamepad

# === CONSTANTES DE INPUT ===
const MOVEMENT_DEADZONE: float = 0.2

# === ESTADO ===
var _movement_vector: Vector2 = Vector2.ZERO
var _gamepad_movement: Vector2 = Vector2.ZERO

# === INICIALIZAÇÃO ===
func _ready() -> void:
	pass

# === LOOP DE INPUT ===
func _process(delta: float) -> void:
	_update_gamepad_input()

# === MOVIMENTO ===
func get_movement_direction() -> Vector2:
	var keyboard := _get_keyboard_movement()
	var gamepad := _get_gamepad_movement()
	
	# Prioriza gamepad se tiver input
	var combined := keyboard + gamepad
	if combined.length_squared() > MOVEMENT_DEADZONE:
		return combined.normalized()
	
	return Vector2.ZERO

func _get_keyboard_movement() -> Vector2:
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

func _get_gamepad_movement() -> Vector2:
	return _gamepad_movement

func _update_gamepad_input() -> void:
	_gamepad_movement.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	_gamepad_movement.y = -Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	
	# Aplica deadzone
	if _gamepad_movement.length_squared() < MOVEMENT_DEADZONE:
		_gamepad_movement = Vector2.ZERO
	else:
		_gamepad_movement = _gamepad_movement.normalized()

# === AÇÕES (Teclado) ===
func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func is_interact_pressed() -> bool:
	return Input.is_action_just_pressed("ui_focus_next")

func is_light_attack_pressed() -> bool:
	return Input.is_action_just_pressed("ui_select")

func is_heavy_attack_pressed() -> bool:
	return Input.is_action_just_pressed("ui_cancel")

# === AÇÕES (Gamepad) ===
func is_gamepad_jump_pressed() -> bool:
	return Input.is_joy_button_pressed(0, JOY_BUTTON_A)

func is_gamepad_interact_pressed() -> bool:
	return Input.is_joy_button_pressed(0, JOY_BUTTON_X)

func is_gamepad_light_attack_pressed() -> bool:
	return Input.is_joy_button_pressed(0, JOY_BUTTON_B)

func is_gamepad_heavy_attack_pressed() -> bool:
	return Input.is_joy_button_pressed(0, JOY_BUTTON_Y)

# === COMBO DE INPUTS ===
func is_any_jump_pressed() -> bool:
	return is_jump_pressed() or is_gamepad_jump_pressed()

func is_any_interact_pressed() -> bool:
	return is_interact_pressed() or is_gamepad_interact_pressed()

func is_any_light_attack_pressed() -> bool:
	return is_light_attack_pressed() or is_gamepad_light_attack_pressed()

func is_any_heavy_attack_pressed() -> bool:
	return is_heavy_attack_pressed() or is_gamepad_heavy_attack_pressed()

# === MOVIMENTO CONTÍNUO ===
func is_movement_active() -> bool:
	return get_movement_direction().length_squared() > 0.0
