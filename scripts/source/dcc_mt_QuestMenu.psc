Scriptname dcc_mt_QuestMenu extends SKI_ConfigBase

Import StorageUtil
Import Utility

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; configuration options
Int   Property OptBreastPower    = 1 Auto Hidden
Bool  Property OptBreastCurve    = False Auto Hidden
Float Property OptBreastCurveMin = 1.0 Auto Hidden
Float Property OptBreastCurveMax = 0.7 Auto Hidden
Bool  Property OptBreastSize     = True Auto Hidden
Float Property OptBreastSizeMin  = 0.75 Auto Hidden
Float Property OptBreastSizeMax  = 2.27 Auto Hidden
Bool  Property OptBreastPool     = False Auto Hidden
Int   Property OptBreastPoolMax  = 666 Auto Hidden
Float Property OptUpdateInterval = 0.25 Auto Hidden
Float Property OptMaintInterval  = 5.0 Auto Hidden

Int   Property OptScaleMethod    = 1 Auto Hidden
Int   Property ScaleMethodNiOverride = 1 AutoReadOnly Hidden
Int   Property ScaleMethodNetImmerse = 2 AutoReadOnly Hidden

;; reference properties
Actor Property Player Auto
Spell Property SpellMain Auto

Int Function GetVersion()
	Return 1
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnGameReload()
	parent.OnGameReload()
	;; any other gameload things here.
	Return
EndEvent

Event OnVersionUpdate(Int ver)
	OnConfigInit()
	Return
EndEvent

Event OnConfigInit()
	Pages = new String[1]
	Pages[0] = "General Options"
	Return
EndEvent

Event OnConfigOpen()
	;; OnVersionUpdate never fucking happens.
	;; this does though.
	;; http://www.loverslab.com/topic/30694-mcms-ski-configbaseonversionupdate-sucks/

	OnConfigInit()
	Return
EndEvent

Event OnConfigClose()
	self.Player.RemoveSpell(self.SpellMain)
	Utility.Wait(0.25)
	self.Player.AddSpell(self.SpellMain)
	Return
EndEvent

Event OnPageReset(string page)
	UnloadCustomContent()

	If page == "General Options"
		ShowPageGeneral()
	Else
		ShowPageIntro()
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSelect(Int Menu)

	If Menu == MenuBreastSize
		self.OptBreastSize = !self.OptBreastSize
		SetToggleOptionValue(Menu,self.OptBreastSize)
	ElseIf Menu == MenuBreastCurve
		self.OptBreastCurve = !self.OptBreastCurve
		SetToggleOptionValue(Menu,self.OptBreastCurve)
	ElseIf Menu == MenuBreastPool
		self.OptBreastPool = !self.OptBreastPool
		SetToggleOptionValue(Menu,self.OptBreastPool)
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSliderOpen(Int Menu)

	If Menu == MenuBreastSizeMin
		SetSliderDialogStartValue(self.OptBreastSizeMin)
		SetSliderDialogRange(0,6)
		SetSliderDialogInterval(0.1)
	ElseIf Menu == MenuBreastSizeMax
		SetSliderDialogStartValue(self.OptBreastSizeMax)
		SetSliderDialogRange(0,6)
		SetSliderDialogInterval(0.1)
	ElseIf Menu == MenuBreastCurveMin
		SetSliderDialogStartValue(self.OptBreastCurveMin)
		SetSliderDialogRange(0,2)
		SetSliderDialogInterval(0.1)
	ElseIf Menu == MenuBreastCurveMax
		SetSliderDialogStartValue(self.OptBreastCurveMax)
		SetSliderDialogRange(0,2)
		SetSliderDialogInterval(0.1)
	ElseIf Menu == MenuBreastPower
		SetSliderDialogStartValue(self.OptBreastPower)
		SetSliderDialogRange(1,3)
		SetSliderDialogInterval(1.0)
	ElseIf Menu == MenuUpdateInterval
		SetSliderDialogStartValue(self.OptUpdateInterval)
		SetSliderDialogRange(0.01,1)
		SetSliderDialogInterval(0.01)
	ElseIf Menu == MenuBreastPoolMax
		SetSliderDialogStartValue(self.OptBreastPoolMax)
		SetSliderDialogRange(100,1500)
		SetSliderDialogInterval(10.0)
	ElseIf Menu == MenuScaleMethod
		SetSliderDialogStartValue(self.OptScaleMethod)
		SetSliderDialogRange(1,2)
		SetSliderDialogInterval(1.0)
	EndIf

	Return
EndEvent

Event OnOptionSliderAccept(Int Menu, Float Val)

	If Menu == MenuBreastSizeMin
		self.OptBreastSizeMin = Val
		SetSliderOptionValue(Menu,Val,"{1}")
	ElseIf Menu == MenuBreastSizeMax
		self.OptBreastSizeMax = Val
		SetSliderOptionValue(Menu,Val,"{1}")
	ElseIf Menu == MenuBreastCurveMin
		self.OptBreastCurveMin = Val
		SetSliderOptionValue(Menu,Val,"{1}")
	ElseIf Menu == MenuBreastCurveMax
		self.OptBreastCurveMax = Val
		SetSliderOptionValue(Menu,Val,"{1}")
	ElseIf Menu == MenuBreastPower
		self.OptBreastPower = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")
	ElseIf Menu == MenuUpdateInterval
		self.OptUpdateInterval = Val
		SetSliderOptionValue(Menu,Val,"{2}")
	ElseIf Menu == MenuBreastPoolMax
		self.OptBreastPoolMax = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")
	ElseIf Menu == MenuScaleMethod
		self.OptScaleMethod = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionHighlight(Int Menu)

	If Menu == MenuBreastSize
		SetInfoText("Allow this mod to scale the breast sizes with the mana/health/stamina value.")
	ElseIf Menu == MenuBreastSizeMin
		SetInfoText("Size of the breasts when out of mana/health/stamina.")
	ElseIf Menu == MenuBreastSizeMax
		SetInfoText("Size of the breasts when mana/health/stamina is full.")
	ElseIf Menu == MenuBreastCurve
		SetInfoText("Allow this mod to scale the 'Breast Curve' or 'Breast01' bones down to combat pointy boobs.")
	ElseIf Menu == MenuBreastCurveMin
		SetInfoText("Size of the curve when out of mana/health/stamina.")
	ElseIf Menu == MenuBreastCurveMax
		SetInfoText("Size of the curve when mana/health/stamina is full.")
	ElseIf Menu == MenuBreastPower
		SetInfoText("1 = Magicka, 2 = Health, 3 = Stamina")
	ElseIf Menu == MenuUpdateInterval
		SetInfoText("How often the breasts update when mana is not full. Smaller = Smoother Scaling, Larger = Less Stressful on Your Computer")
	ElseIf Menu == MenuBreastPool
		SetInfoText("Link the max breast size to the max amount of mana/health/stamina you have. This means they will start small and grow as you level it.")
	ElseIf Menu == MenuBreastPoolMax
		SetInfoText("How much mana/health/stamina you have to have before the breasts reach full size.")
	ElseIf Menu == MenuScaleMethod
		SetInfoText("1 = NiOverride (Default), 2 = NetImmerse")
	Else
		SetInfoText("Mana (.)(.) Tanks")
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ShowPageIntro()
	LoadCustomContent("mana-tanks/splash.dds")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuBreastPower
Int MenuBreastCurve
Int MenuBreastCurveMin
Int MenuBreastCurveMax
Int MenuBreastSize
Int MenuBreastSizeMin
Int MenuBreastSizeMax
Int MenuBreastPool
Int MenuBreastPoolMax
Int MenuUpdateInterval
Int MenuScaleMethod

Function ShowPageGeneral()
	SetTitleText("General Options")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Basic Options")
	MenuBreastPower = AddSliderOption("Select Power Bar",self.OptBreastPower,"{0}")
	MenuUpdateInterval = AddSliderOption("Update Interval",self.OptUpdateInterval,"{2}")

	AddHeaderOption("Pool Options")
	MenuBreastPool = AddToggleOption("Link Size to Max Power",self.OptBreastPool)
	MenuBreastPoolMax = AddSliderOption("Max Power Pool Size",self.OptBreastPoolMax,"{0}")

	SetCursorPosition(1)
	AddHeaderOption("Body Size Options")
	MenuScaleMethod = AddSliderOption("Scale Method",self.OptScaleMethod,"{0}")
	MenuBreastSize = AddToggleOption("Enable Breast Scaling",self.OptBreastSize)
	MenuBreastSizeMin = AddSliderOption("Breast Size Min",self.OptBreastSizeMin,"{1}")
	MenuBreastSizeMax = AddSliderOption("Breast Size Max",self.OptBreastSizeMax,"{1}")
	MenuBreastCurve = AddToggleOption("Enable Breast Curve",self.OptBreastCurve)
	MenuBreastCurveMin = AddSliderOption("Breast Curve Min",self.OptBreastCurveMin,"{1}")
	MenuBreastCurveMax = AddSliderOption("Breast Curve Max",self.OptBreastCurveMax,"{1}")

	Return
EndFunction
