/obj/item/shuttle_module
	name = "shuttle module"
	desc = "Install this to your shuttle compartment."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	var/module_type = MODULE_TYPE_DEFUNCT

/obj/item/shuttle_module/weapon
	name = "shuttle module weapon"
	module_type = MODULE_TYPE_WEAPON
	var/next_fire = 0
	var/fire_cooldown = 1 SECONDS
	var/projectile_type

/obj/item/shuttle_module/weapon/proc/FireAt(datum/overmap_object/firer, datum/overmap_object/target)
	if(next_fire < world.time)
		return FALSE
	next_fire = world.time + fire_cooldown
	return TRUE

/obj/item/shuttle_module/weapon/mining_laser
	name = "shuttle module mining laser"
