class_name Arrow
extends Area2D

var _direction: Vector2 = Vector2.RIGHT
var _damage: int = 15
var _speed: float = 420.0
var _lifetime: float = 3.5

func launch(direction: Vector2, dmg: int, proj_speed: float) -> void:
	_direction = direction.normalized()
	_damage = dmg
	_speed = proj_speed
	rotation = _direction.angle()

func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(_damage)
		queue_free()
