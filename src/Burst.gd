extends Attack
class_name Burst

var type;

func _init(type, curve = 0.0, shots = 5, lifetime = 1.0, spin = 0.0, straighten = 0.0) -> void:
	self.shots = shots
	self.lifetime = lifetime
	self.type = type
	self.curve = curve
	self.spin = spin
	self.straighten = straighten
	prepare_next()

func _shoot(game: Node2D, enemy, angle: float, delta: float):
	if !color:
		color = game.get_random_color()
		
	var rot = enemy.get_shot_angle()
	var offset = Vector2(cos(rot + angle + spin), sin(rot + angle + spin))
	var b = Bullet.new(enemy.body.position + offset * enemy.hitbox_radius, rot + angle + spin, 2000, color)
	prepare_bullet(b)
	game.add_bullet(b)
