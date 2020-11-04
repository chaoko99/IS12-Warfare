// Simple light sources that aren't super over engineered. Very, very simple. Only meant for Nightfare.
/*Things this does:
    Emit light. 
    Stop Emitting Light.
    NOTHING ELSE.
*/
/obj/structure/simple_fire
	name = "barrel fire"
	desc = "Representative of the state of this shitty war. The vile slop at the bottom burns with black smoke. It's carcinogenic, for whatever that's worth."
	icon = 'icons/obj/fire.dmi'
	icon_state = "hobo"
	var/lit = FALSE
	anchored = 1
	density = 1 

/obj/structure/simple_fire/brazier
	name = "brazier"
	desc = "Fueled by righteous anger and discarded beer cans, this will keep your way lit. For now."
	icon_state = "brazier"

/obj/structure/simple_fire/brazier/on
	lit = 1

/obj/structure/simple_fire/Initialize()
	. = ..()
	update_icon()

/obj/structure/simple_fire/update_icon()
	if(lit)
		icon_states = "[icon_state]-lit"
		set_light(2, l_color = "#E38F46")
	else
		icon_state = initial(icon_state)
		set_light(0)


/obj/structure/simple_fire/Crossed(O)
    . = ..()
    if(ishuman(M))
        var/mob/living/carbon/human/H = M
        if(istype(H.wear_suit, /obj/item/clothing/suit/fire))
            H.show_message(text("Your suit protects you from the flames."),1)
            return
        if(H.attempt_dodge(TRUE))
            H.show_message("Your DEXTERITY saves you from the pain.")
        else
            H.adjust_fire_stacks(rand(1,10))
            H.IgniteMob()

/obj/structure/simple_fire/Destroy()
	set_light(0)
	. = ..()

/obj/structure/simple_fire/attackby(obj/item/W, mob/user)
	if(isflamesource(W))
		light(W, user)
		return
	else
		..()

/obj/structure/simple_fire/attack_hand(mob/user)
    . = ..()
    if(lit)
        snuff(user)

/obj/structure/simple_fire/proc/light(obj/item/W, mob/user)
	user.visible_message("<span class='notice'>[user] lights \the [src] with \the [W].")
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)
	lit == TRUE
	update_icon()
/obj/structure/simple_fire/proc/snuff(mob/user)
	user.visible_message("<span class='danger'>[user] snuffs the [src]!")
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)
	lit == FALSE
	update_icon()