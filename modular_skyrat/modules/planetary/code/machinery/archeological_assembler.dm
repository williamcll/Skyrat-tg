GLOBAL_LIST_EMPTY(discovered_fossils)

/obj/machinery/rnd/archeological_assembler
	name = "archeological assembler"
	desc = "A fossil analysis machine that can scan matching fossils in order to try and discover an extint specimen. It has a built-in database."
	icon = 'modular_skyrat/modules/planetary/icons/machinery/archeology.dmi'
	icon_state = "arche"
	circuit = /obj/item/circuitboard/machine/archeological_assembler
	console_link = FALSE
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	var/scan_progress = 0
	var/list/loaded_fossils = list()
	var/db_view = FALSE
	var/db_index = 0

/obj/machinery/rnd/archeological_assembler/process()
	if (machine_stat & (NOPOWER | BROKEN))
		return
	if(!busy || !length(loaded_fossils) >= 3)
		return

	scan_progress++
	if(scan_progress<10)
		return

	scan_progress = 0
	busy = FALSE
	var/success = TRUE
	var/obj/item/fossil/first = loaded_fossils[1]
	for(var/i in 2 to 3)
		var/obj/item/fossil/other = loaded_fossils[i]
		if(first.fossil_ref != other.fossil_ref)
			success = FALSE
			break

	if(success)
		playsound(src, 'sound/machines/ping.ogg', 50, 1, -1)
		var/string = "Successfuly recognized a species!"
		var/datum/fossil/new_ref = first.fossil_ref
		if(!GLOB.discovered_fossils[new_ref])
			GLOB.discovered_fossils[new_ref] = TRUE
			string += " Unknown specimen added to the database! Awarded [new_ref.research_points] research points."
			//Handle all sorts of other rewards here too
			stored_research.add_point_list(new_ref.research_points)
		var/find_index = 0
		for(var/spec in GLOB.discovered_fossils)
			find_index++
			if(spec == new_ref)
				break
		db_view = TRUE
		db_index = find_index
		src.say(string)
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
		src.say("Failed to recognize any species!")

	set_light(0)
	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/machinery/rnd/archeological_assembler/on_deconstruction()
	for(var/i in loaded_fossils)
		var/obj/item/fossil/FS = i
		FS.forceMove(loc)
	loaded_fossils.Cut()
	..()

/obj/machinery/rnd/archeological_assembler/update_icon()
	overlays.Cut()
	if (machine_stat & (NOPOWER | BROKEN))
		return
	if (busy)
		overlays += "arche_active"
	overlays += "arche_on"

	switch(length(loaded_fossils))
		if(1)
			overlays += "arche_1"
		if(2)
			overlays += "arche_2"
		if(3)
			overlays += "arche_3"

/obj/machinery/rnd/archeological_assembler/Insert_Item(obj/item/I, mob/user)
	if(user.a_intent != INTENT_HARM)
		if(!istype(I,/obj/item/fossil))
			return TRUE
		if(!is_insertion_ready(user))
			return TRUE
		if(!user.transferItemToLoc(I, src))
			return TRUE
		loaded_fossils += I
		if(length(loaded_fossils) >= 3)
			loaded_item = I
		to_chat(user, "<span class='notice'>You load [I] into [src].</span>")
		update_icon()
		return TRUE


/obj/machinery/rnd/archeological_assembler/ui_interact(mob/user)
	var/list/dat = list("<center>")
	if(!busy)
		if(db_view)
			if(db_index)
				var/datum/fossil/F
				var/index = 0
				for(var/type in GLOB.discovered_fossils)
					index++
					if(index == db_index)
						F = type
						break
				dat += "<a href='?src=[REF(src)];pref=db_index_return'>Return</a>"
				dat += "<BR>Name: <b>[F.name]</b>"
				dat += "<BR>Description <i>[F.desc]</i>"
				dat += "<BR>Research points: [F.research_points]"
			else
				dat += "<a href='?src=[REF(src)];pref=db_return'>Return</a>"
				dat += "<BR><b>Database:</b>"
				var/index = 0
				for(var/type in GLOB.discovered_fossils)
					index++ 
					var/datum/fossil/F = type
					dat += "<BR>[F.name] <a href='?src=[REF(src)];pref=db_view;slot=[index]'>View</a>"

		else
			dat += "<b>Loaded Fossils:</b>"
			var/index = 0
			for(var/i in loaded_fossils)
				index++
				var/obj/item/fossil/FS = i
				dat += "<BR><b>[FS.name]</b> <a href='?src=[REF(src)];pref=eject;slot=[index]'>Eject</a>"
				for(var/hint in FS.hints)
					dat += "<BR><i>[hint]</i>"
			if(length(loaded_fossils) >= 3)
				dat += "<BR><a href='?src=[REF(src)];pref=scan'>Perform Fossil Scan</a>"
			else
				dat += "<BR><a class='linkOff'>Perform Fossil Scan</a>"
			dat += "<BR><a href='?src=[REF(src)];pref=browse'>Browse Database</a>"
			dat += "<BR><a href='?src=[REF(src)];pref=refresh'>Refresh</a>"
	else
		dat += "<b>Scan in progress...</b>"
		dat += "<BR><a href='?src=[REF(src)];pref=refresh'>Refresh</a>"

	var/datum/browser/popup = new(user, "arche_ass","Archeological Assembler", 400, 400, src)
	popup.set_content(dat.Join(""))
	popup.open()
	onclose(user, "arche_ass")


/obj/machinery/rnd/archeological_assembler/Topic(href, href_list)
	if(..())
		return
	if(href_list["pref"])
		switch(href_list["pref"])
			if("db_index_return")
				db_index = 0

			if("db_return")
				db_view = FALSE

			if("browse")
				db_view = TRUE

			if("db_view")
				var/numb = text2num(href_list["slot"])
				db_index = numb

			if("scan")
				DoScan()

			if("eject")
				var/numb = text2num(href_list["slot"])
				if(!busy && length(loaded_fossils) >= numb)
					var/obj/item/fossil/target = loaded_fossils[numb]
					loaded_fossils -= target
					loaded_item = null
					target.forceMove(loc)
					update_icon()

		updateUsrDialog()

/obj/machinery/rnd/archeological_assembler/proc/DoScan(type)
	if(busy || !length(loaded_fossils) >= 3)
		return
	busy = TRUE
	set_light(2)
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/circuitboard/machine/archeological_assembler
	name = "Archeological Assembler (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/rnd/archeological_assembler
	req_components = list(
		/obj/item/stock_parts/scanning_module = 3)
