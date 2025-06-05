extends CannonEnemy
class_name CannonBoss

func shoot_heavy_bullet():
    # Shoot 12 bullets in a full circle around the boss
    var num_bullets = 12
    var angle_step = 2 * PI / num_bullets # 360 degrees / 12 = 30 degrees per bullet
    
    for i in range(num_bullets):
        var angle = i * angle_step
        var direction = Vector2(cos(angle), sin(angle))
        
        var bullet: EnemyBullet = bullet_scene.instantiate()
        get_tree().current_scene.add_child(bullet)
        
        bullet.setup(global_position, direction)
        bullet.scale = Vector2(3.0, 3.0) # Keep the heavy bullet scaling
    
    # Set cooldown (same as parent class)
    can_shoot = false
    shoot_timer.start()