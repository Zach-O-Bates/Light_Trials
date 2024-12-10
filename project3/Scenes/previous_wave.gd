extends RichTextLabel

var default_text = "Trial Score: "

func _process(delta):
	  
	var text = default_text + str(Global.previous_score)
	self.text = text
