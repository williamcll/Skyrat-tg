/datum/ore_node
	var/list/ores_to_mine
	var/range
	var/x_coord
	var/y_coord
	var/z_coord

/datum/ore_node/New(x, y, z, list/ores, _range)
	x_coord = x
	y_coord = y
	z_coord = z
	ores_to_mine = ores
	range = _range
	//Add to the global list
	if(!GLOB.ore_nodes_by_z_level["[z]"])
		GLOB.ore_nodes_by_z_level["[z]"] = list()
	GLOB.ore_nodes_by_z_level["[z]"] += src

/datum/ore_node/Destroy()
	//Remove from the global list
	GLOB.ore_nodes_by_z_level["[z_coord]"] -= src
	return ..()

/datum/ore_node/proc/GetScannerDescription()
	return "You can sense ores nearby"

/datum/ore_node/proc/TakeRandomOre()
	if(!length(ores_to_mine))
		return
	var/obj/item/ore_to_return
	var/type = pickweight(ores_to_mine)
	ores_to_mine[type] = ores_to_mine[type] - 1
	if(ores_to_mine[type] == 0)
		ores_to_mine -= type
	ore_to_return = new type()

	if(!length(ores_to_mine))
		qdel(src)
	return ore_to_return

/proc/GetNearbyOreNode(x,y,z)
	if(!GLOB.ore_nodes_by_z_level["[z]"])
		return
	var/list/iterated = GLOB.ore_nodes_by_z_level["[z]"]
	for(var/i in iterated)
		var/datum/ore_node/ON = i
		if(x < (ON.x_coord + ON.range) && x > (ON.x_coord - ON.range) && y < (ON.y_coord + ON.range) && y > (ON.y_coord - ON.range))
			return ON

/obj/effect/ore_node_spawner
	var/list/possible_ore_weight
	var/ore_density = 1
	var/ore_variety = 1

/obj/effect/ore_node_spawner/proc/SeedVariables()
	return

/obj/effect/ore_node_spawner/proc/SeedOres()
	return

/obj/effect/ore_node_spawner/Initialize()
	. = ..()
	SeedVariables()
	SeedOres()
	if(!length(possible_ore_weight))
		qdel(src)
		return

/obj/effect/ore_node_spawner/test

/obj/effect/ore_node_spawner/Initialize()
	var/list/mineral_list = list(/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 10,
		/obj/item/stack/ore/silver = 12, /obj/item/stack/ore/plasma = 20, /obj/item/stack/ore/iron = 40, /obj/item/stack/ore/titanium = 11,
		/obj/item/stack/ore/bluespace_crystal = 1)
	new /datum/ore_node(x, y, z, mineral_list, 5)
	qdel(src)
	. = ..()
