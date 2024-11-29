extends Area2D 
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size #trouver la taille de la fenetre
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # Le vecteur de mouvement de player.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play(); #lance l'animation
	else:
		$AnimatedSprite2D.stop(); #stop l'animation
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk" #selectione l'animation "walk" quand player se déplace à l'horizontal
		$AnimatedSprite2D.flip_v = false #on ne veut pas qu'il soit retourné verticalement
		$AnimatedSprite2D.flip_h = velocity.x < 0 #si la vitesse horizontal est négative c'est parce qu'il va vers  la gauche, on le retourn donc horizontalement
	elif velocity.y != 0: #si il ne se déplace pas horizontalement mais verticalement on fait :
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
