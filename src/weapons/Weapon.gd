class_name Weapon
extends Node2D

@export var damage: int = 15
@export var fire_rate: float = 1.2
@export var projectile_speed: float = 420.0

var _fire_timer: float = 0.0
var _owner_entity: Entity = null

func _ready() -> void:
	_owner_entity = get_parent() as Entity

func _physics_process(delta: float) -> void:
	_fire_timer = maxf(0.0, _fire_timer - delta)
	if _fire_timer <= 0.0:
		var target: Node2D = _acquire_target()
		if target != null:
			fire(target)
			_fire_timer = 1.0 / fire_rate

func _acquire_target() -> Node2D:
	if _owner_entity is Player:
		return (_owner_entity as Player).scan_for_enemies(["enemies"], global_position)
	return null

# Overridden by subclasses to define projectile behaviour.
func fire(_target: Node2D) -> void:
	pass
