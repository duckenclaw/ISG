extends Control

func _ready():
	$PlayerContainer.recalculate_weapon()

func _on_weapon_pp_up_pressed():
	if $PlayerContainer.particlePoints > 0:
		$PlayerContainer.particlePoints -= 1
		$PlayerContainer.weaponPP += 1
	$PlayerContainer.recalculate_weapon()

func _on_weapon_pp_down_pressed():
	if $PlayerContainer.weaponPP > 1:
		$PlayerContainer.particlePoints += 1
		$PlayerContainer.weaponPP -= 1
	$PlayerContainer.recalculate_weapon()

func _on_weapon_dd_up_pressed():
	if $PlayerContainer.weaponDiceCategory < 12:
		$PlayerContainer.weaponDiceCategory += 2
	$PlayerContainer.recalculate_weapon()

func _on_weapon_dd_down_pressed():
	if $PlayerContainer.weaponDiceCategory > 4:
		$PlayerContainer.weaponDiceCategory -= 2
	$PlayerContainer.recalculate_weapon()

func end_turn():
	var player = $PlayerContainer
	var voltex = $EnemyContainer

	# Player rolls
	var playerDamageRolls = player.roll_damage()
	var playerDefenseRolls = player.roll_defense()

	# Voltrex rolls
	var voltexDamageRolls = voltex.roll_damage()
	var voltexDefenseRolls = voltex.roll_defense()

	# Resolve Voltrex's attack
	var voltexAttackResults = voltex.end_turn(playerDamageRolls)
	var newRollResults = []

	for roll in voltexAttackResults:
		if roll in playerDefenseRolls:
			playerDefenseRolls.erase(roll)
		else:
			newRollResults.append(roll)
	
	for roll in newRollResults:
		player.hp -= roll
	
	print("Player HP: ", player.hp)

func create_dice_image(actor, roll_value):
	
	var diceImagePath = "res://art/dice" + str(actor.weaponDiceCategory) + ".png"
	var diceTexture = load(diceImagePath)

	if diceTexture:
		var diceImage = Sprite2D.new()
		diceImage.texture = diceTexture

		var diceLabel = Label.new()
		diceLabel.text = str(roll_value)
		diceLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		diceLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		diceLabel.grow_horizontal = Control.GROW_DIRECTION_BOTH
		diceLabel.grow_vertical = Control.GROW_DIRECTION_BOTH

		diceImage.add_child(diceLabel)
		$DiceImagesContainer.add_child(diceImage)
	else:
		print("Failed to load dice image:", diceImagePath)
