extends Node2D

@export var demon: PackedScene
@export var bat: PackedScene
@export var hound: PackedScene

var current_wave: int

var starting_nodes: int
var current_nodes: int
var wave_end

func _ready() -> void:
	current_wave = 0
	Global.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_wave()

func position_to_wave():
	if current_nodes == starting_nodes:
		if current_wave !=0 :
			Global.moving_to_wave = true
		wave_end = false
		current_wave += 1
		Global.current_wave = current_wave
		start_spawn("bats", 2.0, 2.0)
		start_spawn("hounds", 1.5, 1.0)
		start_spawn("demon", .20, 1.0)
		
		
func start_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time:float = 2.0
	print("mob_amount: ", mob_amount)
	var mob_spawn_rounds = mob_amount/mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)
	
func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type=="bats":
		var bat_spawn1 = $BatSpawn1
		var bat_spawn2 = $BatSpawn2
		if mob_spawn_rounds >=1:
			for i in mob_spawn_rounds:
				var bat1 = bat.instantiate()
				bat1.global_position = bat_spawn1.global_position
				var bat2 = bat.instantiate()
				bat2.global_position = bat_spawn2.global_position
				add_child(bat1)
				add_child(bat2)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	if type =="hounds":
		var hound_spawn1 = $HoundSpawn1
		if mob_spawn_rounds >=1:
			for i in mob_spawn_rounds:
				var hound1 = hound.instantiate()
				hound1.global_position = hound_spawn1.global_position
				add_child(hound1)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	if type =="demon":
		var demon_spawn1 = $DemonSpawn1
		if mob_spawn_rounds >=1:
			for i in mob_spawn_rounds:
				var demon1 = demon.instantiate()
				demon1.global_position = demon_spawn1.global_position
				add_child(demon1)
				mob_spawn_rounds -= 1
				if Global.playerAlive:
					await get_tree().create_timer(mob_wait_time).timeout
	wave_end = true


func _process(delta: float) -> void:
	if !Global.playerAlive:
		await get_tree().create_timer(1.0).timeout
		update_score()
		get_tree().change_scene_to_file("res://Scenes/TrialEnd.tscn")
		
	current_nodes = get_child_count()
	if wave_end:
		position_to_wave()

func update_score():
	Global.previous_score = Global.current_score
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	Global.current_score = 0
