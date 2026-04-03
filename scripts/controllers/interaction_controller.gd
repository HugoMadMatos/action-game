extends Node
class_name InteractionController

## Controller de Interação
## Responsável por: interagir com objetos próximos (baús, portas, alavancas, etc)

# === CONSTANTES ===
const INTERACTION_RANGE: float = 2.0
const INTERACTION_RAY_COUNT: int = 5

# === REFERÊNCIA AO PARENT ===
var _body: CharacterBody3D

# === ESTADO ===
var _interactable_in_range: Node3D = null
var _can_interact: bool = true

# === INICIALIZAÇÃO ===
func _ready() -> void:
	_body = get_parent() as CharacterBody3D
	if not _body:
		push_error("InteractionController deve ser filho de CharacterBody3D")

# === INTERAÇÃO PRINCIPAL ===
func try_interact() -> bool:
	if not _can_interact:
		return false
	
	var target := _find_nearest_interactable()
	if target:
		_interact_with(target)
		return true
	
	return false

# === DETECÇÃO DE INTERACTABLES ===
func _find_nearest_interactable() -> Node3D:
	var space_state := _body.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		_body.global_position,
		_body.global_position + _body.global_transform.basis.z * -INTERACTION_RANGE
	)
	query.collide_with_areas = true
	
	var result := space_state.intersect_ray(query)
	if result:
		var collider := result.collider as Node3D
		if collider and collider.has_method("interact"):
			return collider
	
	return null

# === EXECUÇÃO DA INTERAÇÃO ===
func _interact_with(target: Node3D) -> void:
	_can_interact = false
	
	print("Interagindo com: %s" % target.name)
	target.interact(_body)
	
	# Cooldown
	await _body.get_tree().create_timer(0.5).timeout
	_can_interact = true

# === GETTERS ===
func has_interactable_nearby() -> bool:
	return _find_nearest_interactable() != null

func get_interactable_name() -> String:
	var target := _find_nearest_interactable()
	return target.name if target else ""
