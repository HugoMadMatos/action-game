extends CharacterBody3D
class_name Player

## Classe do Jogador - Hack and Slash 3D
## Responsável por movimento, combate e estado do jogador

# === CONSTANTES ===
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const GRAVITY: float = 9.8

# === VARIÁVEIS DE ESTADO ===
var _health: int = 100
var _is_attacking: bool = false
var _can_attack: bool = true

# === PROPRIEDADES (Encapsulamento) ===
var health: int:
	get: return _health
	set(value):
		_health = clamp(value, 0, 100)
		if _health <= 0:
			_on_death()

# === MÉTODOS DO GODOT ===
func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Processa entrada
	_handle_movement(delta)
	
	# Move o personagem
	move_and_slide()

# === MÉTODOS DE MOVIMENTO ===
func _handle_movement(delta: float) -> void:
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

# === MÉTODOS DE COMBATE ===
func attack() -> void:
	if not _can_attack:
		return
	
	_is_attacking = true
	_can_attack = false
	
	# TODO: Implementar lógica de ataque
	print("Player atacou!")
	
	# Cooldown simples
	await get_tree().create_timer(0.5).timeout
	_can_attack = true
	_is_attacking = false

func take_damage(amount: int) -> void:
	health -= amount
	print("Player recebeu %d de dano. Vida atual: %d" % [amount, _health])

# === MÉTODOS INTERNOS ===
func _on_death() -> void:
	print("Player morreu!")
	# TODO: Implementar lógica de morte
	queue_free()
