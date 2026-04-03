extends Node
class_name MovementController

## Controller de Movimentação
## Responsável por: andar, pular, gravidade e direção do jogador

# === CONSTANTES ===
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const GRAVITY: float = 9.8

# === REFERÊNCIA AO PARENT ===
var _body: CharacterBody3D
var _input: InputController

# === INICIALIZAÇÃO ===
func _ready() -> void:
	_body = get_parent() as CharacterBody3D
	if not _body:
		push_error("MovementController deve ser filho de CharacterBody3D")
	
	# Encontra o InputController no pai
	_input = _body.get_node_or_null("InputController")

# === MÉTODO PRINCIPAL ===
func process_movement(delta: float) -> void:
	_apply_gravity(delta)
	_handle_input()
	_body.move_and_slide()

# === GRAVIDADE ===
func _apply_gravity(delta: float) -> void:
	if not _body.is_on_floor():
		_body.velocity.y -= GRAVITY * delta

# === INPUT ===
func _handle_input() -> void:
	var input_dir := _get_input_direction()
	var direction := _calculate_world_direction(input_dir)
	
	if direction:
		_apply_velocity(direction)
	else:
		_decelerate()

func _get_input_direction() -> Vector2:
	if _input:
		return _input.get_movement_direction()
	
	# Fallback se input não estiver disponível
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

func _calculate_world_direction(input_dir: Vector2) -> Vector3:
	return (_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func _apply_velocity(direction: Vector3) -> void:
	_body.velocity.x = direction.x * SPEED
	_body.velocity.z = direction.z * SPEED

func _decelerate() -> void:
	_body.velocity.x = move_toward(_body.velocity.x, 0, SPEED)
	_body.velocity.z = move_toward(_body.velocity.z, 0, SPEED)

# === PULO ===
func jump() -> void:
	if _body.is_on_floor():
		_body.velocity.y = JUMP_VELOCITY

# === GETTERS ===
func get_velocity() -> Vector3:
	return _body.velocity

func is_moving() -> bool:
	return _body.velocity.length_squared() > 0.1

func is_on_floor() -> bool:
	return _body.is_on_floor()
