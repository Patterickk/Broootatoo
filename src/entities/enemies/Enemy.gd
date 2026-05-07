class_name Enemy
extends Entity

signal xp_dropped(amount: int, position: Vector2)

@export var xp_value: int = 10
@export var damage: int = 10
@export var attack_range: float = 42.0
@export var attack_cooldown: float = 1.0

var _attack_timer: float = 0.0
var _target: Node2D = null

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super._ready()
	add_to_group("enemies")
	_target = _find_player()

func _physics_process(delta: float) -> void:
	_attack_timer = maxf(0.0, _attack_timer - delta)
	if _target == null or not is_instance_valid(_target):
		_target = _find_player()
		return
	_move_toward_target()
	_try_attack()
	_update_animation()
	move_and_slide()

func _update_animation() -> void:
	if velocity.length() > 1.0:
		_sprite.play("walk")
		if velocity.x != 0.0:
			_sprite.flip_h = velocity.x < 0.0
	else:
		_sprite.play("idle")

func _find_player() -> Node2D:
	var group: Array = get_tree().get_nodes_in_group("players")
	if group.size() > 0:
		return group[0] as Node2D
	return null

func _move_toward_target() -> void:
	if _target == null:
		return
	velocity = (_target.global_position - global_position).normalized() * speed

func _try_attack() -> void:
	if _target == null or _attack_timer > 0.0:
		return
	if global_position.distance_to(_target.global_position) <= attack_range:
		if _target.has_method("take_damage"):
			_target.take_damage(damage, self)
		_attack_timer = attack_cooldown

func die() -> void:
	xp_dropped.emit(xp_value, global_position)
	super.die()
