#extends Node
#
## Si se cambia el DATA_VERSION se debería añadir nueva data que
## va a contener el juego en un nuevo método llamado:
## data_version_xx() en el cuál xx representaría el número
## consecutivo al método anterior.
## El DATA_VERSION es útil para cuando se requiera una
## actualización de la data, por ejemplo: en una nueva versión
## añadir cofres o skins, etc. 
#const DATA_VERSION = 0
## Cambiar el número si se necesita borrar la data y crearla de nuevo,
## usar solo en casos de que se requiera forzadamente.
#const DELETE_DATA = 0 #
#
#func _ready():
#	DataManager.load_data()
#
#	# Tiene DELETE_DATA
#	if DataManager.data.has("DeleteData"):
#		# Si la DELETE_DATA es diferente
#		if DataManager.data["DeleteData"] != DELETE_DATA:
#			DataManager.Persistence.remove_all_data()
#
#			DataManager.data["DeleteData"] = DELETE_DATA
#			DataManager.Persistence.save_data()
#
#			# Al cambiar de DELETE_DATA se sale del juego al
#			# apenas iniciar, todavía no he logrado hacer que
#			# simplemente se reinicie el juego.
#			get_tree().quit()
#		else:
#			# Si no tiene AcceptPrivacyPolicy
#			if not DataManager.data.has("AcceptPrivacyPolicy"):
#				DataManager.data["AcceptPrivacyPolicy"] = false
#				Main.is_first_time = true
#			elif not DataManager.data["AcceptPrivacyPolicy"]:
#				Main.is_first_time = true
#			else:
#				create_data_if_not_exist()
#	# No hay DataVersion es un nuevo usuario
#	else:
#		DataManager.data["DeleteData"] = DELETE_DATA
#
#		if not DataManager.data.has("AcceptPrivacyPolicy"):
#			DataManager.data["AcceptPrivacyPolicy"] = false
#			Main.is_first_time = true
#		elif DataManager.data["AcceptPrivacyPolicy"] == true:
#			create_data_if_not_exist()
#
#	DataManager.Persistence.save_data()
#	debug_rpg_elements()
#
#func debug_rpg_elements():
#	pass
#
#func create_data_if_not_exist():
#	# Si la data no existe (No tiene DataVersion)
#	if not DataManager.data.has("DataVersion"):
#		for i in range(1, DATA_VERSION + 1):
#			create_data(i)
#	# La data existe
#	else:
#		# Estamos en una nueva version
#		if DataManager.data["DataVersion"] > DATA_VERSION:
#			for i in range(DATA_VERSION + 1, DataManager.data["DataVersion"] + 1):
#				create_data(i)
#
#func create_data(data_version):
#	if data_version == 1: data_version_1()
#	#elif data_version == 2: data_version_2()
#
#	DataManager.Persistence.save_data()
#
#func data_version_1():
##	DataManager.data = 
#	pass
#
##func data_version_2():
##	pass