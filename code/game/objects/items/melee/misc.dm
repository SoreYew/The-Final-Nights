// Deprecated, you do not need to use this type for melee weapons.
/obj/item/melee
	item_flags = NEEDS_PERMIT

/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	inhand_icon_state = "chain"
	worn_icon_state = "whip"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 10
	throwforce = 7
	wound_bonus = 15
	bare_wound_bonus = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("flogs", "whips", "lashes", "disciplines")
	attack_verb_simple = list("flog", "whip", "lash", "discipline")
	hitsound = 'sound/weapons/chainhit.ogg'
	custom_materials = list(/datum/material/iron = 1000)

/obj/item/melee/chainofcommand/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/melee/synthetic_arm_blade
	name = "synthetic arm blade"
	desc = "A grotesque blade that on closer inspection seems to be made out of synthetic flesh, it still feels like it would hurt very badly as a weapon."
	icon = 'icons/obj/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED

/obj/item/melee/synthetic_arm_blade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 80) //very imprecise

/obj/item/melee/sabre
	name = "officer's sabre"
	desc = "An elegant weapon, its monomolecular edge is capable of cutting through flesh and bone with ease."
	icon_state = "sabre"
	inhand_icon_state = "sabre"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	obj_flags = UNIQUE_RENAME
	force = 15
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 50
	armour_penetration = 75
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 1000)
	wound_bonus = 10
	bare_wound_bonus = 25

/obj/item/melee/sabre/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 95, 5) //fast and effective, but as a sword, it might damage the results.

/obj/item/melee/sabre/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight
	return ..()

/obj/item/melee/sabre/on_exit_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/sabre/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/sabre/on_enter_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/sabre/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/sabre/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is trying to cut off all [user.p_their()] limbs with [src]! it looks like [user.p_theyre()] trying to commit suicide!</span>")
	var/i = 0
	ADD_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)
	if(iscarbon(user))
		var/mob/living/carbon/Cuser = user
		var/obj/item/bodypart/holding_bodypart = Cuser.get_holding_bodypart_of_item(src)
		var/list/limbs_to_dismember
		var/list/arms = list()
		var/list/legs = list()
		var/obj/item/bodypart/bodypart

		for(bodypart in Cuser.bodyparts)
			if(bodypart == holding_bodypart)
				continue
			if(bodypart.body_part & ARMS)
				arms += bodypart
			else if (bodypart.body_part & LEGS)
				legs += bodypart

		limbs_to_dismember = arms + legs
		if(holding_bodypart)
			limbs_to_dismember += holding_bodypart

		var/speedbase = abs((4 SECONDS) / limbs_to_dismember.len)
		for(bodypart in limbs_to_dismember)
			i++
			addtimer(CALLBACK(src, PROC_REF(suicide_dismember), user, bodypart), speedbase * i)
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), (5 SECONDS) * i)
	return MANUAL_SUICIDE

/obj/item/melee/sabre/proc/suicide_dismember(mob/living/user, obj/item/bodypart/affecting)
	if(!QDELETED(affecting) && affecting.dismemberable && affecting.owner == user && !QDELETED(user))
		playsound(user, hitsound, 25, TRUE)
		affecting.dismember(BRUTE)
		user.adjustBruteLoss(20)

/obj/item/melee/sabre/proc/manual_suicide(mob/living/user, originally_nodropped)
	if(!QDELETED(user))
		user.adjustBruteLoss(200)
		user.death(FALSE)
	REMOVE_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)

/obj/item/melee/beesword
	name = "The Stinger"
	desc = "Taken from a giant bee and folded over one thousand times in pure honey. Can sting through anything."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "beesword"
	inhand_icon_state = "stinger"
	worn_icon_state = "stinger"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	w_class = WEIGHT_CLASS_BULKY
	sharpness = SHARP_EDGED
	throwforce = 10
	attack_speed = CLICK_CD_RAPID
	block_chance = 20
	armour_penetration = 65
	attack_verb_continuous = list("slashes", "stings", "prickles", "pokes")
	attack_verb_simple = list("slash", "sting", "prickle", "poke")
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/melee/beesword/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(iscarbon(target))
		var/mob/living/carbon/H = target
		H.reagents.add_reagent(/datum/reagent/toxin, 4)

/obj/item/melee/beesword/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is stabbing [user.p_them()]self in the throat with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(get_turf(src), hitsound, 75, TRUE, -1)
	return TOXLOSS

/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 12 //9 hit crit
	w_class = WEIGHT_CLASS_NORMAL

	var/cooldown_check = 0 // Used interally, you don't want to modify

	var/cooldown = 40 // Default wait time until can stun again.
	var/knockdown_time_carbon = (1.5 SECONDS) // Knockdown length for carbons.
	var/stun_time_silicon = (5 SECONDS) // If enabled, how long do we stun silicons.
	var/stamina_damage = 55 // Do we deal stamina damage.
	var/affect_silicon = FALSE // Does it stun silicons.
	var/on_sound // "On" sound, played when switching between able to stun or not.
	var/on_stun_sound = 'sound/effects/woodhit.ogg' // Default path to sound for when we stun.
	var/stun_animation = TRUE // Do we animate the "hit" when stunning.
	var/on = TRUE // Are we on or off.

	var/on_icon_state // What is our sprite when turned on
	var/off_icon_state // What is our sprite when turned off
	var/on_inhand_icon_state // What is our in-hand sprite when turned on
	var/force_on // Damage when on - not stunning
	var/force_off // Damage when off - not stunning
	var/weight_class_on // What is the new size class when turned on

	wound_bonus = 15

// Description for trying to stun when still on cooldown.
/obj/item/melee/classic_baton/proc/get_wait_description()
	return

// Description for when turning their baton "on"
/obj/item/melee/classic_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>You extend the baton.</span>"
	.["local_off"] = "<span class ='notice'>You collapse the baton.</span>"

	return .

// Default message for stunning mob.
/obj/item/melee/classic_baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] =  "<span class ='danger'>[user] knocks [target] down with [src]!</span>"
	.["local"] = "<span class ='userdanger'>[user] knocks you down with [src]!</span>"

	return .

// Default message for stunning a silicon.
/obj/item/melee/classic_baton/proc/get_silicon_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = "<span class='danger'>[user] pulses [target]'s sensors with the baton!</span>"
	.["local"] = "<span class='danger'>You pulse [target]'s sensors with the baton!</span>"

	return .

// Are we applying any special effects when we stun to carbon
/obj/item/melee/classic_baton/proc/additional_effects_carbon(mob/living/target, mob/living/user)
	return

// Are we applying any special effects when we stun to silicon
/obj/item/melee/classic_baton/proc/additional_effects_silicon(mob/living/target, mob/living/user)
	return

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user, params)
	if(!on)
		return ..()

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='userdanger'>You hit yourself over the head!</span>")

		user.Paralyze(knockdown_time_carbon * force)
		user.apply_damage(stamina_damage, STAMINA, BODY_ZONE_HEAD)

		additional_effects_carbon(user) // user is the target here
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		// We don't stun if we're on harm.
		if (!user.combat_mode)
			if (affect_silicon)
				var/list/desc = get_silicon_stun_description(target, user)

				target.flash_act(affect_silicon = TRUE)
				target.Paralyze(stun_time_silicon)
				additional_effects_silicon(target, user)

				user.visible_message(desc["visible"], desc["local"])
				playsound(get_turf(src), on_stun_sound, 100, TRUE, -1)

				if (stun_animation)
					user.do_attack_animation(target)
			else
				..()
		else
			..()
		return
	if(!isliving(target))
		return
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		..()
		return
	if(cooldown_check > world.time)
		var/wait_desc = get_wait_description()
		if (wait_desc)
			to_chat(user, wait_desc)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (H.check_block(src, 0, "[user]'s [name]", MELEE_ATTACK))
			return

	var/list/desc = get_stun_description(target, user)

	if (stun_animation)
		user.do_attack_animation(target)

	playsound(get_turf(src), on_stun_sound, 75, TRUE, -1)
	target.Knockdown(knockdown_time_carbon)
	target.apply_damage(stamina_damage, STAMINA, BODY_ZONE_CHEST)
	additional_effects_carbon(target, user)

	log_combat(user, target, "stunned", src)
	add_fingerprint(user)

	target.visible_message(desc["visible"], desc["local"])

	if(!iscarbon(user))
		target.LAssailant = null
	else
		target.LAssailant = user
	cooldown_check = world.time + cooldown
	return


/obj/item/conversion_kit
	name = "conversion kit"
	desc = "A strange box containing wood working tools and an instruction paper to turn stun batons into something else."
	icon = 'icons/obj/storage.dmi'
	icon_state = "uk"
	custom_price = PAYCHECK_HARD * 4.5

/obj/item/melee/classic_baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	inhand_icon_state = null
	worn_icon_state = "tele_baton"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	on = FALSE
	on_sound = 'sound/weapons/batonextend.ogg'

	on_icon_state = "telebaton_1"
	off_icon_state = "telebaton_0"
	on_inhand_icon_state = "nullrod"
	force_on = 10
	force_off = 0
	weight_class_on = WEIGHT_CLASS_BULKY
	bare_wound_bonus = 5

/obj/item/melee/classic_baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)

	user.visible_message("<span class='suicide'>[user] stuffs [src] up [user.p_their()] nose and presses the 'extend' button! It looks like [user.p_theyre()] trying to clear [user.p_their()] mind.</span>")
	if(!on)
		src.attack_self(user)
	else
		playsound(src, on_sound, 50, TRUE)
		add_fingerprint(user)
	sleep(3)
	if (!QDELETED(H))
		if(!QDELETED(B))
			H.internal_organs -= B
			qdel(B)
		new /obj/effect/gibspawner/generic(H.drop_location(), H)
		return (BRUTELOSS)

/obj/item/melee/classic_baton/telescopic/attack_self(mob/user)
	on = !on
	var/list/desc = get_on_description()

	if(on)
		to_chat(user, desc["local_on"])
		icon_state = on_icon_state
		inhand_icon_state = on_inhand_icon_state
		w_class = weight_class_on
		force = force_on
		attack_verb_continuous = list("smacks", "strikes", "cracks", "beats")
		attack_verb_simple = list("smack", "strike", "crack", "beat")
	else
		to_chat(user, desc["local_off"])
		icon_state = off_icon_state
		inhand_icon_state = null //no sprite for concealment even when in hand
		slot_flags = ITEM_SLOT_BELT
		w_class = WEIGHT_CLASS_SMALL
		force = force_off
		attack_verb_continuous = list("hits", "pokes")
		attack_verb_simple = list("hit", "poke")

	playsound(src.loc, on_sound, 50, TRUE)
	add_fingerprint(user)

/obj/item/melee/classic_baton/telescopic/contractor_baton
	name = "contractor baton"
	desc = "A compact, specialised baton assigned to Syndicate contractors. Applies light electrical shocks to targets."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "contractor_baton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	inhand_icon_state = null
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 5

	cooldown = 25
	stamina_damage = 85
	affect_silicon = TRUE
	on_sound = 'sound/weapons/contractorbatonextend.ogg'
	on_stun_sound = 'sound/effects/contractorbatonhit.ogg'

	on_icon_state = "contractor_baton_1"
	off_icon_state = "contractor_baton_0"
	on_inhand_icon_state = "contractor_baton"
	force_on = 16
	force_off = 5
	weight_class_on = WEIGHT_CLASS_NORMAL

/obj/item/melee/classic_baton/telescopic/contractor_baton/get_wait_description()
	return "<span class='danger'>The baton is still charging!</span>"

/obj/item/melee/classic_baton/telescopic/contractor_baton/additional_effects_carbon(mob/living/target, mob/living/user)
	target.Jitter(20)
	target.stuttering += 20

/obj/item/melee/curator_whip
	name = "curator's whip"
	desc = "Somewhat eccentric and outdated, it still stings like hell to be hit by."
	icon_state = "whip"
	inhand_icon_state = "chain"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	worn_icon_state = "whip"
	slot_flags = ITEM_SLOT_BELT
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("flogs", "whips", "lashes", "disciplines")
	attack_verb_simple = list("flog", "whip", "lash", "discipline")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/melee/curator_whip/afterattack(target, mob/user, proximity_flag)
	. = ..()
	if(ishuman(target) && proximity_flag)
		var/mob/living/carbon/human/H = target
		H.drop_all_held_items()
		H.visible_message("<span class='danger'>[user] disarms [H]!</span>", "<span class='userdanger'>[user] disarmed you!</span>")

/obj/item/melee/roastingstick
	name = "advanced roasting stick"
	desc = "A telescopic roasting stick with a miniature shield generator designed to ensure entry into various high-tech shielded cooking ovens and firepits."
	icon_state = "roastingstick_0"
	inhand_icon_state = "null"
	worn_icon_state = "tele_baton"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	attack_verb_continuous = list("hits", "pokes")
	attack_verb_simple = list("hit", "poke")
	var/obj/item/food/sausage/held_sausage
	var/static/list/ovens
	var/on = FALSE
	var/datum/beam/beam

/obj/item/melee/roastingstick/Initialize()
	. = ..()
	if (!ovens)
		ovens = typecacheof(list(/obj/structure/bonfire))

/obj/item/melee/roastingstick/attack_self(mob/user)
	on = !on
	if(on)
		extend(user)
	else
		if (held_sausage)
			to_chat(user, "<span class='warning'>You can't retract [src] while [held_sausage] is attached!</span>")
			return
		retract(user)

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, TRUE)
	add_fingerprint(user)

/obj/item/melee/roastingstick/attackby(atom/target, mob/user)
	..()
	if (istype(target, /obj/item/food/sausage))
		if (!on)
			to_chat(user, "<span class='warning'>You must extend [src] to attach anything to it!</span>")
			return
		if (held_sausage)
			to_chat(user, "<span class='warning'>[held_sausage] is already attached to [src]!</span>")
			return
		if (user.transferItemToLoc(target, src))
			held_sausage = target
		else
			to_chat(user, "<span class='warning'>[target] doesn't seem to want to get on [src]!</span>")
	update_appearance()

/obj/item/melee/roastingstick/attack_hand(mob/user, list/modifiers)
	..()
	if (held_sausage)
		user.put_in_hands(held_sausage)
		held_sausage = null
	update_appearance()

/obj/item/melee/roastingstick/update_overlays()
	. = ..()
	if(held_sausage)
		. += mutable_appearance(icon, "roastingstick_sausage")

/obj/item/melee/roastingstick/proc/extend(user)
	to_chat(user, "<span class='warning'>You extend [src].</span>")
	icon_state = "roastingstick_1"
	inhand_icon_state = "nullrod"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/melee/roastingstick/proc/retract(user)
	to_chat(user, "<span class='notice'>You collapse [src].</span>")
	icon_state = "roastingstick_0"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL

/obj/item/melee/roastingstick/handle_atom_del(atom/target)
	if (target == held_sausage)
		held_sausage = null
		update_appearance()

/obj/item/melee/roastingstick/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if (!on)
		return
	if (is_type_in_typecache(target, ovens))
		if (held_sausage?.roasted)
			to_chat("<span class='warning'>Your [held_sausage] has already been cooked!</span>")
			return
		else if (user.Adjacent(target))
			to_chat(user, "<span class='notice'>You extend [src] towards [target].</span>")
			playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, TRUE)
		else
			return
		if(do_after(user, 100, target = user))
			finish_roasting(user, target)
		else
			QDEL_NULL(beam)
			playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)

/obj/item/melee/roastingstick/proc/finish_roasting(user, atom/target)
	to_chat(user, "<span class='notice'>You finish roasting [held_sausage].</span>")
	playsound(src,'sound/items/welder2.ogg',50,TRUE)
	held_sausage.add_atom_colour(rgb(103,63,24), FIXED_COLOUR_PRIORITY)
	held_sausage.name = "[target.name]-roasted [held_sausage.name]"
	held_sausage.desc = "[held_sausage.desc] It has been cooked to perfection on \a [target]."
	update_appearance()

/obj/item/melee/cleric_mace
	name = "cleric mace"
	desc = "The grandson of the club, yet the grandfather of the baseball bat. Most notably used by holy orders in days past."
	icon = 'icons/obj/items/cleric_mace.dmi'
	icon_state = "default"
	inhand_icon_state = "default"
	worn_icon_state = "default_worn"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_GREYSCALE | MATERIAL_AFFECT_STATISTICS //Material type changes the prefix as well as the color.
	custom_materials = list(/datum/material/iron = 12000)  //Defaults to an Iron Mace.
	slot_flags = ITEM_SLOT_BELT
	force = 14
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 8
	block_chance = 10
	armour_penetration = 50
	attack_verb_continuous = list("smacks", "strikes", "cracks", "beats")
	attack_verb_simple = list("smack", "strike", "crack", "beat")
