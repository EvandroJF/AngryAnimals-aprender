extends AudioStreamPlayer

@onready var splash: AudioStreamPlayer = $"."

func _on_water_body_entered(body: Node2D) -> void:
	splash.play()
