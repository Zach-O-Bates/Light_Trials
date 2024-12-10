extends Area2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(10.0).timeout


func _on_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		Global.hearts_collected += 1
		queue_free()