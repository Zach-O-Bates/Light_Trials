extends Node2D


func _on_boundary_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	Global.playerBody.queue_free()

	


func _on_dummy_area_entered(area: Area2D) -> void:
	if area == Global.playerWeaponHitBox:
		$Dummy/TextEdit.visible = true
		var damage = Global.playerDamage
		$Dummy/TextEdit.text = str(damage)
