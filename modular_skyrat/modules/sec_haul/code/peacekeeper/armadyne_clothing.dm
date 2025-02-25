/obj/item/clothing/under/rank/security/peacekeeper/armadyne
	name = "armadyne corporate uniform"
	desc = "A robust uniform worn by Armadyne corporate."
	icon_state = "armadyne_shirt"
	worn_icon_state = "armadyne_shirt"

/obj/item/clothing/under/rank/security/peacekeeper/armadyne/tactical
	name = "armadyne tactical uniform"
	desc = "A robust tactical uniform worn by Armadyne corporate."
	icon_state = "armadyne_tac"
	worn_icon_state = "armadyne_tac"

/obj/item/clothing/head/beret/sec/peacekeeper/armadyne
	name = "armadyne corporate beret"
	desc = "A comfy yet robust beret worn by Armadyne corporate."
	greyscale_config = /datum/greyscale_config/beret_badge_fancy
	greyscale_config_worn = /datum/greyscale_config/beret_badge_fancy/worn
	greyscale_colors = "#3F3C40#5B2423#491716"
	icon_state = "beret_badge_fancy_diagonal"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/hos/trenchcoat/peacekeeper/armadyne
	name = "armored armadyne trenchcoat"
	desc = "An Armadyne branded trenchcoat, feels heavy, premium, and pristegious. Worn by Armadyne corporate."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "armadyne_trench"

/obj/item/clothing/suit/armor/vest/peacekeeper/armadyne
	name = "armadyne armor jacket"
	desc = "An Armadyne branded suit vest, feels heavy, premium, and pristegious. Worn by Armadyne corporate."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "armadyne_jacket"
	worn_icon_state = "armadyne_jacket"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/vest/peacekeeper/armadyne/armor
	name = "armadyne armor vest"
	desc = "An Armadyne branded vest, feels heavy, premium, and pristegious. Worn by Armadyne corporate."
	icon_state = "armadyne_armor"
	worn_icon_state = "armadyne_armor"

/obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper/armadyne
	name = "armadyne hud glasses"
	icon_state = "armadyne_glasses"
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/eyes.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/glasses.dmi'

/obj/item/clothing/gloves/combat/peacekeeper/armadyne
	name = "armadyne combat gloves"
	desc = "Tactical and sleek. Worn by Armadyne representatives."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "armadyne_gloves"
	worn_icon_state = "armadyne_gloves"
	cut_type = null

/obj/item/clothing/shoes/combat/peacekeeper/armadyne
	name = "armadyne combat boots"
	desc = "Tactical and sleek. Worn by Armadyne representatives."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/feet.dmi'
	icon_state = "armadyne_boots"
	inhand_icon_state = "jackboots"
	worn_icon_state = "armadyne_boots"


/obj/item/storage/belt/security/webbing/peacekeeper/armadyne
	name = "armadyne webbing"
	desc = "Unique and versatile chest rig, can hold security gear."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "armadyne_webbing"
	worn_icon_state = "armadyne_webbing"

/obj/item/storage/belt/security/peacekeeper/armadyne
	name = "armadyne belt"
	desc = "Can hold security gear like handcuffs and flashes. Has a holster for a gun."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "armadyne_belt"
	worn_icon_state = "armadyne_belt"

/datum/outfit/armadyne_rep
	name = "Armadyne Corporate Representative"

	suit_store = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_cent/commander
	uniform = /obj/item/clothing/under/rank/security/peacekeeper/armadyne
	gloves = /obj/item/clothing/gloves/combat/peacekeeper/armadyne
	head =  /obj/item/clothing/head/beret/sec/peacekeeper/armadyne
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper/armadyne
	suit = /obj/item/clothing/suit/armor/vest/peacekeeper/armadyne
	shoes = /obj/item/clothing/shoes/combat/peacekeeper/armadyne
	belt = /obj/item/storage/belt/security/peacekeeper/armadyne
	r_pocket = /obj/item/assembly/flash/handheld
	backpack_contents = list(/obj/item/melee/baton/telescopic, /obj/item/storage/box/gunset/pdh_corpo)
	back = /obj/item/storage/backpack/satchel/leather
	box = /obj/item/storage/box/survival/security
	l_pocket = /obj/item/megaphone/command
	implants = list(/obj/item/implant/mindshield)
	id = /obj/item/card/id/advanced/armadyne/agent


/datum/outfit/armadyne_security
	name = "Armadyne Corporate Security"

	suit_store = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/peacekeeper/armadyne/tactical
	gloves = /obj/item/clothing/gloves/combat/peacekeeper/armadyne
	head =  /obj/item/clothing/head/beret/sec/peacekeeper/armadyne
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper/armadyne
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit = /obj/item/clothing/suit/armor/vest/peacekeeper/armadyne/armor
	suit_store = /obj/item/gun/ballistic/automatic/dmr
	shoes = /obj/item/clothing/shoes/combat/peacekeeper/armadyne
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne
	backpack_contents = list(/obj/item/melee/baton/security/loaded , /obj/item/storage/box/gunset/pdh_corpo, /obj/item/storage/box/handcuffs, /obj/item/ammo_box/magazine/dmr=2)
	back = /obj/item/storage/backpack/security
	box = /obj/item/storage/box/survival/security
	l_pocket = /obj/item/megaphone/command
	implants = list(/obj/item/implant/mindshield)
	id = /obj/item/card/id/advanced/armadyne/security

/obj/item/card/id/advanced/armadyne
	name = "\improper Armadyne ID"
	desc = "An Armadyne ID card."
	icon_state = "card_centcom"
	worn_icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	registered_age = null
	trim = /datum/id_trim/centcom/armadyne
	wildcard_slots = WILDCARD_LIMIT_CENTCOM

/datum/id_trim/centcom/armadyne
	assignment = "Armadyne Corporate"
	trim_state = "trim_ert_commander"

/datum/id_trim/centcom/armadyne/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/obj/item/card/id/advanced/armadyne/security
	registered_name = "Armadyne Corpo"
	trim = /datum/id_trim/centcom/armadyne/security

/datum/id_trim/centcom/armadyne/security
	assignment = "Armadyne Corporate Security Detail"
	trim_state = "trim_ert_commander"

/obj/item/card/id/advanced/armadyne/agent
	trim = /datum/id_trim/centcom/armadyne/agent

/datum/id_trim/centcom/armadyne/agent
	assignment = "Armadyne Corporate Directorate"
	trim_state = "trim_ert_commander"

/datum/outfit/armadyne_rep/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.name = "Armadyne Headset"

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
	..()

/obj/item/card/id/armadyne/corpo/security
	assignment = "Armadyne Corporate Security"

/datum/antagonist/ert/armadyne
    name = "Armadyne Corporate Security"
    outfit = /datum/outfit/armadyne_security
    role = "Security"

/datum/antagonist/ert/armadyne/leader
    name = "Armadyne Corporate Agent"
    outfit = /datum/outfit/armadyne_rep
    role = "Agent"

/datum/ert/armadyne
    roles = list(/datum/antagonist/ert/armadyne)
    leader_role = /datum/antagonist/ert/armadyne/leader
    rename_team = "Armadyne PMC"
    mission = "Assist any Armadyne corporate entities."
    polldesc = "an Armadyne PMC."
