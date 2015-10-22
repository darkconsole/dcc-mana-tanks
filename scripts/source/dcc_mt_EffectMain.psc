Scriptname dcc_mt_EffectMain extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_mt_QuestMenu Property MT Auto
Bool Property MaintainMode Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; other properties.
Float    Property BreastCurveDiff = 0.0 Auto Hidden
Float    Property BreastSizeDiff  = 0.0 Auto Hidden
String   Property BreastPower Auto Hidden
Actor    Property Target Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RenewUpdateChain()
	If(!self.MaintainMode)
		self.RegisterForSingleUpdate(MT.OptUpdateInterval)
	Else
		self.RegisterForSingleUpdate(MT.OptMaintInterval)
	EndIf

	;; This prevents multiple update events from stacking up on top of each
	;; other and slowing Papyrus down. If multiple update events do stack up
	;; on top of one another, this will also increase save file size. If enough
	;; instances of the event are stacked up in this way, it can cause
	;; significant increases in the size of any save file created.
	;; -- http://www.creationkit.com/OnUpdate_-_Form

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
	;; on effect start happens when the actor's m/h/s is less than 100%. when
	;; less than full we want to update the body to match the mana pool.

	If(MT.OptBreastPower == 1)
		self.BreastPower = "Magicka"
	ElseIf(MT.OptBreastPower == 2)
		self.BreastPower = "Health"
	ElseIf(MT.OptBreastPower == 3)
		self.BreastPower = "Stamina"
	EndIf

	;; precalculate the scale we are going to go through so update does not
	;; have to.
	self.Target = caster
	self.BreastSizeDiff = Math.abs(MT.OptBreastSizeMax - MT.OptBreastSizeMin)
	self.BreastCurveDiff = Math.abs(MT.OptBreastCurveMax - MT.OptBreastCurveMin)

	;; mess with the values if we want them to depend on how much total mana
	;; you can have.
	If(MT.OptBreastPool)
		;; how many max manas we have after buffs. yep. this is how you do it.
		Float maxp = (caster.GetActorValue(self.BreastPower) / caster.GetActorValuePercentage(self.BreastPower))

		If(maxp < MT.OptBreastPoolMax)
			self.BreastSizeDiff *= (maxp / MT.OptBreastPoolMax)
			self.BreastCurveDiff *= (maxp / MT.OptBreastPoolMax)
		EndIf
	EndIf

	self.UpdateFemaleBody()
	self.RenewUpdateChain()
	Return
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
	;; on effect finish happens when the actor's mana is fully refilled, we no
	;; longer need to periodically update.
	;; self.UnregisterForUpdate()
	;; self.UpdateFemaleBody()
	;; turns out when this fires, the object has already been destroyed.
	Return
EndEvent

Event OnUpdate()
	;; it is also possible to accidentally run this after the object has been
	;; destroyed.

	If(self == None)
		;; and this does not seem to be enough to stop it.
		Return
	EndIf

	If(!self.MaintainMode && self.Target.GetActorValuePercentage(self.BreastPower) >= 1.0)
		self.RenewUpdateChain()
		Return
	EndIf

	self.UpdateFemaleBody()
	self.RenewUpdateChain()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function UpdateFemaleBody()
	If(!self.BreastPower)
		Return
	EndIf

	If(MT.OptScaleMethod == MT.ScaleMethodNiOverride)
		self.UpdateFemaleBody_NiOverride()
	ElseIf(MT.OptScaleMethod == MT.ScaleMethodNetImmerse)
		self.UpdateFemaleBody_NetImmerse()
	EndIf

	Return
EndFunction

Function UpdateFemaleBody_NiOverride()
{perform the scales using NiOverride (Default, ScaleMode 1)}

	If(MT.OptBreastSize)
		Float size = (self.Target.GetActorValuePercentage(self.BreastPower) * self.BreastSizeDiff) + MT.OptBreastSizeMin
		NiOverride.AddNodeTransformScale(self.Target,False,True,"NPC L Breast","ManaTanks.Scale",size)
		NiOverride.AddNodeTransformScale(self.Target,False,True,"NPC R Breast","ManaTanks.Scale",size)
		NiOverride.UpdateNodeTransform(self.Target,False,True,"NPC L Breast")
		NiOverride.UpdateNodeTransform(self.Target,False,True,"NPC R Breast")
	EndIf

	If(MT.OptBreastCurve)
		Float curve = MT.OptBreastCurveMin - (self.Target.GetActorValuePercentage(self.BreastPower) * self.BreastCurveDiff)
		NiOverride.AddNodeTransformScale(self.Target,False,True,"NPC L Breast01","ManaTanks.Scale",curve)
		NiOverride.AddNodeTransformScale(self.Target,False,True,"NPC R Breast01","ManaTanks.Scale",curve)
		NiOverride.UpdateNodeTransform(self.Target,False,True,"NPC L Breast01")
		NiOverride.UpdateNodeTransform(self.Target,False,True,"NPC R Breast01")
	EndIf

	Return
EndFunction

Function UpdateFemaleBody_NetImmerse()
{perform the scales using NetImmerse (ScaleMode 2)}

	If(MT.OptBreastSize)
		Float size = (self.Target.GetActorValuePercentage(self.BreastPower) * self.BreastSizeDiff) + MT.OptBreastSizeMin
		NetImmerse.SetNodeScale(self.Target,"NPC L Breast",size,false)
		NetImmerse.SetNodeScale(self.Target,"NPC R Breast",size,false)
	EndIf

	If(MT.OptBreastCurve)
		Float curve = MT.OptBreastCurveMin - (self.Target.GetActorValuePercentage(self.BreastPower) * self.BreastCurveDiff)
		NetImmerse.SetNodeScale(self.Target,"NPC L Breast01",curve,false)
		NetImmerse.SetNodeScale(self.Target,"NPC R Breast01",curve,false)
	EndIf

	Return
EndFunction
