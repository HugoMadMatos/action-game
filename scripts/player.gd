extends CharacterBody3D
class_name Player

## Classe do Jogador - Hack and Slash 3D
## Gerencia controllers e estado geral do jogador

# === ESTADO ===
var _health: int = 100
var _is_alive: bool = true

# === CONTROLLERS (Composição) ===
var input: InputController
var movement: MovementController
var interaction: InteractionController
var attacks: AttackController

# === PROPRIEDADES (Encapsulamento) ===
var health: int:
	get: return _health
	set(value):
		_health = clamp(value, 0, 100)
		if _health <= 0:
			_on_death()

# === INICIALIZAÇÃO ===
func _ready() -> void:
	# Cria e adiciona controllers
	input = InputController.new()
	movement = MovementController.new()
	interaction = InteractionController.new()
	attacks = AttackController.new()
	
	add_child(input)
	add_child(movement)
	add_child(interaction)
	add_child(attacks)

# === LOOP PRINCIPAL ===
func _physics_process(delta: float) -> void:
	if not _is_alive:
		return
	
	# Delega para o controller de movimento
	movement.process_movement(delta)
	
	# Processa inputs
	_handle_actions()
	
	# Processa câmera
	_handle_camera(delta)

# === CÂMERA ===
func _handle_camera(delta: float) -> void:
	var camera_input := input.get_camera_input()
	
	if camera_input.length_squared() > 0:
		var camera_pivot := get_node_or_null("CameraPivot")
		if camera_pivot:
			# Rotação horizontal (Y)
			camera_pivot.rotation.y -= camera_input.x
			
			# Rotação vertical (X) - com limite
			camera_pivot.rotation.x -= camera_input.y
			camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/3, PI/3)

# === INPUTS ===
func _handle_actions() -> void:
	# Pulo
	if input.is_jump_pressed():
		movement.jump()
	
	# Interação
	if input.is_interact_pressed():
		interaction.try_interact()
	
	# Ataques
	if input.is_light_attack_pressed():
		attacks.perform_attack("light")
	
	if input.is_heavy_attack_pressed():
		attacks.perform_attack("heavy")

# === DANO E MORTE ===
func take_damage(amount: int) -> void:
	if not _is_alive:
		return
	
	health -= amount
	print("Player recebeu %d de dano. Vida: %d/%d" % [amount, _health, 100])

func _on_death() -> void:
	_is_alive = false
	print("Player morreu!")
	# TODO: Animação de morte, respawn, etc
	queue_free()

# === GETTERS ===
func is_alive() -> bool:
	return _is_alive
