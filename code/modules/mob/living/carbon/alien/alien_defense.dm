
/mob/living/carbon/alien/get_eye_protection()
	return ..() + 2 //potential cyber implants + natural eye protection

/mob/living/carbon/alien/get_ear_protection()
	return 2 //no ears

/mob/living/carbon/alien/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..(AM, skipcatch = TRUE, hitpush = FALSE)


/*Code for aliens attacking aliens. Because aliens act on a hivemind, I don't see them as very aggressive with each other.
As such, they can either help or harm other aliens. Help works like the human help command while harm is a simple nibble.
In all, this is a lot like the monkey code. /N
*/
/mob/living/carbon/alien/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	if(isturf(loc) && istype(loc.loc, /area/start))
		to_chat(user, "No attacking people at spawn, you jackass.")
		return

	if(user.combat_mode)
		if(user == src && check_self_for_injuries())
			return
		set_resting(FALSE)
		AdjustStun(-60)
		AdjustKnockdown(-60)
		AdjustImmobilized(-60)
		AdjustParalyzed(-60)
		AdjustUnconscious(-60)
		AdjustSleeping(-100)
		visible_message("<span class='notice'>[user.name] nuzzles [src] trying to wake [p_them()] up!</span>")
	else if(health > 0)
		user.do_attack_animation(src, ATTACK_EFFECT_BITE)
		playsound(loc, 'sound/weapons/bite.ogg', 50, TRUE, -1)
		visible_message("<span class='danger'>[user.name] bites [src]!</span>", \
						"<span class='userdanger'>[user.name] bites you!</span>", "<span class='hear'>You hear a chomp!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>You bite [src]!</span>")
		adjustBruteLoss(1)
		log_combat(user, src, "attacked")
		updatehealth()
	else
		to_chat(user, "<span class='warning'>[name] is too injured for that.</span>")



/mob/living/carbon/alien/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	return attack_alien(L)


/mob/living/carbon/alien/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)	//to allow surgery to return properly.
		return FALSE

	if(user.combat_mode)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			user.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			return TRUE
		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		return TRUE
	else
		help_shake_act(user)


/mob/living/carbon/alien/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(..())
		if (stat != DEAD)
			var/obj/item/bodypart/affecting = get_bodypart(ran_zone(user.zone_selected))
			apply_damage(rand(1, 3), BRUTE, affecting)

/mob/living/carbon/alien/attack_slime(mob/living/simple_animal/slime/M, list/modifiers)
	if(..()) //successful slime attack
		var/damage = rand(5, 35)
		if(M.is_adult)
			damage = rand(10, 40)
		adjustBruteLoss(damage)
		log_combat(M, src, "attacked")
		updatehealth()

/mob/living/carbon/alien/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	if(QDELETED(src))
		return
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			gib()
			return

		if (EXPLODE_HEAVY)
			take_overall_damage(60, 60)
			if(ears)
				ears.adjustEarDamage(30,120)

		if(EXPLODE_LIGHT)
			take_overall_damage(30,0)
			if(prob(50))
				Unconscious(20)
			if(ears)
				ears.adjustEarDamage(15,60)

/mob/living/carbon/alien/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	return 0

/mob/living/carbon/alien/acid_act(acidpwr, acid_volume)
	return FALSE//aliens are immune to acid.
