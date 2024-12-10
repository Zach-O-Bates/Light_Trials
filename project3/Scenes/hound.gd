extends CharacterBody2D
class_name Hound

@onready var animated_sprite = $AnimatedSprite2D
const speed = 70
const gravity = 400.0
var dir: Vector2

var is_hound_chase: bool
var player:CharacterBody2D

var health = 30
var health_max = 30
var health_min = 0
var dead = false
var taking_damage = false
var is_roaming: bool
var DamageDealt = 7.5
var hound_points = 40

func _ready():
	is_hound_chase = true
	
func _process(delta):
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	Global.houndDamageAmount = DamageDealt
	Global.houndDamageZone = $BiteZone
	if Global.playerAlive:
		is_hound_chase = true
	elif !Global.playerAlive:
		is_hound_chase = false
		
	move(delta)
	handle_animation()
	
func handle_animation():
	if !dead and !taking_damage:
		animated_sprite.play("Run")
		if dir.x ==1:
			animated_sprite.flip_h = false 
		elif dir.x ==-1:
			animated_sprite.flip_h = true
	elif !dead and taking_damage:
		animated_sprite.play("Hurt")
		await get_tree().create_timer(1.0).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play('Death')
		

func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damage and is_hound_chase and Global.playerAlive:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs (velocity.x) / velocity.x
		elif taking_damage: 
			var knockback_dir = position.direction_to(player.position)*-50
			velocity = knockback_dir
			taking_damage = false
		else:
			velocity += dir * speed * delta
	elif dead:
		velocity.x = 0
		animated_sprite.play("Death")
		await get_tree().create_timer(1).timeout
		Global.current_score += hound_points
		queue_free()
	move_and_slide()
		
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 2.0, 1.5])
	if !is_hound_chase:
		dir = choose([Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN])
		
func choose(array):
	array.shuffle()
	return array.front()

		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerWeaponHitBox:
		var damage = Global.playerDamage
		take_damage(damage)
