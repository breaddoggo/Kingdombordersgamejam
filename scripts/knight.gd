extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		body.is_in_knight_area = true
		if body.attacking:
			queue_free()
		elif not body.crouching:
			body.queue_free()


func _on_body_exited(body):
	if body.name == "Player":
		body.is_in_knight_area = false
