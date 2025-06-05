extends EnemyBullet
class_name HeavyBullet

func _ready():
	super._ready()
	
	# Override properties for heavy bullet
	speed = 200.0 # Slower than regular bullets
	damage = 20 # More damage than regular bullets
	lifetime = 8.0 # Longer range
	
	# Make it bigger
	scale = Vector2(1.5, 1.5)