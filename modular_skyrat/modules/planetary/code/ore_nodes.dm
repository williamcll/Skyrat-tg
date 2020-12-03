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
	GLOB.ore_nodes_by_z_level["[z]"] -= src
	return ..()

/datum/ore_node/proc/GetScannerDescription()
	return "You can sense ores nearby"

/datum/ore_node/proc/TakeRandomOre()
	if(!length(ores_to_mine))
		return

	if(!length(ores_to_mine))
		qdel(src)

/proc/GetNearbyOreNode(x,y,z)
	if(!GLOB.ore_nodes_by_z_level["[z]"])
		return
	var/list/iterated = GLOB.ore_nodes_by_z_level["[z]"]
	for(var/i in iterated)
		var/datum/ore_node/ON = i
		if(x < (ON.x + ON.range) && x > (ON.x - ON.range) && y < (ON.y + ON.range) && y > (ON.y - ON.range))
			return ON

/obj/effect/ore_node
	var/list/possible_ore_weight
	var/density = 10
	var/variety = 10

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

