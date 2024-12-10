extends CharacterBody2D
class_name Bat

@export var heart: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
const speed = 50
var dir: Vector2

var is_bat_chase: bool
var player:CharacterBody2D

var health = 30
var health_max = 30
var health_min = 0
var dead = false
var taking_damahe = false
var is_roaming: bool
var DamageDealt = 10
var bat_points = 20
var has_printed = false

func _ready():
	is_bat_chase = true
	
func _process(delta):
	Global.batDamageAmount = DamageDealt
	Global.batDamageZone = $BiteZone
	
	if Global.playerAlive:
		is_bat_chase = true
	elif !Global.playerAlive:
		is_bat_chase = false
	
	move(delta)
	handle_animation()
	
func handle_animation():
	if !dead and !taking_damahe:
		animated_sprite.play("Fly")
		if dir.x ==1:
			animated_sprite.flip_h = false 
		elif dir.x ==-1:
			animated_sprite.flip_h = true
	elif !dead and taking_damahe:
		animated_sprite.play("Hurt")
		await get_tree().create_timer(1.0).timeout
		taking_damahe = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play('Death')
		

func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damahe and is_bat_chase and Global.playerAlive:
			velocity = position.direction_to(player.position) * speed
			dir.x = abs(velocity.x)/ velocity.x
		elif taking_damahe: 
			var knockback_dir = position.direction_to(player.position)*-50
			velocity = knockback_dir
			taking_damahe = false
		else:
			velocity += dir * speed * delta
	elif dead:
		velocity.x = 0
		animated_sprite.play("Death")
		await get_tree().create_timer(2).timeout
		Global.current_score += bat_points
		queue_free()
	move_and_slide()
		
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 2.0, 1.5])
	if !is_bat_chase:
		dir = choose([Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN])
		
func choose(array):
	array.shuffle()
	return array.front()


func _on_bat_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerWeaponHitBox:
		var damage = Global.playerDamage
		take_damage(damage)
		
func take_damage(damage):
	health -= damage
	taking_damahe = true
	if health <= 0:
		health = 0
		dead = true
	
