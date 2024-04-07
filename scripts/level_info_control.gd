extends Control

var level := 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/LevelLabel.set_text("Level %d" % level)

