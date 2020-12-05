/client/proc/cmd_admin_spawn_planet()
	set category = "Admin.Events"
	set name = "Spawn Planet"
	var/input = alert("You sure you want to spawn a new planetary z level?", "Planet Debug", "Yes", "No")
	if(!input || input == "No")
		return
	generate_new_planet()

/proc/generate_new_planet()
	var/datum/planet_dictionary/PD = new /datum/planet_dictionary/xenoarch_jungle()
	SSmapping.LoadGroup(null, "Planet", "map_files/planets", "_planet.dmm", default_traits = PD.default_traits)
	var/new_z = world.maxz //Okay so, I cant get the z level number from the parsed map, so I do this
	PD.MarkZLevel(new_z)
	message_admins("generated planet at [new_z] z level")
	var/area/new_area = new /area/planet()
	PD.my_area = new_area
	var/list/turfs = block(locate(1,1,new_z),locate(255,255,new_z))
	new_area.contents.Add(turfs)

	var/datum/map_generator/my_gator = new /datum/map_generator/jungle_generator()
	my_gator.generate_terrain(turfs)
	seedRuins(list(new_z), CONFIG_GET(number/lavaland_budget), list(/area/planet), SSmapping.lava_ruins_templates)
	
	for(var/i in 1 to PD.possible_ore_nodes)
		var/turf/rand_turf = pick(turfs)
		new /obj/effect/ore_node_spawner/planetary(rand_turf)
