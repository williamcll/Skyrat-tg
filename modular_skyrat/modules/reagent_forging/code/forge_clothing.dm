//armor
/obj/item/clothing/suit/armor/reagent_clothing
	name = "chain armor"
	desc = "A piece of armor made out of chains, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "chain_armor"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	worn_icon_digi = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing_digi.dmi'
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 40, BULLET = 40, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 0, WOUND = 30)

/obj/item/clothing/suit/armor/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 4)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_OCLOTHING)

//gloves
/obj/item/clothing/gloves/reagent_clothing
	name = "chain gloves"
	desc = "A set of gloves made out of chains, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "chain_glove"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 40, BULLET = 40, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 0, WOUND = 30)

/obj/item/clothing/gloves/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 4)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_GLOVES)

/obj/item/clothing/head/helmet/reagent_clothing
	name = "chain helmet"
	desc = "A helmet made out of chains, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "chain_helmet"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 40, BULLET = 40, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 0, WOUND = 30)

/obj/item/clothing/head/helmet/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 4)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_HEAD)

/obj/item/clothing/shoes/chain_boots
	name = "chain boots"
	desc = "A pair of boots made out of chains, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "chain_boot"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	worn_icon_digi = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing_digi.dmi'
	armor = list(MELEE = 20, BULLET = 20, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	resistance_flags = FIRE_PROOF
	can_be_tied = FALSE

/obj/item/clothing/shoes/chain_boots/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 2)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_FEET)

/obj/item/clothing/shoes/plated_boots
	name = "plated boots"
	desc = "A pair of boots made out of plates, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "plate_boot"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	worn_icon_digi = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing_digi.dmi'
	armor = list(MELEE = 20, BULLET = 20, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	resistance_flags = FIRE_PROOF
	can_be_tied = FALSE

/obj/item/clothing/shoes/plated_boots/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 2)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_FEET)

/obj/item/clothing/shoes/horseshoe
	name = "horseshoe"
	desc = "A pair of horseshoes made out of chains, ready to be imbued with a chemical."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_clothing.dmi'
	icon_state = "horseshoe"
	worn_icon = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_clothing.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor = list(MELEE = 20, BULLET = 20, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	resistance_flags = FIRE_PROOF
	can_be_tied = FALSE

/obj/item/clothing/shoes/horseshoe/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate, 2)
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_FEET)

/obj/item/clothing/gloves/ring/reagent_clothing
	name = "reagent ring"
	desc = "A tiny ring, sized to wrap around a finger. It is possible to imbue this ring."
	icon_state = "ringsilver"
	inhand_icon_state = "sring"
	worn_icon_state = "sring"

/obj/item/clothing/gloves/ring/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_GLOVES)

/obj/item/clothing/neck/kink_collar/reagent_clothing
	name = "reagent pet collar"
	desc = "A pet collar that is ready to be imbued."

/obj/item/clothing/neck/kink_collar/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_NECK)

/obj/item/clothing/neck/kink_collar/reagent_clothing/attack_self(mob/user)
	tagname = sanitize_name(stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN))
	name = initial(name)
	for(var/datum/reagent/clothing_reagent in reagents.reagent_list)
		if(clothing_reagent.volume < 200)
			reagents.remove_all_type(clothing_reagent.type)
			continue
		name = "[clothing_reagent.name] [name]"
	name = "[name] [tagname]"

/obj/item/restraints/handcuffs/reagent_clothing
	name = "reagent handcuffs"
	desc = "A pair of handcuffs that are ready to be imbued."

/obj/item/restraints/handcuffs/reagent_clothing/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_clothing, ITEM_SLOT_HANDCUFFED)
