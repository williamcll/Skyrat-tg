/obj/machinery/shuttle_module_compartment
	name = "shuttle module compartment"
	icon_state = "autolathe"
	density = TRUE
	use_power = IDLE_POWER_USE
	circuit = /obj/item/circuitboard/machine/shuttle_module_compartment
	var/obj/docking_port/mobile/my_shuttle
	var/list/installed_modules = list()

/obj/machinery/shuttle_module_compartment/Initialize()
	. = ..()
	TryLinkToShuttle()

/obj/machinery/shuttle_module_compartment/ui_interact(mob/user)
	. = ..()
	if(!my_shuttle)
		TryLinkToShuttle()
	var/list/dat = list()
	for(var/m in installed_modules)
		message_admins("[m]")

	var/datum/browser/popup = new(user, "shuttle_module_compartment", name, 900, 600)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/shuttle_module_compartment/proc/TryLinkToShuttle()
	my_shuttle = SSshuttle.get_containing_shuttle(src)
	if(my_shuttle)
		my_shuttle.compartment = src

/obj/machinery/shuttle_module_compartment/Destroy()
	if(my_shuttle)
		my_shuttle.compartment = null
		my_shuttle = null
	return ..()

/obj/item/circuitboard/machine/shuttle_module_compartment
	name = "Shuttle Module Compartment (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/shuttle_module_compartment
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
