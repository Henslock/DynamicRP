if SERVER then return end

// *ALCHEMY PANEL* //

local main_panelBG = ( "materials/fancyalchemy/ui/UIBG.png" )
local main_tCircleMat = Material( "materials/fancyalchemy/transmutation_circle.png", "smooth" )
local main_empowermentMat = Material( "materials/fancyalchemy/auraglow.png", "smooth" )
local main_empowermentBG = Material( "materials/fancyalchemy/ui/ui_empowerbg.png", "smooth" )
local main_empowermentPot = Material( "materials/fancyalchemy/ui/ui_potion.png", "smooth" )
local main_insightBG = Material( "materials/fancyalchemy/ui/ui_insight.png", "smooth" )
local main_insightBGDisabled = Material( "materials/fancyalchemy/ui/ui_insight_disabled.png", "smooth" )
local ui_icobg = Material( "materials/fancyalchemy/ui/ui_icobg.png", "smooth" )
local ui_lockedIcon = Material( "materials/fancyalchemy/ui/ico_locked.png", "smooth" )

local INSERTED_INGREDIENTS = {
[1] = "" or nil,
[2] = "" or nil,
[3] = "" or nil
}

local cauldronEnt = nil
local knownRecipes = {}

local PANEL = {}
local mainBG_res_x, mainBG_res_y = 1262, 834
local myPanel = nil

function PANEL:Init()
	--Init look	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:SetTitle("")
	self:Dock(FILL)
	self:Center()
	self:ShowCloseButton(false)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3, 0)

	self.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 0))	
	end
	
	if(LocalPlayer():GetNWInt("falch_level") == 0) then
		self:Close()
		net.Start("falch_InitData")
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
		return
	end
	
	INSERTED_INGREDIENTS = {
	[1] = "" or nil,
	[2] = "" or nil,
	[3] = "" or nil
	}
	
	LocalPlayer():EmitSound("falch_ui_open")
	-- Draw Panel BG
	self.mainBG = self:Add("DImage")
	self.mainBG:SetPos(ScrW() / 2 - mainBG_res_x*0.5, ScrH()/2 - mainBG_res_y*0.5)
	self.mainBG:SetSize(mainBG_res_x, mainBG_res_y)
	self.mainBG:SetImage( main_panelBG )
	
	-- I am going to create a mask so the transmutation circles clip properly
	local masksize_x, masksize_y = 1150, 735
	self.mainBG_mask = self:Add("DImage")
	self.mainBG_mask:SetPos(ScrW() / 2 - masksize_x*0.5 + 2, ScrH()/2 - masksize_y*0.5 - 2)
	self.mainBG_mask:SetSize(masksize_x, masksize_y)
	self.mainBG_mask:SetImageColor(Color(0, 0, 0, 0))
	self.mainBG_mask:SetImage( "materials/fancyalchemy/ui/ui_mask.png" )
	
	-- Transmutation Circles
	local t_circle = self.mainBG_mask:Add("DImage")
	local w, h = 460, 460
	t_circle:SetPos(ScrW()/2 - w/2 - 750, ScrH()/2 - h/2 + 75)
	t_circle:SetSize(w, h)
	t_circle.rot = 0
	t_circle.Paint = function(_, w, h)
		t_circle.rot = t_circle.rot + FrameTime() *10
		surface.SetMaterial(main_tCircleMat)
		surface.SetDrawColor(0, 0, 0, 55)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, t_circle.rot)
	end
	
	local t_circle = self.mainBG_mask:Add("DImage")
	local w, h = 460, 460
	t_circle:SetPos(ScrW()/2 - w/2 + 100, ScrH()/2 - h/2 - 405)
	t_circle:SetSize(w, h)
	t_circle.rot = 0
	t_circle.Paint = function(_, w, h)
		t_circle.rot = t_circle.rot + FrameTime() *10
		surface.SetMaterial(main_tCircleMat)
		surface.SetDrawColor(0, 0, 0, 55)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, t_circle.rot)
	end
	
	self.alchCloseBtn = vgui.Create("FA:CloseBtn", self)
	self.alchXPBar = vgui.Create("FA:XPBar", self)
	self.alchIngredients = vgui.Create("FA:Ingredients", self)
	self.alchMix = vgui.Create("FA:Mix", self)
	self.alchFamiliars = vgui.Create("FA:Familiars", self)
	self.alchInsightBtn = vgui.Create("FA:Insight", self)
	self.alchEmpower = vgui.Create("FA:Empower", self)
end

vgui.Register("FA:MainPanel", PANEL, "DFrame")

net.Receive("fa_open_alchemy", function()
	cauldronEnt = net.ReadEntity()
	knownRecipes = net.ReadTable()
	if(IsValid(myPanel)) then return end
	myPanel = vgui.Create("FA:MainPanel")
end)

-- CLOSE BTN

local PANEL = {}

function PANEL:Init()
	self:SetPos((ScrW()/2) + mainBG_res_x/2 - 90, ScrH()/2 - mainBG_res_y/2 +55)
	self:SetSize(28, 28)
	self:SetText("")
	self:SetImage("materials/fancyalchemy/ui/ui_closebtn.png")
	
	
	self.DoClick = function (self)
			self:GetParent():Close()
		end
end

vgui.Register("FA:CloseBtn", PANEL, "DImageButton")

-- XP BAR

local PANEL = {}

function PANEL:Init()
	self:SetPos(ScrW()/2  - (mainBG_res_x/2) + 70, ScrH()/2 + (mainBG_res_y/2) - 105 )
	self:SetSize(mainBG_res_x - 135, 35)
	
	local xp, lvl = LocalPlayer():GetNWInt("falch_xp"), LocalPlayer():GetNWInt("falch_level")
	if (lvl == 0) then lvl = 1 end
	self:SetFraction(xp / FANCYALCHEMY_LEVELTABLE[lvl])
	
	local f = self:GetFraction()
	self.BarLerp = 0
	self.Paint = function(s, w, h)
		s.BarLerp = Lerp(FrameTime()*4, s.BarLerp, f)
		draw.RoundedBox(0, 0, 0, w, h, Color(37, 37, 37, 255))
		if(lvl == #FANCYALCHEMY_LEVELTABLE) then
			local col = Color(100, 180 + (30 * (math.cos(RealTime()*2)) ), 180 + (30 * (math.sin(RealTime()*2)) ) )
			draw.RoundedBox(0, 0, 0, w*s.BarLerp, h, col)
		else
			draw.RoundedBox(0, 0, 0, w*s.BarLerp, h, Color(82, 145, 102, 255))
		end
	end

	-- LABELS
	-- XP
	xp = math.floor(xp)
	self.xpLabel = self:Add("DLabel")
	self.xpLabel:SetText(xp .. "/" ..FANCYALCHEMY_LEVELTABLE[lvl])
	self.xpLabel:SetFont("FALCH_xpLabel")
	self.xpLabel:SizeToContents()
	self.xpLabel:Center()
	self.xpLabel:SetColor(Color(255, 255, 255))
	-- XP
	self.lvlLabel = self:Add("DLabel")
	self.lvlLabel:SetText("Lv. " .. lvl)
	self.lvlLabel:SetFont("FALCH_lvLabel")
	self.lvlLabel:SizeToContents()
	self.lvlLabel:AlignLeft(10)
	self.lvlLabel:CenterVertical()
	self.lvlLabel:SetColor(Color(255, 255, 255))
end

vgui.Register("FA:XPBar", PANEL, "DProgress")

-- EMPOWERMENT

local PANEL = {}

function PANEL:Init()
	local ply = LocalPlayer()
	if(ply:GetNWInt("falch_level") ~= #FANCYALCHEMY_LEVELTABLE) then return end
	local isEmpowered = ply:GetNWBool("falch_empowered")
	local empStacks = ply:GetNWInt("falch_EmpowerStacks")
	
	if(empStacks == 0) or (isEmpowered) then self:SetEnabled(false) end
	self:SetImage("materials/fancyalchemy/ui/ui_empower.png")
	self:SetPos(ScrW()/2 - 360, ScrH()/2 + 175)
	self:SetSize(100, 100)
	self:SetAlpha(255)
	
	local empBG = self:Add("DImage")
	local w, h = 130, 130
	empBG:SetSize(w, h)
	empBG:Center()
	empBG.rot = 0
	empBG:SetAlpha(0)
	empBG.Paint = function(_, w, h)
		empBG.rot = empBG.rot - FrameTime() *15
		surface.SetMaterial(main_empowermentBG)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, empBG.rot)
	end	
	
	local empPot = self:Add("DImage")
	local w, h = 100, 100
	empPot:SetSize(w, h)
	empPot:Center()
	empPot:SetAlpha(0)
	empPot:SetImage("materials/fancyalchemy/ui/ui_potion.png")
	
	
	-- Display Stacks
	local stacks = self:Add("DLabel")
	stacks:SetText(empStacks)
	stacks:SetFont("FALCH_Stacks")
	stacks:SizeToContents()
	stacks:SetColor(Color(255,255,255))
	stacks:AlignRight(10)
	stacks:AlignBottom(0)
	
	local emptext = self:GetParent():Add("DLabel")
	emptext:SetText("Your next potion is empowered.")
	emptext:SetFont("FALCH_StacksMsg")
	emptext:SetPos(ScrW()/2 - 230, ScrH()/2 + 215)
	emptext:SetColor(Color(255, 255, 255))
	emptext:SizeToContents()
	emptext:SetAlpha(0)
	
	local sk = table.Copy(derma.GetDefaultSkin())
	sk.PaintTooltip = function() end
	derma.DefineSkin("EmpowermentTooltip", "Display Empowerment Info", sk)
	
	-- [[ TOOLTIPS ]] --
		surface.SetFont("FALCH_Tooltip")		
		local tooltipPanel = vgui.Create("Panel")
		tooltipPanel:SetSize(235, 170)
		tooltipPanel:SetVisible(false)
		
		tooltipPanel.Paint = function( s, w, h ) 
			draw.RoundedBox(20, 0, 0, w, h, Color( 0, 0, 0, 225 ) )
		end
		tooltipPanel.Think = function(self)
			self:GetParent():SetSkin("EmpowermentTooltip")
			self:GetParent():SetPos(gui.MouseX() -2, gui.MouseY() - 175)
		end
	
		local dlabel = vgui.Create( "DLabel", tooltipPanel )
		dlabel:SetText("EMPOWERMENT")
		dlabel:SetFont("FALCH_Tooltip")
		dlabel:SetColor(Color(255, 71, 251))
		dlabel:SizeToContents()
		dlabel:CenterHorizontal()

		local dlabel = vgui.Create( "DLabel", tooltipPanel )
		dlabel:SetText("Activating this ability empowers your next crafted potion, causing it to become a Fanatical potion. \n \nFanatical potions are extremely potent and can only be acquired through empowerment.")
		dlabel:SetFont("FALCH_TooltipCost")
		dlabel:SetColor(Color(255, 255, 255))
		dlabel:SetSize(230, 250)
		dlabel:SetAutoStretchVertical(true)
		dlabel:SetWrap(true)
		dlabel:SetPos(0, 25)
		dlabel:AlignLeft(10)		

	-- [[ END TOOLTIPS ]] --
	
	--== GLOWING AURAS  ==--
		local empAura = self:GetParent():Add("DImage")
		local w, h = 240, 240
		empAura:SetPos(ScrW()/2 - 425, ScrH()/2 + 105)
		empAura:SetSize(w, h)
		empAura:MoveToBefore(self)
		empAura.rot = 0
		empAura:SetAlpha(0)
		empAura.Paint = function(_, w, h)
			empAura.rot = empAura.rot + FrameTime() *10
			surface.SetMaterial(main_empowermentMat)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRectRotated(w/2, h/2, w, h, empAura.rot)
		end
		
		local empAura2 = self:GetParent():Add("DImage")
		local w, h = 240, 240
		empAura2:SetPos(ScrW()/2 - 425, ScrH()/2 + 105)
		empAura2:SetSize(w, h)
		empAura2:MoveToBefore(self)
		empAura2.rot = 0
		empAura2:SetAlpha(0)
		empAura2.Paint = function(_, w, h)
			empAura2.rot = empAura2.rot - FrameTime() *20
			surface.SetMaterial(main_empowermentMat)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRectRotated(w/2, h/2, w, h, empAura2.rot)
		end
		
	if(isEmpowered) then
		empAura2:AlphaTo(255, 0.5, 0)
		empAura:AlphaTo(255, 0.5, 0)
		emptext:AlphaTo(255, 0.5, 0.5)
		
		empPot:AlphaTo(255, 0.5, 0)
		empBG:AlphaTo(255, 0.5, 0)
	end
	--====--
	self.OnCursorEntered = function(self)
		LocalPlayer():EmitSound("falch_ui_hover")
	end
	
	self.DoClick = function()
		self:SetSize(120, 120)
		self:SetPos(ScrW()/2 - 370, ScrH()/2 + 165)
		self:MoveTo(ScrW()/2 - 360, ScrH()/2 + 175, 0.5, 0, 0.5)
		self:SizeTo(100, 100, 0.5, 0, 0.5)
		
		empStacks = empStacks -1
		if(empStacks <0) then empStacks = 0 end
		stacks:SetText(empStacks)
		stacks:SetAlpha(0)
		stacks:AlphaTo(255, 0.5, 0.5)
		emptext:AlphaTo(255, 0.5, 0.5)
		
		empAura2:AlphaTo(255, 0.5, 0)
		empAura:AlphaTo(255, 0.5, 0)
		empPot:AlphaTo(255, 0.5, 0.5)
		empBG:AlphaTo(255, 0.5, 0.5)
		
		self:SetEnabled(false)
		isEmpowered = true
		
		LocalPlayer():EmitSound("falch_ui_empower")
		LocalPlayer():EmitSound("falch_ui_unclick")
		
		hook.Call("FALCH_UpdateInsightDisplay")
		net.Start("falch_Empower")
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end
	
	-- Empowerment border
	local icoBorderCol = {33, 33, 33}
	self.PaintOver = function(_, w, h)
		if not (_:IsHovered() or mdlHighlight) then 
			icoBorderCol = {33, 33, 33}
		else
			icoBorderCol = {255, 255, 255}
		end
		surface.SetDrawColor(icoBorderCol[1], icoBorderCol[2], icoBorderCol[3])
		if(isEmpowered) then
			surface.SetDrawColor(HSVToColor(RealTime()*50 % 360, 0.5, 1))
		end
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
	end
	
	self:SetSkin("EmpowermentTooltip")
	self:SetTooltipPanel(tooltipPanel)
end

vgui.Register("FA:Empower", PANEL, "DImageButton")

-- INSIGHT

local PANEL = {}

function PANEL:Init()
	local ply = LocalPlayer()
	if(ply:GetNWInt("falch_level") ~= #FANCYALCHEMY_LEVELTABLE) then return end
	local empStacks = ply:GetNWInt("falch_EmpowerStacks")
	
	local amntKnownRecipes = 0
	for k, v in ipairs(knownRecipes) do
		if(v == true) then
			amntKnownRecipes  = amntKnownRecipes + 1
		end
	end
	if(amntKnownRecipes >= #FANCYALCHEMY_RECIPES) then return end
	
	if(empStacks == 0) then self:SetEnabled(false) end
	self:SetPos(ScrW()/2 - 480, ScrH()/2 + 175)
	if(empStacks > 0) then
		self:SetImage("materials/fancyalchemy/ui/ui_insight.png")
	else
		self:SetImage("materials/fancyalchemy/ui/ui_insight_disabled.png")
	end
	self:SetSize(100, 100)
	
	-- Display Stacks
	local stacks = self:Add("DLabel")
	stacks:SetText(empStacks)
	stacks:SetFont("FALCH_Stacks")
	stacks:SizeToContents()
	stacks:SetColor(Color(255,255,255))
	stacks:AlignRight(10)
	stacks:AlignBottom(0)
	
	local sk = table.Copy(derma.GetDefaultSkin())
	sk.PaintTooltip = function() end
	derma.DefineSkin("FALCH_InsightTooltip", "Display Insight Info", sk)
	
	-- [[ TOOLTIPS ]] --
		surface.SetFont("FALCH_Tooltip")		
		local tooltipPanel = vgui.Create("Panel")
		tooltipPanel:SetSize(235, 120)
		tooltipPanel:SetVisible(false)
		
		tooltipPanel.Paint = function( s, w, h ) 
			draw.RoundedBox(20, 0, 0, w, h, Color( 0, 0, 0, 225 ) )
		end
		tooltipPanel.Think = function(self)
			self:GetParent():SetSkin("FALCH_InsightTooltip")
			self:GetParent():SetPos(gui.MouseX() -2, gui.MouseY() - 125)
		end
	
		local dlabel = vgui.Create( "DLabel", tooltipPanel )
		dlabel:SetText("INSIGHT")
		dlabel:SetFont("FALCH_Tooltip")
		dlabel:SetColor(Color(153, 107, 255))
		dlabel:SizeToContents()
		dlabel:CenterHorizontal()

		local dlabel = vgui.Create( "DLabel", tooltipPanel )
		dlabel:SetText("Activating this ability will imbue the alchemist with insight, causing them to brew a potion recipe that is not yet known.")
		dlabel:SetFont("FALCH_TooltipCost")
		dlabel:SetColor(Color(255, 255, 255))
		dlabel:SetSize(220, 200)
		dlabel:SetAutoStretchVertical(true)
		dlabel:SetWrap(true)
		dlabel:SetPos(0, 25)
		dlabel:AlignLeft(10)		

	-- [[ END TOOLTIPS ]] --
	
	self.OnCursorEntered = function(self)
		LocalPlayer():EmitSound("falch_ui_hover")
	end
	
	self.DoClick = function()
		self:SetSize(120, 120)
		self:SetPos(ScrW()/2 - 370, ScrH()/2 + 165)
		self:MoveTo(ScrW()/2 - 360, ScrH()/2 + 175, 0.5, 0, 0.5)
		self:SizeTo(100, 100, 0.5, 0, 0.5)
		
		empStacks = empStacks -1
		if(empStacks <0) then empStacks = 0 end
		stacks:SetText(empStacks)
		stacks:SetAlpha(0)
		stacks:AlphaTo(255, 0.5, 0.5)
		
		self:SetEnabled(false)
		
		LocalPlayer():EmitSound("falch_ui_insight")
		LocalPlayer():EmitSound("falch_ui_unclick")

		net.Start("falch_InsightCrafting")
			net.WriteEntity(LocalPlayer())
			net.WriteEntity(cauldronEnt)
		net.SendToServer()
		
		self:GetParent():Close()
	end
	
	-- Empowerment border
	local icoBorderCol = {33, 33, 33}
	self.PaintOver = function(_, w, h)
		if not (_:IsHovered() or mdlHighlight) then 
			icoBorderCol = {33, 33, 33}
		else
			icoBorderCol = {255, 255, 255}
		end
		surface.SetDrawColor(icoBorderCol[1], icoBorderCol[2], icoBorderCol[3])
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
	end
	
	self:SetSkin("FALCH_InsightTooltip")
	self:SetTooltipPanel(tooltipPanel)
	
	// To make sure that the button updates when we click empowerment
	hook.Add("FALCH_UpdateInsightDisplay", "UpdateInsightUIInfo", function()
		empStacks = math.max(empStacks - 1, 0)
		stacks:SetText(empStacks)
		
		stacks:SetAlpha(0)
		stacks:AlphaTo(255, 0.5, 0.5)
		
		if(empStacks <= 0) then
			self:SetImage("materials/fancyalchemy/ui/ui_insight_disabled.png")
			self:SetEnabled(false)
		end
	end)
end

vgui.Register("FA:Insight", PANEL, "DImageButton")

-- INGREDIENTS

local PANEL = {}

function PANEL:Init()
	self:SetPos((ScrW()/2) - mainBG_res_x/2 + 130, ScrH()/2 - mainBG_res_y/2 + 180)
	self:SetSize(380, 400)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end

	------------------------
	local dGrid = self:Add("DGrid")
	dGrid:SetPos(0, 0)
	dGrid:SetCols(4)
	dGrid:SetColWide(102)
	dGrid:SetRowHeight(102)
	
	local plyLvl = LocalPlayer():GetNWInt("falch_level")
	if(plyLvl == 0) then plyLvl =1 end
	
	--CREATE INGREDIENTS--
	for k, v in ipairs(FANCYALCHEMY_INGREDIENTS) do
		local ingredient = vgui.Create("DPanel")
		ingredient:SetSize(70, 70)
		ingredient:SetText("")
		dGrid:AddItem(ingredient)
		
		ingredient.Paint = function(_, w, h)
			--draw.RoundedBox(0, 0, 0, w, h, Color(34, 34, 34, 255))
			surface.SetMaterial(ui_icobg)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect(0, 0, w, h)
			
		end
		
		
		local sk = table.Copy(derma.GetDefaultSkin())
		sk.PaintTooltip = function() end
		derma.DefineSkin("IngredientsTooltip", "Display Ingredients Info", sk)
		
		-- [[ INGREDIENTS TOOLTIPS ]] --
			local cost = v.cost
			if(LocalPlayer():GetNWBool("fa_familiar_reducedmaterials") == true) then cost = cost * FANCYALCHEMY_BATMULT end
			local name = v.name
			
			local tooltipPanel = vgui.Create("Panel")
			tooltipPanel:SetSize(300, 0)
			tooltipPanel:SetVisible(false)
			
			tooltipPanel.Paint = function( s, w, h ) 
				draw.RoundedBox(20, 0, 0, w, h, Color( 0, 0, 0, 240 ) )
			end
			tooltipPanel.Think = function(self)
				self:GetParent():SetSkin("IngredientsTooltip")
				self:GetParent():SetPos(gui.MouseX() , gui.MouseY() - tooltipPanel:GetTall())
			end
			
			if(plyLvl >= v.reqlvl) then
				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText(name)
				dlabel:SetFont("FALCH_Tooltip")
				dlabel:SetColor(Color(255,255,255))
				dlabel:SizeToContents()
				dlabel:CenterHorizontal()
				
				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				surface.SetFont("FALCH_TooltipCost")
				local Dlabeltext = v.desc
				local Dlabeltextsize = surface.GetTextSize(Dlabeltext)
				dlabel:SetWrap(true)
				dlabel:Dock(TOP)
				dlabel:DockMargin(10, 25, 10, 0)
				dlabel:DockPadding(0, 50, 0, 0)
				dlabel:SetFont("FALCH_TooltipCost")
				dlabel:SetAutoStretchVertical(true)
				dlabel:SetText(Dlabeltext)
				dlabel:SetColor(Color(185,185,185))
				
				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText("Costs $" ..string.Comma(cost))
				dlabel:SetFont("FALCH_TooltipCost")
				dlabel:SetColor(Color(117, 255, 119))
				dlabel:SizeToContents()
				dlabel:Dock(BOTTOM)
				dlabel:SetContentAlignment(2)
				dlabel:DockMargin(0, 0, 0, 5)
				dlabel:CenterHorizontal()
				
				tooltipPanel:SetSize(300, 60 + Dlabeltextsize/14)
			else
				tooltipPanel:SetSize(155, 50)
				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText("LOCKED")
				dlabel:SetFont("FALCH_Tooltip")
				dlabel:SetColor(Color(255,85,85))
				dlabel:SizeToContents()
				dlabel:CenterHorizontal()

				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText("Requires Lv." ..v.reqlvl)
				dlabel:SetFont("FALCH_TooltipCost")
				dlabel:SetColor(Color(125, 125, 125))
				dlabel:SizeToContents()
				dlabel:SetPos(0, 25)
				dlabel:CenterHorizontal()
			end
		-- [[ END TOOLTIPS ]] --
		
		-- DRAW ICONS --
		local mdlHighlight = false
		if(plyLvl >= v.reqlvl) then
			local modelicon = ingredient:Add("DModelPanel")
			modelicon:SetModel(v.model)
			modelicon:SetCamPos( v.ui_vec )
			modelicon:SetLookAt(v.look_vec)
			modelicon:SetSize(ingredient:GetSize())
			modelicon:SetSkin("IngredientsTooltip")
			modelicon:SetTooltipPanel(tooltipPanel)
			
			modelicon.DoClick = function(self)
				hook.Call("FALCH_AddIngredient", GAMEMODE, k)
				LocalPlayer():EmitSound("falch_ui_click")
			end
			
			modelicon.OnCursorEntered = function(self)
				LocalPlayer():EmitSound("falch_ui_hover")
			end
			
			modelicon.PaintOver = function(_, w, h)
				if(_:IsHovered()) then
					mdlHighlight = true
				else
					mdlHighlight = false
				end
			end
			
		else
			local lockedicon = ingredient:Add("DImage")
			lockedicon:SetImage( "materials/fancyalchemy/ui/ico_locked.png" )
			lockedicon:SetSize(ingredient:GetSize())
			lockedicon:SetAlpha(63)
		end
		
		-----
		
		-- Border around boxes
		local icoBorderCol = {155, 155, 155}
		ingredient.PaintOver = function(_, w, h)
			if not (_:IsHovered() or mdlHighlight) then 
				icoBorderCol = {155, 155, 155}
			else
				icoBorderCol = {255, 255, 255}
			end
			surface.SetDrawColor(icoBorderCol[1], icoBorderCol[2], icoBorderCol[3])
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		if(plyLvl < v.reqlvl) then
			ingredient:SetSkin("IngredientsTooltip")
			ingredient:SetTooltipPanel(tooltipPanel)
		end
		
	end
end

vgui.Register("FA:Ingredients", PANEL, "DPanel")


-- CALCULATE RECIPE OUTCOME

local function FALCH_CalculateRecipe()
	-- Convert our ingredients into a recipe key table
	local mixIng = {}
	local result = nil
	for i = 1, 3 do
		if(mixIng[INSERTED_INGREDIENTS[i].tag] == nil) then
			mixIng[INSERTED_INGREDIENTS[i].tag] = 1
		else
			mixIng[INSERTED_INGREDIENTS[i].tag] = mixIng[INSERTED_INGREDIENTS[i].tag] + 1
		end
	end
	
	for k, v in ipairs (FANCYALCHEMY_RECIPES) do
		local recipe = v.recipe
		local match = false
		for i, j in pairs(recipe) do
			if (mixIng[i] == j) then 
				match = true
			else
				match = false
				break 
			end
		end
		if(match) then result = k end
	end
	return result
end

-- MIXING

local PANEL = {}
local MixBtns = {}

function PANEL:Init()
	self:SetPos((ScrW()/2) + 18, ScrH()/2 + 95)
	self:SetSize(400, 200)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 15))
	end
	
	
	for i = 1,3 do
		MixBtns[i] = self:Add("DModelPanel")
		MixBtns[i]:SetSize(80, 80)
		MixBtns[i]:SetPos(55 + 100*(i-1), 0)
		MixBtns[i]:SetModel("")
		MixBtns[i]:SetText("")
		
		MixBtns[i].Paint_org = MixBtns[i].Paint
		
		MixBtns[i].OnCursorEntered = function(self)
			LocalPlayer():EmitSound("falch_ui_hover")
		end
		
		MixBtns[i].Paint = function(self, w, h)
			--draw.RoundedBox(0, 0, 0, w, h, Color(34, 34, 34, 155))
			surface.SetMaterial(ui_icobg)
			surface.SetDrawColor(255,255,255, 125)
			surface.DrawTexturedRect(0, 0, w, h)
			self:Paint_org(w, h)
		end
		
		MixBtns[i].DoClick = function(self)
			hook.Call("FALCH_RemoveIngredient", GAMEMODE, i)
			LocalPlayer():EmitSound("falch_ui_unclick")
		end
			
		-- Border around boxes
		local icoBorderCol = {155, 155, 155}
		MixBtns[i].PaintOver = function(_, w, h)
			if not (_:IsHovered()) then 
				icoBorderCol = {155, 155, 155}
			else
				icoBorderCol = {255, 255, 255}
			end
			surface.SetDrawColor(icoBorderCol[1], icoBorderCol[2], icoBorderCol[3])
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	end
	
	-- BREW BUTTON
	
	local brewBtn = self:Add("DImageButton")
	brewBtn:SetSize(110, 54)
	brewBtn:SetPos(140, 100)
	brewBtn:SetText("")
	brewBtn:SetImage("materials/fancyalchemy/ui/ui_brewbtn.png")
	brewBtn:SetAlpha(50)
	brewBtn:SetEnabled(false)
	
	local knowledgeCount = 0
	for k, v in pairs(knownRecipes) do
		if v == true then
			knowledgeCount = knowledgeCount +1
		end
	end
	knowledgeCount = math.floor(knowledgeCount/10)
	
	brewBtn.DoClick = function(self)
		local costval = 0
		
		if(cauldronEnt:GetMixing() == true) then
			LocalPlayer():ChatPrint("Someone is already mixing in this cauldron!")
			self:GetParent():GetParent():Close()
			return
		end
		
		for k, v in ipairs(INSERTED_INGREDIENTS) do
			if(v ~= nil) and (v ~= "") then
				local addcost = v.cost
				if(LocalPlayer():GetNWBool("fa_familiar_reducedmaterials") == true) then addcost = addcost * FANCYALCHEMY_BATMULT end
				costval = costval + addcost
			end
		end
		costval = math.Round(costval / (1 + knowledgeCount/100))
		
		local money = LocalPlayer():getDarkRPVar("money")
		// CREATE POTION //
		if(money >= costval) then
			
			local result_index = FALCH_CalculateRecipe()
			local result = FANCYALCHEMY_RECIPES[result_index]
			if(result ~= nil) then
				local xp = result.xp
				local time = result.time
				local chance = false
				local boost = false
				//OWL
				if(LocalPlayer():GetNWBool("fa_familiar_exp") == true) then xp = xp * FANCYALCHEMY_OWLMULT end
				//TOAD
				if(LocalPlayer():GetNWBool("fa_familiar_fastbrew") == true) then time = time * FANCYALCHEMY_TOADMULT end
				//FELINE
				if(LocalPlayer():GetNWBool("fa_familiar_doublepotions") == true) then 
					local roll = math.random(1, 100)
					if(roll <= FANCYALCHEMY_FELINECHANCE) then
						chance = true
					end
				end
				//CROW
				if(LocalPlayer():GetNWBool("fa_familiar_quality") == true) then 
					local roll = math.random(1, 100)
					if(roll <= FANCYALCHEMY_CROWCHANCE) then
						print("Quality Boost")
						boost = true
					end
				end
				
				timer.Simple(time, function()
					if(self == nil) or (cauldronEnt == nil) then return end
					net.Start("falch_giveXP")
						net.WriteEntity(LocalPlayer())
						net.WriteFloat(xp)
					net.SendToServer()
					
					net.Start("falch_learnRecipe")
						net.WriteEntity(LocalPlayer())
						net.WriteFloat(result_index)
					net.SendToServer()
				end)
				
				local ingtbl = {INSERTED_INGREDIENTS[1].model, INSERTED_INGREDIENTS[2].model, INSERTED_INGREDIENTS[3].model}
				net.Start("falch_createPotion")
					net.WriteEntity(cauldronEnt)
					net.WriteString(result.reward)
					net.WriteFloat(result.quality)
					net.WriteBool(LocalPlayer():GetNWBool("falch_empowered"))
					net.WriteFloat(time)
					net.WriteTable(ingtbl)
					net.WriteBool(true)
					net.WriteBool(chance)
					net.WriteBool(boost)
				net.SendToServer()
			else
				local ingtbl = {INSERTED_INGREDIENTS[1].model, INSERTED_INGREDIENTS[2].model, INSERTED_INGREDIENTS[3].model}
				net.Start("falch_createPotion")
					net.WriteEntity(cauldronEnt)
					net.WriteString("nothing")
					net.WriteFloat(1)
					net.WriteBool(LocalPlayer():GetNWBool("falch_empowered"))
					net.WriteFloat(math.Rand(5,8))
					net.WriteTable(ingtbl)
					net.WriteBool(false)
				net.SendToServer()
			end
			
			net.Start("falch_payForMix")
				net.WriteEntity(LocalPlayer())
				net.WriteFloat(costval)
			net.SendToServer()
			LocalPlayer():EmitSound("falch_ui_unclick")
			LocalPlayer():EmitSound("falch_ui_brew")
			self:GetParent():GetParent():Close()
		else
			chat.AddText(Color(255,255,255), "[Fancy Alchemy] ", Color(255, 125, 125), "You do not have enough money!")
			LocalPlayer():EmitSound("buttons/button10.wav", 80, 100, 1, CHAN_AUTO)
		end
	
	end
	
	-- COSTS
	surface.SetFont("FALCH_lvLabel")
	local price = 0
	local costssize = surface.GetTextSize("Costs ")
	local pricesize = surface.GetTextSize("$" .. string.Comma(price))
	local totalsize = costssize + pricesize
	local x, y = self:GetSize()
	
	local costLbl = self:Add("DLabel")
	costLbl:SetText("Costs ")
	costLbl:SetColor(Color(125,125,125))
	costLbl:SetFont("FALCH_lvLabel")
	costLbl:SizeToContents()
	costLbl:SetPos(195 - totalsize/2, 160)
	
	local costLblx, costLblxy = costLbl:GetPos()
	local priceLbl = self:Add("DLabel")
	priceLbl:SetText("$" .. string.Comma(price))
	priceLbl:SetColor(Color(125,125,125))
	priceLbl:SetFont("FALCH_lvLabel")
	priceLbl:SizeToContents()
	priceLbl:SetPos(costLblx + costssize, 160)
	
	local knowledgeDiscountLbl = self:Add("DLabel")
	knowledgeDiscountLbl:SetText("Knowledge Discount: ".. knowledgeCount .. "%")
	knowledgeDiscountLbl:SetColor(Color(125,125,125))
	knowledgeDiscountLbl:SetFont("FALCH_discountLabel")
	knowledgeDiscountLbl:SizeToContents()
	knowledgeDiscountLbl:SetPos(0, 180)
	knowledgeDiscountLbl:CenterHorizontal()
	--
	
	
	-- UPDATE HOOKS
	hook.Add("FALCH_AddIngredient", "AddMixingIngredients", function(id)
		local ingredient = (FANCYALCHEMY_INGREDIENTS[id])
		if(ingredient ~= nil) then
			for k, v in ipairs(INSERTED_INGREDIENTS) do
				if(v == "" or v == nil) then
					INSERTED_INGREDIENTS[k] = ingredient
					MixBtns[k]:SetModel(ingredient.model)
					MixBtns[k]:SetCamPos( ingredient.ui_vec )
					MixBtns[k]:SetLookAt( ingredient.look_vec )
					break
				end
				
			end
		end
		hook.Call("FALCH_UpdateCost")
		
		if(INSERTED_INGREDIENTS[1] ~= (nil or "") and INSERTED_INGREDIENTS[2] ~= (nil or "") and INSERTED_INGREDIENTS[3] ~= (nil or "")) then
			brewBtn:AlphaTo(255, 0.5, 0)
			brewBtn:SetEnabled(true)
		end
	end)
	
	hook.Add("FALCH_RemoveIngredient", "RemoveMixingIngredients", function(index)
		INSERTED_INGREDIENTS[index] = "" or nil
		MixBtns[index]:SetModel("")
		hook.Call("FALCH_UpdateCost")
		
		brewBtn:AlphaTo(50, 0.1, 0)
		brewBtn:SetEnabled(false)
	end)
	
	-- Update the cost label
	hook.Add("FALCH_UpdateCost", "UpdateCostValue", function()
		local costval = 0
		
		for k, v in ipairs(INSERTED_INGREDIENTS) do
			if(v ~= nil) and (v ~= "") then
				local addcost = v.cost
				if(LocalPlayer():GetNWBool("fa_familiar_reducedmaterials") == true) then addcost = addcost * FANCYALCHEMY_BATMULT end
				costval = costval + addcost
			end
		end
		
		costval = math.Round(costval / (1 + (knowledgeCount/100)))
		
		surface.SetFont("FALCH_lvLabel")
		local costssize = surface.GetTextSize("Costs ")
		local pricesize = surface.GetTextSize("$" .. string.Comma(costval))
		local totalsize = costssize + pricesize
		
		if(costLbl ~= nil) then
			costLbl:SizeToContents()
			costLbl:SetPos(195 - totalsize/2, 160)
			if(costval == 0) then
				costLbl:SetColor(Color(125, 125, 125))
				priceLbl:ColorTo(Color(125,125,125), 0.5, 0)
			else
				costLbl:SetColor(Color(255, 255, 255))
				priceLbl:ColorTo(Color(83,230,63), 0.5, 0)
			end
			
			local costLblx, costLblxy = costLbl:GetPos()
			priceLbl:SetText("$" .. string.Comma(costval))
			priceLbl:SizeToContents()
			priceLbl:SetPos(costLblx + costssize, 160)
		end
		
	end)
	
end

vgui.Register("FA:Mix", PANEL, "DPanel")



-- FAMILIARS

local PANEL = {}
local famBtns = {}

function PANEL:Init()
	self:SetPos((ScrW()/2) -10, ScrH()/2 - mainBG_res_y/2 + 180)
	self:SetSize(420, 230)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end

	------------------------
	local dGrid = self:Add("DGrid")
	dGrid:SetPos(0, 0)
	dGrid:SetCols(5)
	dGrid:SetColWide(87)
	dGrid:SetRowHeight(102)
	
	local plyLvl = LocalPlayer():GetNWInt("falch_level")
	local activeBtn = nil
	
	--== LABELS ==--
	local famName = self:Add("DLabel")
	famName:SetText("Select A Familiar")
	famName:SetFont("FALCH_FamName")
	famName:SizeToContents()
	famName:SetColor(Color(151, 151, 151))
	famName:SetPos(0, 75)
	
	local famDescContainer = self:Add("DPanel")
	famDescContainer:SetPos(0, 110)
	famDescContainer:SetSize(300, 200)
	famDescContainer.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local famDesc = famDescContainer:Add("DLabel")
	famDesc:SetText("Familiars empower your alchemy, allowing you to enhance your potions or brew more efficiently!")
	famDesc:SetFont("FALCH_FamDesc")
	famDesc:SetSize(famDescContainer:GetSize())
	famDesc:SetAutoStretchVertical(true)
	famDesc:SetWrap(true)
	famDesc:Dock(TOP)
	famDesc:SetColor(Color(111, 111, 111))
	famDesc:SetPos(0,0)
	
	local famCost = famDescContainer:Add("DLabel")
	famCost:SetText("")
	famCost:SetFont("FALCH_FamCost")
	famCost:SizeToContents()
	famCost:SetColor(Color(111,111,111))
	famCost:Dock(TOP)
	--
	
	-- HIRE BUTTON
	local hireBtn = self:Add("DImageButton")
	hireBtn:SetImage("materials/fancyalchemy/ui/ui_hirebtn.png")
	hireBtn:SetSize(110, 50)
	hireBtn:SetPos(310, 80)
	hireBtn:SetAlpha(50)
	hireBtn:SetEnabled(false)
	--
	
	hireBtn.DoClick = function()
		if(activeBtn ~= nil) then
			local money = LocalPlayer():getDarkRPVar("money")
			if(money >= FANCYALCHEMY_FAMILIARS[activeBtn].cost) then
				hireBtn:AlphaTo(50, 0.5, 0)
				hireBtn:SetEnabled(false)
				
				net.Start("falch_addFamiliar")
					net.WriteEntity(LocalPlayer())
					net.WriteString(FANCYALCHEMY_FAMILIARS[activeBtn].tag)
					net.WriteFloat(FANCYALCHEMY_FAMILIARS[activeBtn].cost)
				net.SendToServer()
				chat.AddText(Color(255,255,255), "[Fancy Alchemy] ", Color(155, 216, 255), "You've hired the ".. FANCYALCHEMY_FAMILIARS[activeBtn].name .."!")
				famCost:SetText("Purchased")
				local soundtoplay = FANCYALCHEMY_FAMILIARS[activeBtn].sound
				LocalPlayer():EmitSound(soundtoplay)
			else
				chat.AddText(Color(255,255,255), "[Fancy Alchemy] ", Color(255, 125, 125), "You do not have enough money!")
			end
		end
	end
	
	-- [[   == END BUTTON ==     ]]--
	
	for k, v in ipairs(FANCYALCHEMY_FAMILIARS) do
		famBtns[k] = vgui.Create("DImageButton")
		local familiar = famBtns[k]
		familiar:SetSize(70, 70)
		familiar:SetText("")
		dGrid:AddItem(familiar)
		
		
		familiar.Paint = function(_, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 0))	
		end
		
		local sk = table.Copy(derma.GetDefaultSkin())
		sk.PaintTooltip = function() end
		derma.DefineSkin("FamiliarsTooltip", "Display Familiars Info", sk)
		-- [[ INGREDIENTS TOOLTIPS ]] --

			local tooltipPanel = vgui.Create("Panel")
			tooltipPanel:SetSize(135, 50)
			tooltipPanel:SetVisible(false)
			
			tooltipPanel.Paint = function( s, w, h ) 
				draw.RoundedBox(20, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
			end
			tooltipPanel.Think = function(self)
				self:GetParent():SetSkin("FamiliarsTooltip")
				self:GetParent():SetPos(gui.MouseX() -2, gui.MouseY() - 55)
			end
			
			if(plyLvl < v.reqlvl) then
				tooltipPanel:SetSize(155, 50)
				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText("LOCKED")
				dlabel:SetFont("FALCH_Tooltip")
				dlabel:SetColor(Color(255,85,85))
				dlabel:SizeToContents()
				dlabel:CenterHorizontal()

				local dlabel = vgui.Create( "DLabel", tooltipPanel )
				dlabel:SetText("Requires Lv." ..v.reqlvl)
				dlabel:SetFont("FALCH_TooltipCost")
				dlabel:SetColor(Color(125, 125, 125))
				dlabel:SizeToContents()
				dlabel:SetPos(0, 25)
				dlabel:CenterHorizontal()
			end
		-- [[ END TOOLTIPS ]] --
		
		-- Clicked
		familiar.DoClick = function()
			activeBtn = k
			hook.Call("FALCH_UpdateFamiliarInfo")
			LocalPlayer():EmitSound("falch_ui_deepclick")
		end
		
		-- Level check
		if(plyLvl >= v.reqlvl) then
			familiar:SetImage(v.icon)
			familiar:SetColor(Color(255,255,255,175))
		else
			familiar:SetImage( "materials/fancyalchemy/ui/ico_locked.png" )
			familiar:SetAlpha(63)
			familiar:SetSkin("IngredientsTooltip")
			familiar:SetTooltipPanel(tooltipPanel)
		end
		
		-- Border around boxes
		local icoBorderCol = {155, 155, 155}
		familiar.PaintOver = function(_, w, h)
			if not (_:IsHovered() or mdlHighlight) then 
				icoBorderCol = {155, 155, 155}
			else
				icoBorderCol = {255, 255, 255}
			end
			surface.SetDrawColor(icoBorderCol[1], icoBorderCol[2], icoBorderCol[3])
			if(LocalPlayer():GetNWBool(v.tag) == true) then
				surface.SetDrawColor(HSVToColor(RealTime()*50 % 360, 0.5, 1))
				surface.DrawOutlinedRect(1, 1, w-2, h-2)
			end
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	end
	
	-- This is just UI guck for polish
	hook.Add("FALCH_UpdateFamiliarInfo", "UpdateFamiliarInfo", function()
		if(activeBtn ~= nil) then
			for i = 1, #famBtns do
				if(plyLvl > FANCYALCHEMY_FAMILIARS[i].reqlvl) then
					famBtns[i]:SetColor(Color(255, 255, 255, 175))
				end
			end
			famBtns[activeBtn]:SetColor(Color(255, 255, 255, 255))
			local selectedFamiliar = FANCYALCHEMY_FAMILIARS[activeBtn]
			
			if(plyLvl >= FANCYALCHEMY_FAMILIARS[activeBtn].reqlvl) then
				famName:SetText(selectedFamiliar.name)
				famName:SetColor(Color(83,230,63))
				famName:SetAlpha(0)
				famName:AlphaTo(255, 0.5, 0)
				
				famDesc:SetText(selectedFamiliar.desc)
				famDesc:SetColor(Color(255,255,255))
				famDesc:SetAlpha(0)
				famDesc:AlphaTo(255, 0.5, 0)
				
				famCost:SetText("Costs $".. string.Comma(selectedFamiliar.cost))
				famCost:SetColor(Color(83,230,63))
				famCost:SetAlpha(0)
				famCost:AlphaTo(255, 0.5, 0)
				
				if(LocalPlayer():GetNWBool(selectedFamiliar.tag) == false) then
					hireBtn:SetEnabled(true)
					hireBtn:SetAlpha(50)
					hireBtn:AlphaTo(255, 0.5, 0)
				else
					hireBtn:SetEnabled(false)
					hireBtn:AlphaTo(50, 0.5, 0)
					famCost:SetText("Purchased")
				end
			else
				famName:SetText("???")
				famName:SetColor(Color(151,151,151))
				famName:SetAlpha(0)
				famName:AlphaTo(255, 0.5, 0)
				
				famDesc:SetText("You haven't unlocked this familiar yet.")
				famDesc:SetColor(Color(111, 111, 111))
				famDesc:SetAlpha(0)
				famDesc:AlphaTo(255, 0.5, 0)
				
				famCost:SetText("")
				
				hireBtn:AlphaTo(50, 0.5, 0)
				hireBtn:SetEnabled(false)
			end
		end
	end)
end

vgui.Register("FA:Familiars", PANEL, "DPanel")
