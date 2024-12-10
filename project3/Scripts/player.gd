extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var weapon_hitbox = $DamageZone


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var attack_type: String
var current_attack: bool
var health = 100 
var health_max = 100
var health_min = 0
var can_take_damage: bool
var dead:bool	
var block = false



func _ready():
	Global.playerAlive = true
	Global.playerBody = self
	Global.playerHitBox = $PlayerHitBox
	current_attack = false
	Global.playerWeaponHitBox = weapon_hitbox
	dead = false 
	can_take_damage = true


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !dead:
		if Input.is_action_just_pressed("Jump") and is_on_floor() and !current_attack:
			velocity.y = JUMP_VELOCITY
			animatedSprite.play("Jump")


		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if !current_attack:
			if Input.is_action_just_pressed("Light Attack") or Input.is_action_just_pressed("Heavy Attack"):
				current_attack = true
				if Input.is_action_just_pressed("Light Attack") and is_on_floor():
					attack_type = "Light"
				elif Input.is_action_just_pressed("Heavy Attack") and is_on_floor():
					attack_type = "Heavy"
				else:
					attack_type = "Air"
				set_damage(attack_type)
				handle_attack(attack_type)
		handle_animation(direction)
		check_hitbox()
	move_and_slide()

func check_hitbox():
	var hitbox_areas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox= hitbox_areas.front()
		if hitbox.get_parent() is Bat:
			damage = Global.batDamageAmount
		if hitbox.get_parent() is Hound:
			damage = Global.houndDamageAmount
		if hitbox.get_parent() is Demon:
			damage = Global.knightDamageAmount
	
	if can_take_damage:
		take_damage(damage)

func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			print("player health ", health)
			if health <= 0:
				health = 0
				dead = true
				Global.playerAlive = false
				handle_death()
			take_damage_cooldown(1.0)
			block = false
			
func handle_death():
	animatedSprite.play('Death')
	await get_tree().create_timer(2.0).timeout
	
func take_damage_cooldown(wait):
	can_take_damage = false
	await get_tree().create_timer(wait).timeout
	can_take_damage = true
	
func handle_animation(dir):
	if is_on_floor() and !current_attack:
		if !velocity:
			animatedSprite.play("Idle")
		if velocity:
			animatedSprite.play("Run")
			turn_sprite(dir)
	elif !is_on_floor() and !current_attack:
		animatedSprite.play("Falling")

func handle_attack(attack_type):
	if current_attack:
		var animation = str(attack_type, " Attack")
		animatedSprite.play(animation)
		toggle_weaponHitbox(attack_type)
		
func toggle_weaponHitbox(attack_type):
	var weapon_hit = weapon_hitbox.get_node("CollisionShape2D")
	var wait_time:float
	if attack_type == "Air":
		wait_time = 0.7
	elif attack_type == "Light":
		wait_time = 0.7
	else:
		wait_time = 1.1
	weapon_hit.disabled = false 
	await get_tree().create_timer(wait_time).timeout
	weapon_hit.disabled = true
	

func turn_sprite(dir):
	if dir ==1:
		animatedSprite.flip_h = false 
		weapon_hitbox.scale.x = 1
	if dir ==-1:
		animatedSprite.flip_h = true
		weapon_hitbox.scale.x = -1
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false
	
func set_damage(attack_type):
	var current_damage: int 
	if attack_type == "Light":
		current_damage = 8
	elif attack_type == "Heavy":
		current_damage = 14
	elif attack_type == "Air":
		current_damage = 10
	Global.playerDamage = current_damage
		
