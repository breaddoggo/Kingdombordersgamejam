extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		$Label.visible = true


func _on_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
