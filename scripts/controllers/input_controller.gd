extends Node
class_name InputController

## Controller de Inputs
## Centraliza todos os inputs de teclado e gamepad

# === CONSTANTES DE INPUT ===
const MOVEMENT_DEADZONE: float = 0.2
const CAMERA_DEADZONE: float = 0.1
const CAMERA_SENSITIVITY_KEYBOARD: float = 0.03
const CAMERA_SENSITIVITY_GAMEPAD: float = 0.15
const MOUSE_SENSITIVITY: float = 0.002
const CAMERA_SMOOTHING: float = 1.0

# === ESTADO ===
var _movement_vector: Vector2 = Vector2.ZERO
var _gamepad_movement: Vector2 = Vector2.ZERO
var _camera_input: Vector2 = Vector2.ZERO
var _smoothed_camera_input: Vector2 = Vector2.ZERO

# === INICIALIZAÇÃO ===
func _ready() -> void:
	# Testa se tem gamepad conectado
	for device in range(4):
		var name := Input.get_joy_name(device)
		if name != "":
			print("Gamepad detectado: device %d = %s" % [device, name])

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
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
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
	return Input.is_action_just_pressed("jump")

func is_interact_pressed() -> bool:
	return Input.is_action_just_pressed("interact")

func is_light_attack_pressed() -> bool:
	return Input.is_action_just_pressed("light_attack")

func is_heavy_attack_pressed() -> bool:
	return Input.is_action_just_pressed("heavy_attack")

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

# === CÂMERA ===
func get_camera_input() -> Vector2:
	var keyboard := _get_keyboard_camera_input()
	var gamepad := _get_gamepad_camera_input()
	var mouse := _get_mouse_camera_input()
	
	var combined := keyboard + gamepad + mouse
	
	# Suaviza o input com lerp
	_smoothed_camera_input = _smoothed_camera_input.lerp(combined, CAMERA_SMOOTHING)
	
	if _smoothed_camera_input.length_squared() > CAMERA_DEADZONE:
		return _smoothed_camera_input
	
	return Vector2.ZERO

func _get_keyboard_camera_input() -> Vector2:
	return Vector2(
		Input.get_axis("camera_left", "camera_right"),
		Input.get_axis("camera_up", "camera_down")
	) * CAMERA_SENSITIVITY_KEYBOARD

func _get_gamepad_camera_input() -> Vector2:
	var x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var y := -Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	var input := Vector2(x, y)
	if input.length_squared() < CAMERA_DEADZONE:
		return Vector2.ZERO
	
	return input * CAMERA_SENSITIVITY_GAMEPAD

# === CÂMERA (Mouse) ===
func _get_mouse_camera_input() -> Vector2:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_motion := Input.get_last_mouse_velocity()
		return Vector2(
			mouse_motion.x * MOUSE_SENSITIVITY,
			mouse_motion.y * MOUSE_SENSITIVITY
		)
	
	return Vector2.ZERO
