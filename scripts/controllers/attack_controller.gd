extends Node
class_name AttackController

## Controller de Ataques
## Responsável por: ataques leves, pesados, combos e dano

# === CLASSE BASE DE ATAQUE (Herança) ===
class BaseAttack:
	var damage: int = 10
	var cooldown: float = 0.5
	var range: float = 2.0
	var animation_name: String = ""
	var is_active: bool = false
	
	func execute(attacker: Node3D) -> void:
		is_active = true
		print("Executando ataque: %s (dano: %d)" % [animation_name, damage])
		# TODO: Aplicar dano aos inimigos no range
	
	func finish() -> void:
		is_active = false

# === TIPOS DE ATAQUE (Herança) ===
class LightAttack extends BaseAttack:
	func _init() -> void:
		damage = 10
		cooldown = 0.3
		range = 2.0
		animation_name = "light_attack"

class HeavyAttack extends BaseAttack:
	func _init() -> void:
		damage = 25
		cooldown = 0.8
		range = 2.5
		animation_name = "heavy_attack"

class JumpAttack extends BaseAttack:
	func _init() -> void:
		damage = 20
		cooldown = 0.6
		range = 3.0
		animation_name = "jump_attack"

# === CONSTANTES ===
const COMBO_WINDOW: float = 0.5

# === REFERÊNCIA AO PARENT ===
var _body: CharacterBody3D

# === ESTADO ===
var _current_attack: BaseAttack = null
var _can_attack: bool = true
var _combo_count: int = 0
var _combo_timer: float = 0.0

# === INICIALIZAÇÃO ===
func _ready() -> void:
	_body = get_parent() as CharacterBody3D
	if not _body:
		push_error("AttackController deve ser filho de CharacterBody3D")

# === ATAQUE PRINCIPAL ===
func perform_attack(attack_type: String) -> void:
	if not _can_attack:
		return
	
	var attack := _create_attack(attack_type)
	if not attack:
		return
	
	_current_attack = attack
	_can_attack = false
	
	# Executa ataque
	attack.execute(_body)
	_apply_damage_to_enemies()
	
	# Finaliza após cooldown
	await _body.get_tree().create_timer(attack.cooldown).timeout
	attack.finish()
	_can_attack = true
	_current_attack = null

# === CRIA ATAQUE ===
func _create_attack(attack_type: String) -> BaseAttack:
	match attack_type:
		"light":
			return LightAttack.new()
		"heavy":
			return HeavyAttack.new()
		"jump":
			return JumpAttack.new()
		_:
			push_warning("Tipo de ataque desconhecido: %s" % attack_type)
			return null

# === APLICA DANO ===
func _apply_damage_to_enemies() -> void:
	if not _current_attack:
		return
	
	var space_state := _body.get_world_3d().direct_space_state
	var query := PhysicsShapeQueryParameters3D.new()
	# TODO: Implementar detecção de área de ataque
	
	print("Aplicando %d de dano na área de %0.1fm" % [_current_attack.damage, _current_attack.range])

# === COMBO SYSTEM ===
func register_combo() -> void:
	_combo_count += 1
	_combo_timer = COMBO_WINDOW
	print("Combo x%d!" % _combo_count)

func _process(delta: float) -> void:
	if _combo_timer > 0:
		_combo_timer -= delta
		if _combo_timer <= 0:
			_combo_count = 0

# === GETTERS ===
func is_attacking() -> bool:
	return _current_attack != null and _current_attack.is_active

func can_attack() -> bool:
	return _can_attack

func get_combo_count() -> int:
	return _combo_count
