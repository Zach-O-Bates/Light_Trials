extends RichTextLabel

var default_text = "Best Trial Score: "

func _process(delta):
	var text = default_text + str(Global.high_score)
	self.text = text
