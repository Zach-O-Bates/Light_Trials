extends RichTextLabel

var default_text = "Trial Score: "

func _process(delta):
	  # Concatenate the strings properly
	var text = default_text + str(Global.previous_score)
	# Set the label's text property
	self.text = text
