extends Control

func _ready():
	$PlayerContainer.recalculate_attack()

func _on_weapon_pp_up_pressed():
	if $PlayerContainer.particlePoints > 0:
		$PlayerContainer.particlePoints -= 1
		$PlayerContainer.weaponPP += 1
	$PlayerContainer.recalculate_attack()

func _on_weapon_pp_down_pressed():
	if $PlayerContainer.weaponPP > 1:
		$PlayerContainer.particlePoints += 1
		$PlayerContainer.weaponPP -= 1
	$PlayerContainer.recalculate_attack()

func _on_weapon_dd_up_pressed():
	if $PlayerContainer.weaponDiceCategory < 12:
		$PlayerContainer.weaponDiceCategory += 2
	$PlayerContainer.recalculate_attack()

func _on_weapon_dd_down_pressed():
	if $PlayerContainer.weaponDiceCategory > 4:
		$PlayerContainer.weaponDiceCategory -= 2
	$PlayerContainer.recalculate_attack()


func _on_defense_pp_up_pressed():
	if $PlayerContainer.particlePoints > 0:
		$PlayerContainer.particlePoints -= 1
		$PlayerContainer.defensePP += 1
	$PlayerContainer.recalculate_defense()

func _on_defense_pp_down_pressed():
	if $PlayerContainer.defensePP > 1:
		$PlayerContainer.particlePoints += 1
		$PlayerContainer.defensePP -= 1
	$PlayerContainer.recalculate_defense()

func _on_defense_dd_up_pressed():
	if $PlayerContainer.defenseDiceCategory < 12:
		$PlayerContainer.defenseDiceCategory += 2
	$PlayerContainer.recalculate_defense()

func _on_defense_dd_down_pressed():
	if $PlayerContainer.defenseDiceCategory > 4:
		$PlayerContainer.defenseDiceCategory -= 2
	$PlayerContainer.recalculate_defense()


func end_turn():
	var player = $PlayerContainer
	var enemy = $EnemyContainer

	# Player rolls
	var playerDamageRolls = player.roll_damage()
	var playerDefenseRolls = player.roll_defense()

	# Voltrex rolls
	var enemyDamageRolls = enemy.roll_damage()
	var enemyDefenseRolls = enemy.roll_defense()

	var newPlayerAttackResults = []
	var newEnemyAttackResults = []

	for roll in enemyDamageRolls:
		if roll in playerDefenseRolls:
			playerDefenseRolls.erase(roll)
			enemyDamageRolls.erase(roll)
		else:
			newEnemyAttackResults.append(roll)
			
	for roll in playerDamageRolls:
		if roll in enemyDefenseRolls:
			enemyDefenseRolls.erase(roll)
			playerDamageRolls.erase(roll)
		else:
			newPlayerAttackResults.append(roll)
	
	for roll in newEnemyAttackResults:
		player.hp -= roll
		
	for roll in newPlayerAttackResults:
		enemy.hp -= roll
	
	print("Player HP: ", player.hp)
	print("Enemy HP: ", enemy.hp)
	
	player.calculate_hp()
	enemy.calculate_hp()

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
