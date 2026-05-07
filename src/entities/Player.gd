class_name Player
extends Entity

signal xp_changed(current: int, required: int)
signal level_up(new_level: int)

const XP_BASE: int = 100
const XP_SCALE: float = 1.4
const INVINCIBILITY_TIME: float = 0.8

var level: int = 1
var current_xp: int = 0
var xp_to_next: int = XP_BASE
var _inv_timer: float = 0.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super._ready()
	add_to_group("players")

func _physics_process(delta: float) -> void:
	_handle_movement()
	_tick_invincibility(delta)
	_update_animation()
	move_and_slide()

func _update_animation() -> void:
	if velocity.length() > 1.0:
		_sprite.play("walk")
		if velocity.x != 0.0:
			_sprite.flip_h = velocity.x < 0.0
	else:
		_sprite.play("idle")

func _handle_movement() -> void:
	var dir := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_physical_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_physical_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_physical_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		dir.x += 1
	velocity = dir.normalized() * speed

func _tick_invincibility(delta: float) -> void:
	if is_invincible:
		_inv_timer -= delta
		if _inv_timer <= 0.0:
			is_invincible = false
			_inv_timer = 0.0

# Nested conditionals (3 levels):
#   1. Is the player already invincible?
#   2. Did the attack miss (dodge roll)?
#   3. Is armor high enough to fully absorb the hit?
func take_damage(amount: int, source: Entity = null) -> bool:
	if is_invincible:
		return false
	else:
		if randf() < dodge_chance:
			return false
		else:
			var reduced: int = amount - armor
			if reduced <= 0:
				return false
			else:
				health = max(0, health - reduced)
				health_changed.emit(health, max_health)
				if health <= 0:
					die()
				else:
					is_invincible = true
					_inv_timer = INVINCIBILITY_TIME
				return true

# Nested loops: outer iterates groups, inner iterates each group's members.
# Returns the Node2D closest to 'origin', or null if no enemies exist.
func scan_for_enemies(groups: Array[String], origin: Vector2) -> Node2D:
	var closest: Node2D = null
	var closest_dist: float = INF
	for group_name: String in groups:
		var members: Array = get_tree().get_nodes_in_group(group_name)
		for member: Node in members:
			if member is Node2D:
				var dist: float = origin.distance_to((member as Node2D).global_position)
				if dist < closest_dist:
					closest_dist = dist
					closest = member as Node2D
	return closest

func gain_xp(amount: int) -> void:
	current_xp += amount
	while current_xp >= xp_to_next:
		current_xp -= xp_to_next
		level += 1
		xp_to_next = int(XP_BASE * pow(XP_SCALE, level - 1))
		level_up.emit(level)
	xp_changed.emit(current_xp, xp_to_next)

func die() -> void:
	died.emit()
	GameManager.end_game(false)
	queue_free()
