extends ShootingEnemy
class_name ShootingBoss

func shoot_at_player():
    var direction = (player.global_position - global_position).normalized()
    
    # Define offset positions relative to the boss's facing direction
    var offsets = [
        Vector2(-20, 0), # Left side (relative to boss orientation)
        Vector2(0, 0), # Center
        Vector2(20, 0) # Right side (relative to boss orientation)
    ]
    
    # Shoot 3 bullets from different positions but same direction
    for offset in offsets:
        # Rotate the offset based on the boss's current rotation
        var rotated_offset = offset.rotated(rotation)
        var bullet_origin = global_position + rotated_offset
        
        var bullet: EnemyBullet = bullet_scene.instantiate()
        get_tree().current_scene.add_child(bullet)
        
        bullet.setup(bullet_origin, direction)
        bullet.scale = Vector2(1.5, 1.5)
    
    # Set cooldown (same as parent class)
    can_shoot = false
    shoot_timer.start()