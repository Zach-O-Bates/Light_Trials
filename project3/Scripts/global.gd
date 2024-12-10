extends Node

var playerAlive: bool
var playerBody: CharacterBody2D
var playerHitBox: Area2D
var playerWeaponHitBox: Area2D
var playerDamage: int

var batDamageZone: Area2D
var batDamageAmount: int

var houndDamageZone: Area2D
var houndDamageAmount: int

var knightDamageZone: Area2D
var knightDamageAmount: int

var current_wave: int
var moving_to_wave: bool

var high_score = 0
var current_score: int
var previous_score: int
var hearts_collected = 0
