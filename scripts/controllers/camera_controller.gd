extends Node
class_name CameraController

## Controller de Câmera
## Responsável por: rotação horizontal/vertical, suavização e limites

# === CONSTANTES ===
const CAMERA_DEADZONE: float = 0.1
const MOUSE_SENSITIVITY: float = 0.002
const KEYBOARD_SENSITIVITY: float = 0.03
const GAMEPAD_SENSITIVITY: float = 0.15
const CAMERA_SMOOTHING: float = 1.0
const VERTICAL_ANGLE_MIN: float = -PI/3
const VERTICAL_ANGLE_MAX: float = PI/3

# === REFERÊNCIA AO PARENT ===
var _player: CharacterBody3D

# === COMPONENTES ===
var _camera_pivot: Node3D
var _input: InputController

# === ESTADO ===
var _smoothed_input: Vector2 = Vector2.ZERO

# === INICIALIZAÇÃO ===
func _ready() -> void:
	_player = get_parent() as CharacterBody3D
	if not _player:
		push_error("CameraController deve ser filho de CharacterBody3D")
		return
	
	_camera_pivot = _player.get_node_or_null("CameraPivot")
	if not _camera_pivot:
		push_error("CameraPivot não encontrado no Player")
		return
	
	# Encontra o InputController no pai
	_input = _player.get_node_or_null("InputController")

# === LOOP PRINCIPAL ===
func process_camera(_delta: float) -> void:
	var camera_input := _get_camera_input()
	
	if camera_input.length_squared() > CAMERA_DEADZONE:
		_rotate_camera(camera_input)

# === INPUT ===
func _get_camera_input() -> Vector2:
	var combined := Vector2.ZERO
	
	# Mouse
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_motion := Input.get_last_mouse_velocity()
		combined += Vector2(
			mouse_motion.x * MOUSE_SENSITIVITY,
			mouse_motion.y * MOUSE_SENSITIVITY
		)
	
	# Teclado (Setas)
	combined += Vector2(
		Input.get_axis("camera_left", "camera_right"),
		Input.get_axis("camera_up", "camera_down")
	) * KEYBOARD_SENSITIVITY
	
	# Gamepad (Analógico Direito)
	combined += Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		-Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	) * GAMEPAD_SENSITIVITY
	
	# Suavização
	_smoothed_input = _smoothed_input.lerp(combined, CAMERA_SMOOTHING)
	
	return _smoothed_input

# === ROTAÇÃO ===
func _rotate_camera(input: Vector2) -> void:
	if not _camera_pivot:
		return
	
	# Rotação horizontal (Y)
	_camera_pivot.rotation.y -= input.x
	
	# Rotação vertical (X) - com limite
	_camera_pivot.rotation.x -= input.y
	_camera_pivot.rotation.x = clamp(
		_camera_pivot.rotation.x,
		VERTICAL_ANGLE_MIN,
		VERTICAL_ANGLE_MAX
	)

# === GETTERS ===
func get_camera_rotation_y() -> float:
	if _camera_pivot:
		return _camera_pivot.rotation.y
	return 0.0

func get_camera_rotation_x() -> float:
	if _camera_pivot:
		return _camera_pivot.rotation.x
	return 0.0
