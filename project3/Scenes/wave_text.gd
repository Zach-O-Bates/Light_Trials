extends RichTextLabel

var default_text = "CURRENT TRIAL: "


func _process(delta: float) -> void:
	var text = default_text + str(Global.current_wave)
	self.text = text
