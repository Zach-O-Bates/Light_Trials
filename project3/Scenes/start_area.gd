extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boundary_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	Global.playerBody.queue_free()

	


func _on_dummy_area_entered(area: Area2D) -> void:
	if area == Global.playerWeaponHitBox:
		$Dummy/TextEdit.visible = true
		var damage = Global.playerDamage
		$Dummy/TextEdit.text = str(damage)
