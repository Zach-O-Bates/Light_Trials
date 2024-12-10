extends RichTextLabel

var default_text = "CURRENT SCORE: "

func _process(delta):
	  # Concatenate the strings properly
	var text = default_text + str(Global.current_score)
	# Set the label's text property
	self.text = text
