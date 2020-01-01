extends Area2D

func _ready():
	$AnimationPlayer.play("CoinIdle");


func _on_Coin_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("CoinPickup");


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "CoinPickup":
		get_parent().remove_child(self);
