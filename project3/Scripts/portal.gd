extends Node2D



func _ready() -> void:
	$AnimatedSprite2D.play("new_animation")


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
