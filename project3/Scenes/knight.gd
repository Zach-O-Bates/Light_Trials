extends CharacterBody2D

class_name Demon

var speed = 40
var is_demon_chase: bool = true

var health = 100
var health_max = 100
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 15
var is_dealing_damage: bool = false
const gravity = 900

var dir: Vector2
var knockback = -20
var is_roaming: bool = false

var player = CharacterBody2D
var player_in_area = false
var demon_points = 100

func _process(delta):
	if !is_on_floor():
		velocity.y += speed * delta
		velocity.x = 0
	player = Global.playerBody
	Global.knightDamageAmount = damage_to_deal
	Global.knightDamageZone = $KnightDamageBox

	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_demon_chase:
			velocity += dir * speed * delta
		elif is_demon_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	
	if dir.x == -1:
		anim_sprite.flip_h = true
	elif dir.x == 1:
		anim_sprite.flip_h = false

	

	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("Run")  
	elif !dead and taking_damage and !is_dealing_damage:
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif !dead and !taking_damage and is_dealing_damage:
		if anim_sprite.animation != "Attack":  # Only play Attack if it's not already playing
			anim_sprite.play("Attack")
			print("Playing attack animation")  # Debug print to confirm attack is playing
			await get_tree().create_timer(1.0).timeout  # Wait for the attack animation to complete
			is_dealing_damage = false  # Reset flag after animation is done
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play('Death')
		Global.current_score += demon_points
		await get_tree().create_timer(1.0).timeout
		death()

func death():
	queue_free()

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([2.5, 1, 2.5])
	if !is_demon_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= health_min:
		dead = true

		
func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage = Global.playerDamage
	if area == Global.playerWeaponHitBox:
		taking_damage = true
		take_damage(damage)


func _on_knight_damage_box_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		print("Knight damage box area entered!")
		is_dealing_damage = true  
		taking_damage = false
