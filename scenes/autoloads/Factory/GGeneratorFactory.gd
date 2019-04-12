extends Node

class_name GGeneratorFactory

# Fragmento de enemy level
const EL_FRAGMENT = 1.1
# Fragmento de enemy_type
const ET_FRAGMENT = 1.2
# Fragmento de player_luck
const PL_FRAGMENT = 1.15
# Fragmento de factor aleatorio
const FA_FRAGMENT = 1.05
# Fragmento de pack category
const PC_FRAGMENT = 1.1

static func test(): 
#	print("EL_FRAGMENT: ",EL_FRAGMENT)
#	print("ET_FRAGMENT: ",ET_FRAGMENT)
#	print("PL_FRAGMENT: ",PL_FRAGMENT)
#	print("FA_FRAGMENT: ",FA_FRAGMENT)
	
#	for i in range(1, 100):
#		for j in range(1,4):
#			print("level-", i ,"-enemylevel-",j ,": ", create_rand_distance_weapon(i, j, i))
	
	var mayor = 0
	var menor = 999
	var current = 0

#	for i in 1000000:
#		current = create_rand_distance_weapon(100, 3, 100)
#		if current > mayor:
#			mayor = current
#			print("mayor: ", mayor)
#		elif current < menor:
#			menor = current
#			print("menor: ", menor)
			
	# Segun el test anterior el maximo es 505.7
	# se podria aproximar a 506
