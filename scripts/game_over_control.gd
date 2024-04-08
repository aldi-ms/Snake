extends Control


func _on_timer_timeout():
	$CanvasLayer/GameOverLabel.visible = !$CanvasLayer/GameOverLabel.visible
