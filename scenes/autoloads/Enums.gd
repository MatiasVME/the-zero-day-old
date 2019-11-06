extends Node

enum PlayerType {
	DORBOT,
	MATBOT,
	PIXBOT,
	SERBOT
}

# A quién pertence el objeto o escena?
enum ActorOwner {
	UNDEFINED,
	ENEMY,
	PLAYER,
	NATURE
}

# En un futuro se implimentará esto
enum Elements {
	WATER,
	FIRE,
	AIR,
	ELECTRICITY,
	EARTH
}

# Esto se utiliza para las estructuras y para las
# structure box
enum StructureType {
	CORE,
	COMMON_FACTORY,
	VEHICLE_FACTORY,
	TURRET_FACTORY,
	MINING_FACTORY,
	SHOP_FACTORY,
	LIGHT_TURRET
}

enum StructureSize {
	W1X1, # Wall 1x1
	S1X1, # Structure 1x1
	S2X2, # ... 2x2
	S3X3, # ..
	S2X3,
	S3X2
}