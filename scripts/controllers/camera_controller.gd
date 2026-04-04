extends Node
class_name CameraController

## Controller de Câmera
## Responsável por: rotação horizontal/vertical, suavização e limites

# === CONSTANTES ===
const CAMERA_DEADZONE: float = 0.01
const MOUSE_SENSITIVITY: float = 0.002
const KEYBOARD_SENSITIVITY: float = 0.03
const GAMEPAD_SENSITIVITY: float = 0.05
const CAMERA_SMOOTHING: float = 12.0   # Velocidade de lerp
const VERTICAL_ANGLE_MIN: float = -PI / 3
const VERTICAL_ANGLE_MAX: float = PI / 3

# === REFERÊNCIA AO PARENT ===
var _player: CharacterBody3D

# === COMPONENTES ===
var _camera_pivot: Node3D

# === ESTADO ===
var _raw_input: Vector2 = Vector2.ZERO       # input bruto acumulado
var _smoothed_input: Vector2 = Vector2.ZERO  # input suavizado

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

# === CAPTURA DE MOUSE (deve ser chamado no _input() do pai) ===
func handle_input_event(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_raw_input += Vector2(
				event.relative.x * MOUSE_SENSITIVITY,
				event.relative.y * MOUSE_SENSITIVITY
			)

# === LOOP PRINCIPAL ===
func process_camera(delta: float) -> void:
	var keyboard_gamepad_input := _get_non_mouse_input()
	_raw_input += keyboard_gamepad_input

	# Suavização correta: lerp pelo delta, SMOOTHING controla a velocidade
	_smoothed_input = _smoothed_input.lerp(_raw_input, CAMERA_SMOOTHING * delta)

	if _smoothed_input.length_squared() > CAMERA_DEADZONE * CAMERA_DEADZONE:
		_rotate_camera(_smoothed_input)

	# Zera o raw após consumir, mantendo suavização no decay
	_raw_input = Vector2.ZERO

# === INPUT (teclado e gamepad apenas) ===
func _get_non_mouse_input() -> Vector2:
	var combined := Vector2.ZERO

	# Teclado (Setas)
	combined += Vector2(
		Input.get_axis("camera_left", "camera_right"),
		Input.get_axis("camera_up", "camera_down")
	) * KEYBOARD_SENSITIVITY

	# Gamepad (Analógico Direito)
	var joy_x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	if abs(joy_x) > 0.15 or abs(joy_y) > 0.15:  # deadzone do analógico
		combined += Vector2(joy_x, -joy_y) * GAMEPAD_SENSITIVITY

	return combined

# === ROTAÇÃO ===
func _rotate_camera(input: Vector2) -> void:
	if not _camera_pivot:
		return

	_camera_pivot.rotation.y -= input.x
	_camera_pivot.rotation.x -= input.y
	_camera_pivot.rotation.x = clamp(
		_camera_pivot.rotation.x,
		VERTICAL_ANGLE_MIN,
		VERTICAL_ANGLE_MAX
	)

# === GETTERS ===
func get_camera_rotation_y() -> float:
	return _camera_pivot.rotation.y if _camera_pivot else 0.0

func get_camera_rotation_x() -> float:
	return _camera_pivot.rotation.x if _camera_pivot else 0.0
