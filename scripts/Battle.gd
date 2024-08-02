extends Control

var particlePoints = 1
var weaponPP = 5
var armorPP = 1
var dices = 2
var diceCategory = 6
var rollResults = []

# Called when the node enters the scene tree for the first time.
func _ready():
	recalculateWeapon()
	

func recalculateWeapon():
	dices = (weaponPP + 1) / (diceCategory / 2)
	$Panel/VBoxContainer/ParticlePointsCounter.text = str("Particles: ", particlePoints)
	$Panel/VBoxContainer/WeaponContainer/ParticlePoints/WeaponPP.text = str(weaponPP)
	$Panel/VBoxContainer/WeaponContainer/DamageDiceContainer/WeaponDice.text = str("d", diceCategory)
	$Panel/VBoxContainer/WeaponContainer/Damage.text = str(dices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_weapon_pp_up_pressed():
	if particlePoints > 0:
		particlePoints -= 1
		weaponPP += 1
	recalculateWeapon()

func _on_weapon_pp_down_pressed():
	if weaponPP > 1:
		particlePoints += 1
		weaponPP -= 1
	recalculateWeapon()

func _on_weapon_dd_up_pressed():
	if diceCategory < 12:
		diceCategory += 2
	recalculateWeapon()

func _on_weapon_dd_down_pressed():
	if diceCategory > 4:
		diceCategory -= 2
	recalculateWeapon()

func roll_damage():
	print("Player attack roll " + str(dices) + "d" + str(diceCategory) + " dices")
	for dice in range(int(dices)):
		var roll = randi_range(1, diceCategory)
		print(str(dice) + " dice rolled a " + str(roll))
		rollResults.append(roll)
		create_dice_image(roll)

func end_turn():
	rollResults.clear()
	roll_damage()

	# Call Voltex end_turn function
	var voltex = $EnemyContainer
	var remaining_rolls = voltex.end_turn(rollResults)

	# Update rollResults to the remaining rolls after defense
	rollResults = remaining_rolls

func create_dice_image(roll_value):
	var dice_image_path = "res://art/dice" + str(diceCategory) + ".png"
	var dice_texture = load(dice_image_path)

	if dice_texture:
		var dice_image = Sprite2D.new()
		dice_image.texture = dice_texture

		var dice_label = Label.new()
		dice_label.text = str(roll_value)
		dice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dice_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		dice_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		dice_label.grow_vertical = Control.GROW_DIRECTION_BOTH

		dice_image.add_child(dice_label)
		$DiceImagesContainer.add_child(dice_image)
	else:
		print("Failed to load dice image:", dice_image_path)
