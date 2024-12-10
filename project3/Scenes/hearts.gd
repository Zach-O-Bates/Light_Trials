extends RichTextLabel
var default_text = "Hearts Collected: "


func _process(delta: float) -> void:
	var text = default_text + str(Global.hearts_collected)
	self.text = text
