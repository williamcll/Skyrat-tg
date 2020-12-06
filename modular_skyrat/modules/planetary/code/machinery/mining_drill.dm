#define DRILL_MINING_SPEED 40
#define DRILL_ACTIVE_POWER_USAGE 300

/obj/machinery/power/mining_drill
	name = "mining drill"
	desc = "A colossal machine for drilling deep into ground for ores. Make sure there's actually ore underneath, unless you want to mine dust. Can be connected to an external source through a terminal."
	icon = 'modular_skyrat/modules/planetary/icons/machinery/mining_drill.dmi'
	icon_state = "mining_drill"
	use_power = NO_POWER_USE
	layer = ABOVE_MOB_LAYER
	idle_power_usage = 0
	active_power_usage = DRILL_ACTIVE_POWER_USAGE
	req_access = null
	max_integrity = 200
	integrity_failure = 0.25
	damage_deflection = 10
	resistance_flags = FIRE_PROOF
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON

	circuit = /obj/item/circuitboard/machine/mining_drill

	anchored = FALSE
	density = TRUE

	var/can_have_external_power = TRUE

	var/active = FALSE
	var/powered = FALSE

	var/obj/item/stock_parts/cell/cell
	var/starting_cell
	var/obj/machinery/power/terminal/terminal

	var/datum/ore_node/current_node

	var/mining_speed = DRILL_MINING_SPEED
	var/ore_output_direction = SOUTH
	//For the purposes of performance, we're spewing ores in batches, just in case someone wanted to go too hard with conveyor belts
	var/list/stored_ores = list()
	var/dump_ticker = 0 //Used as a timer for dumping the ore
	var/mining_progress_ticker = 0 //Used as a timer for mining the ore

/obj/machinery/power/mining_drill/proc/RegisterNode(datum/ore_node/node)
	if(!node)
		return
	current_node = node
	RegisterSignal(current_node, COMSIG_PARENT_QDELETING, .proc/UnregisterNode)

/obj/machinery/power/mining_drill/proc/UnregisterNode()
	UnregisterSignal(current_node, COMSIG_PARENT_QDELETING, .proc/UnregisterNode)
	current_node = null

/obj/machinery/power/mining_drill/update_icon_state()
	if(!anchored)
		icon_state = "[initial(icon_state)]_not_anchor"
	else if(panel_open)
		icon_state = "[initial(icon_state)]_open"
	else if(active && powered)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/obj/machinery/power/mining_drill/attack_hand(mob/living/carbon/human/user)
	add_fingerprint(user)
	if(panel_open && cell)
		cell.update_icon()
		cell.add_fingerprint(user)
		user.put_in_active_hand(cell)
		to_chat(user, "<span class='notice'>You remove \the [cell].</span>")
		cell = null
		return
	else
		playsound(src, 'sound/machines/microwave/microwave-start.ogg', 50, TRUE) //Couldnt find a better one
		if(active)
			to_chat(user, "<span class='notice'>You turn off [src].</span>")
			turn_off()
		else
			to_chat(user, "<span class='notice'>You turn on [src].</span>")
			turn_on()
	return ..()

/obj/machinery/power/mining_drill/attackby(obj/item/W, mob/user, params)
	if(panel_open && can_have_external_power && !terminal && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/S = W
		if(S.use(5))
			var/tdir = get_dir(user, src)
			terminal = new/obj/machinery/power/terminal(get_turf(user))
			terminal.setDir(tdir)
			terminal.master = src
			to_chat(user, "<span class='notice'>You connect a terminal to [src].</span>")
		else
			to_chat(user, "<span class='warning'>You need 5 cables to wire a terminal for [src].</span>")
		return
	if(panel_open && !cell && istype(W, /obj/item/stock_parts/cell))
		cell = W
		cell.forceMove(src)
		to_chat(user, "<span class='notice'>You insert the cell inside [src].</span>")
		return
	return ..()

/obj/machinery/power/mining_drill/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	default_deconstruction_screwdriver(user, "[initial(icon_state)]_open", "[initial(icon_state)]_drill", I)
	return TRUE

/obj/machinery/power/mining_drill/can_be_unfasten_wrench(mob/user, silent)
	if(terminal)
		if(!silent)
			to_chat(user, "<span class='warning'>Cut the terminal first!</span>")
		return FAILED_UNFASTEN
	if(active)
		if(!silent)
			to_chat(user, "<span class='warning'>[src] is turned on!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/mining_drill/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	update_icon()
	return TRUE

/obj/machinery/power/mining_drill/Initialize()
	. = ..()
	if(starting_cell)
		cell = new starting_cell
	update_icon() //Needs to know if to use anchored/unanchored sprite

/obj/machinery/power/mining_drill/proc/pass_power_check()
	if(terminal && terminal.avail() > active_power_usage)
		add_load(active_power_usage)
		return TRUE
	if(cell && cell.charge > active_power_usage)
		cell.charge -= active_power_usage
		return TRUE
	return FALSE

/obj/machinery/power/mining_drill/process()
	if(machine_stat & (BROKEN))
		return
	if(!active)
		return
	//Try power
	if(!active_power_usage || pass_power_check())
		if(!powered)
			powered = TRUE
			playsound(src, 'sound/machines/piston_lower.ogg', 30, TRUE)
			update_icon()
	else
		if(powered)
			powered = FALSE
			playsound(src, 'sound/machines/piston_raise.ogg', 30, TRUE)
			dump_ore()
			update_icon()
		return
	//Mine!
	mining_progress_ticker += mining_speed
	if(mining_progress_ticker > 100)
		mining_progress_ticker -= 100
		//Try find node if not connected
		if(!current_node)
			RegisterNode(GetNearbyOreNode(get_turf(src)))
		//Mine ore
		if(current_node)
			var/obj/item/mined = current_node.TakeRandomOre()
			if(mined)
				stored_ores += mined
		//Dump if got enough
		dump_ticker++
		if(dump_ticker > 5)
			dump_ore()

/obj/machinery/power/mining_drill/Destroy()
	dump_ore()
	if(terminal)
		disconnect_terminal()
	if(cell)
		qdel(cell)
	current_node = null
	return ..()

/obj/machinery/power/mining_drill/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/mining_drill/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(terminal && panel_open)
		terminal.dismantle(user, W)
		return TRUE

/obj/machinery/power/mining_drill/proc/turn_on()
	active = TRUE
	if(powered)
		update_icon()

/obj/machinery/power/mining_drill/proc/turn_off()
	active = FALSE
	dump_ore()
	update_icon()

/obj/machinery/power/mining_drill/proc/dump_ore()
	dump_ticker = 0
	var/any_dumps = FALSE
	for(var/i in stored_ores)
		var/obj/item/ITEM = i
		var/turf/T = get_turf(src)
		var/turf/step_turf = get_step(T, ore_output_direction)
		ITEM.forceMove(T)
		if(step_turf)
			ITEM.forceMove(step_turf)
		any_dumps = TRUE
	if(any_dumps)
		playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
	stored_ores.Cut()

/obj/machinery/power/mining_drill/ComponentInitialize()
	. = ..()
	//Very mechanical, so EMP proof
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/power/mining_drill/get_cell()
	return cell

/obj/machinery/power/mining_drill/connect_to_network()
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/mining_drill/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/mining_drill/add_load(amount)
	if(terminal?.powernet)
		terminal.add_load(amount)

/obj/machinery/power/mining_drill/avail(amount)
	if(terminal)
		return terminal.avail(amount)
	else
		return 0

/obj/machinery/power/mining_drill/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/mining_drill/RefreshParts()
	var/new_mining_speed = DRILL_MINING_SPEED
	var/new_power_usage = DRILL_ACTIVE_POWER_USAGE
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		new_mining_speed += 5 * L.rating
		new_power_usage += 10 * L.rating
	mining_speed = new_mining_speed
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		new_power_usage -= 10 * M.rating
	active_power_usage = new_power_usage

/obj/machinery/power/mining_drill/cell
	starting_cell = /obj/item/stock_parts/cell/high

/obj/machinery/power/mining_drill/old
	name = "old mining drill"
	desc = "An old mining drill, with a deep well that you can't see the end of."
	icon_state = "mining_drill_old"
	anchored = TRUE
	can_be_unanchored = FALSE
	starting_cell = /obj/item/stock_parts/cell/high/empty

/obj/item/circuitboard/machine/mining_drill
	name = "Mining Drill (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/mining_drill
	req_components = list(
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/manipulator = 3)
	needs_anchored = FALSE

#undef DRILL_MINING_DELAY
#undef DRILL_ACTIVE_POWER_USAGE
