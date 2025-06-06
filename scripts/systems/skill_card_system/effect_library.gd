extends Node
class_name EffectLibrary

var player: Player
# var enemy_spawner: EnemySpawner
# var exp_orb: ExpOrb

func _ready():
	player = get_tree().get_first_node_in_group("player")
	# enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
func apply_card_effect(effect_name: String, value: int):
	match effect_name:
		# increase states
		"increase_movement_speed":
			player.speed += value
			player.dash_speed += value * player.dash_speed_speed_ratio
		"increase_movement_speed_percent":
			GameModifiers.player_speed_modifier += value/100.0


		"increase_damage":
			player.bullet.damage += value
		"increase_damage_percent":
			GameModifiers.player_damage_modifier += value/100.0


		"increase_looting":
			player.looting += value
		"increase_looting_percent":
			GameModifiers.looting_modifier += value/100.0


		"increase_health":
			player.health_system.heal(value)
		"increase_health_percent":
			var heal_value = player.health_system.current_health * (value/100.0)
			player.health_system.heal(heal_value)

		"increase_max_health":
			player.health_system.max_health += value
		"increase_max_health_percent":
			GameModifiers.player_health_modifier += value/100.0


		"increase_EXP_gain":
			player.experience_system.gain_experience += value
		"increase_EXP_gain_percent":
			GameModifiers.experience_modifier += value/100.0


		"increase_fire_rate_rpm":
			var round_per_sec = ( 1/player.base_shoot_cooldown - 60/float(value))
			# round_per_sec = 0.4 -> sec_per_round = 2.5 s
			var upper_limit_round_per_sec = 30.0
			round_per_sec = upper_limit_round_per_sec if round_per_sec > upper_limit_round_per_sec else round_per_sec
			# update base_shoot_cooldown
			player.base_shoot_cooldown = (1 / round_per_sec )
			player.shoot_timer.wait_time = player.base_shoot_cooldown / GameModifiers.player_fire_rate_modifier
		"increase_fire_rate_rpm_percent":
			GameModifiers.player_fire_rate_modifier += value/100.0
			player.shoot_timer.wait_time = player.base_shoot_cooldown / GameModifiers.player_fire_rate_modifier


		# decrease states
		"decrease_movement_speed":
			player.speed -= value
			player.dash_speed -= value * player.dash_speed_speed_ratio
		"decrease_movement_speed_percent":
			GameModifiers.player_speed_modifier -= value/100.0


		"decrease_damage":
			player.bullet.damage -= value
		"decrease_damage_percent":
			GameModifiers.player_damage_modifier -= value/100.0


		"decrease_looting":
			player.looting -= value
		"decrease_looting_percent":
			GameModifiers.looting_modifier -= value/100.0


		"decrease_health":
			player.health_system.heal(value)
		"decrease_health_percent":
			var heal_value = player.health_system.current_health * (value/100.0)
			player.health_system.heal(heal_value)

		"decrease_max_health":
			player.health_system.max_health -= value
		"decrease_max_health_percent":
			GameModifiers.player_health_modifier -= value/100.0


		"decrease_EXP_gain":
			
			player.experience_system.gain_experience -= value
		"decrease_EXP_gain_percent":
			GameModifiers.experience_modifier -= value/100.0


		"decrease_fire_rate_rpm":
			var round_per_sec = ( 1/player.base_shoot_cooldown - 60/float(value))
			# round_per_sec = 0.4 -> sec_per_round = 2.5 s
			var lower_limit_round_per_sec = 0.4
			round_per_sec = lower_limit_round_per_sec if round_per_sec < lower_limit_round_per_sec else round_per_sec
			# update base_shoot_cooldown
			player.base_shoot_cooldown = (1 / round_per_sec )
			player.shoot_timer.wait_time = player.base_shoot_cooldown / GameModifiers.player_fire_rate_modifier
		"decrease_fire_rate_rpm_percent":
			GameModifiers.player_fire_rate_modifier -= value/100.0
			player.shoot_timer.wait_time = player.base_shoot_cooldown / GameModifiers.player_fire_rate_modifier

		# handle error
		_:
			print("Unknown effect name: %s value: %s" % [effect_name, value])