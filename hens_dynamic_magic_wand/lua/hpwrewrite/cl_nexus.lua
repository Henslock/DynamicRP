if SERVER then return end

// FONTS //

surface.CreateFont( "Nexus_BigNum", {
	font = "Century Gothic",
	extended = false,
	size = 108,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Nexus_SpellName", {
	font = "Century Gothic",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Nexus_Btn", {
	font = "Century Gothic",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Nexus_CostNum", {
	font = "Century Gothic",
	extended = false,
	size = 28,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
} )

//	==== //

local mutatioMat = Material("materials/hpwrewrite/sprites/mutatioIco.png", "smooth" )
local mutatioTestMat = Material("hpwrewrite/sprites/additiveMat")
local mutatioAura = Material("materials/hpwrewrite/sprites/auraglow_red.png", "smooth" )
local linebreak = Material("materials/hpwrewrite/sprites/linebreak.png", "smooth" )
local occultBG = Material("materials/hpwrewrite/sprites/bg_art.png", "smooth" )

local NEXUS_SPELLS = {
[1] = {"Speedom", 3},
[2] = {"Reducto", 3},
[3] = {"Expelliarmus", 3},
[4] = {"Impedimenta", 3},
[5] = {"Mostro", 3},
[6] = {"Avis", 3},
[7] = {"Green Sparks", 3},
[8] = {"Inflatus", 3},
[9] = {"Periculum", 3},
[10] = {"Purple Firecrackers", 3},
[11] = {"Red Sparks", 3},
[12] = {"Episkey", 3},
[13] = {"Lumos", 3},
[14] = {"Accio", 3},
[15] = {"Alarte Ascendare", 3},
[16] = {"Arresto Momentum", 3},
[17] = {"Carpe Retractum", 3},
[18] = {"Depulso", 3},
[19] = {"Flarus", 3},
[20] = {"Speedavec", 3},
[21] = {"Wingardium Leviosa", 3},
[22] = {"Legimmio", 3},
[23] = {"Protego", 3},
[24] = {"Propositum Charm", 3},
[25] = {"Punchek", 3},
[26] = {"Walkspeeden", 3},
[27] = {"Deprimo", 5},
[28] = {"Arrow-shooting spell", 5},
[29] = {"Dwisp", 5},
[30] = {"Immobulus", 5},
[31] = {"Rictusempra", 5},
[32] = {"Stupefy", 5},
[33] = {"Colloshoo", 5},
[34] = {"Colovaria", 5},
[35] = {"Obscuro", 5},
[36] = {"Unbreakable Charm", 5},
[37] = {"Vulnera Sanentur", 5},
[38] = {"Color lumos", 5},
[39] = {"Lumos Maxima", 5},
[40] = {"Lux Bulbus", 5},
[41] = {"Everte Statum", 5},
[42] = {"Acriea", 5},
[43] = {"Heyedillio", 5},
[44] = {"Hocus", 5},
[45] = {"Punchek Duo", 5},
[46] = {"Balloonico", 5},
[47] = {"Apparition", 20}
}

local NEXUS_SKINS = {
[1] = {"Dark Wand", "dark_wand", 15},
[2] = {"Fork", "fork", 15},
[3] = {"Hands", "hands", 15},
[4] = {"Mind Wand", "mind_wand", 15},
[5] = {"Soldering Iron", "soldering_iron", 15},
[6] = {"Demonic Wand", "demonic_wand", 15}
}

local width = 550
local height = 500

-- INITIAL PANEL --

local PANEL = {}

function PANEL:Init()
	
	local posx, posy = 0
	posx = (ScrW() / 2) - (width/2)
	posy = (ScrH() / 2) - (height/2)
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:SetDraggable(true)
	self:ShowCloseButton(false)
	self:SetTitle("")
	self:SetSize(width, height)
	self:SetPos(posx, posy + 40)
	self:SetAlpha(0)
	self:AlphaTo(255, 1, 0)
	self:MoveTo(posx, posy, 3, 0, 0.2)
	
	LocalPlayer():EmitSound("hpwrewrite/pageturn.mp3", 100, math.random(70, 120), 1)
	LocalPlayer():EmitSound("hpwrewrite/spells/lumos.wav", 100, math.random(50, 70), 1)
	
	self.Paint = function(self)
		draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 225))
	end
	
	self.PaintOver = function(_, w, h)
		surface.SetDrawColor(Color(225, 0, 0, 125), 1, 1)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	local bgsizeratio = (563 / 846)	// BG arts resolution
	local BG = self:Add("DImage")
	BG:SetSize(self:GetWide(), self:GetWide() / bgsizeratio)
	BG:SetMaterial(occultBG)
	BG:SetAlpha(0)
	BG:AlphaTo(5, 0.5, 1)
	
	self.SpellsPanel = vgui.Create("EnchantedNexus:Spells", self)
	
	-- Exit Button
	
	self.closeBtn = self:Add("DButton")
	self.closeBtn:SetPos(self:GetWide() - 30, 10)
	self.closeBtn:SetSize(15, 15)
	self.closeBtn:SetText("")
	self.closeBtn.HoverLerp = 0
	
	self.closeBtn.DoClick = function()
		self:Close()
	end
	
	self.closeBtn.Paint = function(s, w, h)
		if s:IsHovered() then
			s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
		else
			s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.1 )
		end
		draw.RoundedBox(2, 0, 0, w, h, Color(225 * s.HoverLerp , 0, 0, 255* s.HoverLerp))
	end
	
	self.closeBtn.PaintOver = function(_, w, h)
		surface.SetDrawColor(Color(225, 0, 0, 55), 1, 1)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	-- Currency Counter
	local mutatio = LocalPlayer():GetNWInt("hp_mutatio")
	
	self.mutatioNum = self:Add("DLabel")
	self.mutatioNum:SetFont("Nexus_BigNum")
	self.mutatioNum:SetText(mutatio)
	self.mutatioNum:SetPos(0, 10)
	self.mutatioNum:SetColor(Color(255,255,255))
	self.mutatioNum:SizeToContents()
	self.mutatioNum:CenterHorizontal()
	
	local lineBreakImg = self:Add("DImage")
	local w, h = 150, 100
	lineBreakImg:SetPos(0, 70 )
	lineBreakImg:SetSize(w, h)
	lineBreakImg:SetMaterial(linebreak)
	lineBreakImg:CenterHorizontal()
	
	// ANIMS
	
	local mutAura2 = self:Add("DImage")
	local w, h = 115, 115
	local x, y = self.mutatioNum:GetPos()
	mutAura2:SetPos(x - 110, y )
	mutAura2:SetSize(w, h)
	mutAura2.rot = 90
	mutAura2.Paint = function(_, w, h)
		mutAura2.rot = mutAura2.rot + FrameTime() *5
		surface.SetMaterial(mutatioAura)
		surface.SetDrawColor(255,255,255,155)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, mutAura2.rot)
	end
	
	local mutImg = self:Add("DImage")
	local w, h = 55, 55
	local x, y = self.mutatioNum:GetPos()
	mutImg:SetPos(x - 80, y + 30)
	mutImg:SetSize(w, h)
	mutImg.Paint = function(_, w, h)
		surface.SetMaterial(mutatioMat)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	
	local mutImgEffect = self:Add("DImage")
	mutImgEffect:SetPos(x - 80, y + 30)
	mutImgEffect:SetSize(w, h)
	mutImgEffect.rot = 90
	mutImgEffect.Paint = function(_, w, h)
		surface.SetMaterial(mutatioTestMat)
		mutImgEffect.rot = mutImgEffect.rot + FrameTime() *15
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, mutImgEffect.rot)
	end	
	
	local mutImgEffect2 = self:Add("DImage")
	mutImgEffect2:SetPos(x - 80, y + 30)
	mutImgEffect2:SetSize(w, h)
	mutImgEffect2.rot = 0
	mutImgEffect2.Paint = function(_, w, h)
		surface.SetMaterial(mutatioTestMat)
		mutImgEffect2.rot = mutImgEffect2.rot - FrameTime() *30
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, mutImgEffect2.rot)
	end
	
end

vgui.Register("EnchantedNexus:Menu", PANEL, "DFrame")

net.Receive("hpwr_nexusmenu_open", function()
	vgui.Create("EnchantedNexus:Menu")
end)

// SPELLS PANEL 

local PANEL = {}

function PANEL:Init()
	local sx, sy = self:GetParent():GetSize()
	self:SetSize(sx*0.95, sy*0.70)
	self:SetPos(0, sy*0.3 - 10)
	self:CenterHorizontal()
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	
	self.PaintOver = function(_, w, h)
		surface.SetDrawColor(Color(255, 255, 255, 25), 1, 1)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	
	--Modify Scroll Bar--
	
	local sbar = self:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, (w/2), h, Color(0, 0, 0, 225))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(20, 1, 0, (w/4), h, Color(255, 255, 255, 255))
	end
	
	-------------------------
	--CREATE SPELLS--
	for k, v in ipairs(NEXUS_SPELLS) do
		
		local plyHasSpell = HpwRewrite:PlayerHasLearnableSpell(LocalPlayer(), v[1]) or HpwRewrite:PlayerHasSpell(LocalPlayer(), v[1])

		--Panel container
		local Dpanel = vgui.Create( "DPanel", self )
		Dpanel.HoverLerp = 0
		Dpanel:SetSize(0, 85)
		Dpanel:Dock(TOP)
		Dpanel:DockMargin( 10, 10, 10, 0 ) 
		Dpanel.Paint = function(s, w, h)
			if s:IsHovered()  then
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 1 )
			else
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 0 )
			end
		
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150* Dpanel.HoverLerp))
		end
	
		-- Spell Icon
		local spellIco = vgui.Create( "DImage" , Dpanel ) -- SpawnIcon
		local icoMat = HpwRewrite:GetSpellIcon(v[1])
		spellIco:SetSize(75, 75)
		if(plyHasSpell) then spellIco:SetAlpha(25) end
		spellIco:Dock(LEFT)
		if(icoMat ~= nil) then
			spellIco:SetImage( icoMat:GetName() )
		end
		spellIco.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		local spellName = vgui.Create("DLabel", Dpanel)
		spellName:SetText(string.upper(v[1]))
		spellName:SetFont("Nexus_SpellName")
		if(plyHasSpell) then spellName:SetAlpha(25) end
		spellName:SizeToContents()
		spellName:DockMargin(20, 0, 0, 0)
		spellName:Dock(LEFT)
		
		local buyBtn = vgui.Create("DButton", Dpanel)
		buyBtn:SetSize(100, 45)
		buyBtn:SetText("")
		buyBtn:DockMargin(5, 20, 10, 20)
		buyBtn:Dock(RIGHT)
		
		if(plyHasSpell) then buyBtn:SetEnabled(false) end
		buyBtn.HoverLerp = 0
		buyBtn.Paint = function(_, w, h)
			if buyBtn:IsHovered() then
				buyBtn.HoverLerp = Lerp( FrameTime() * 5, buyBtn.HoverLerp, 1 )
			else
				buyBtn.HoverLerp = Lerp( FrameTime() * 5, buyBtn.HoverLerp, 0.1)
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 225 * buyBtn.HoverLerp))
		end
		
		buyBtn.PaintOver = function(_, w, h)
			if(plyHasSpell) then
				surface.SetDrawColor(Color(255, 255, 255, 25), 1, 1)
			else
				surface.SetDrawColor(Color(255, 255 * buyBtn.HoverLerp, 255 * buyBtn.HoverLerp, 125 * buyBtn.HoverLerp), 1, 1)
			end
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		buyBtn.OnCursorEntered = function(self)
			LocalPlayer():EmitSound("hpwrewrite/enterbtn.wav")
		end
		
		buyBtn.DoClick = function()
			LocalPlayer():EmitSound("hpwrewrite/clickbtn.wav")
			
			local mutatio = LocalPlayer():GetNWInt("hp_mutatio")
			if(mutatio >= v[2]) then
				LocalPlayer():EmitSound("ambient/levels/canals/windchime4.wav", 100, math.random(70, 80), 1)
				LocalPlayer():EmitSound("ambient/levels/canals/windchime4.wav", 100, math.random(110, 120), 1)
				LocalPlayer():EmitSound("physics/metal/paintcan_impact_soft1.wav", 100, math.random(110, 120), 1)
				
				chat.AddText(Color(238, 166, 252), "Your Mutatio infuses the spell book, creating ", Color(255, 255, 255), "[" .. v[1] .. "]")
				
				self:GetParent():Close()
				net.Start("hpwr_nexusmenu_buyspell")
					net.WriteFloat(v[2])
					net.WriteString(v[1])
				net.SendToServer()
			else
				chat.AddText(Color(255, 55, 55), "[ You do not have enough Mutatio! ]")
				LocalPlayer():EmitSound("doors/handle_pushbar_locked1.wav", 100, math.random(70, 80), 1)
			end
		end
		
		local buyBtnLbl = vgui.Create("DLabel", buyBtn)
		buyBtnLbl:SetText("Acquire")
		if(plyHasSpell) then 
			buyBtnLbl:SetText("Owned") 
			buyBtnLbl:SetAlpha(25)
		end
		buyBtnLbl:SetFont("Nexus_Btn")
		buyBtnLbl:SizeToContents()
		buyBtnLbl:Center()
		
		// COST
		
		// Anim icon
		local costIcoPanel = vgui.Create("DPanel", Dpanel)
		costIcoPanel:SetSize(50,0)
		costIcoPanel:Dock(RIGHT)
		costIcoPanel:SetAlpha(255)
		costIcoPanel.Paint = function(_, w, h)

			surface.SetDrawColor(255,255,255,0)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		
		local mutImg = vgui.Create("DImage", costIcoPanel)
		local w, h = 25, 25
		mutImg:SetSize(w, h)
		mutImg:SetPos(0, 30)
		mutImg:CenterHorizontal()
		mutImg.Paint = function(_, w, h)
			surface.SetMaterial(mutatioMat)
			if(plyHasSpell) then
				surface.SetDrawColor(255,255,255,55)
			else
				surface.SetDrawColor(255,255,255,255)
			end
			surface.DrawTexturedRect(0, 0, w, h)
		end
		
		local mutAura2 =  vgui.Create("DImage", costIcoPanel)
		local w, h = 55, 55
		mutAura2:SetPos(0, 15)
		mutAura2:SetSize(w, h)
		mutAura2:CenterHorizontal()
		mutAura2.rot = 90
		mutAura2.Paint = function(_, w, h)
			mutAura2.rot = mutAura2.rot + FrameTime() *5
			surface.SetMaterial(mutatioAura)
			if(plyHasSpell) then
				surface.SetDrawColor(255,255,255,25)
			else
				surface.SetDrawColor(255,255,255,155)
			end
			surface.DrawTexturedRectRotated(w/2, h/2, w, h, mutAura2.rot)
		end

		
		local costLbl = vgui.Create("DLabel", Dpanel)
		costLbl:SetText(v[2])
		costLbl:SetFont("Nexus_CostNum")
		if(plyHasSpell) then costLbl:SetAlpha(25) end
		costLbl:SizeToContents()
		costLbl:DockMargin(0,0,10,0)
		costLbl:Dock(RIGHT)
		
		
	end

	-------------------------
	--CREATE SKINS--
	for k, v in ipairs(NEXUS_SKINS) do
	
	local plyHasSpell = HpwRewrite:PlayerHasLearnableSpell(LocalPlayer(), v[1]) or HpwRewrite:PlayerHasSpell(LocalPlayer(), v[1])

		--Panel container
		local Dpanel = vgui.Create( "DPanel", self )
		Dpanel.HoverLerp = 0
		Dpanel:SetSize(0, 85)
		Dpanel:Dock(TOP)
		Dpanel:DockMargin( 10, 10, 10, 0 ) 
		Dpanel.Paint = function(s, w, h)
			if s:IsHovered()  then
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 1 )
			else
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 0 )
			end
		
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150* Dpanel.HoverLerp))
		end
	
		-- Spell Icon
		local spellIco = vgui.Create( "DImage" , Dpanel ) -- SpawnIcon
		local icoMat = Material("vgui/entities/entity_hpwand_spell_" .. v[2])
		spellIco:SetSize(75, 75)
		if(plyHasSpell) then spellIco:SetAlpha(25) end
		spellIco:Dock(LEFT)
		if(icoMat ~= nil) then
			spellIco:SetImage( icoMat:GetName() )
		end
		spellIco.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		local spellName = vgui.Create("DLabel", Dpanel)
		spellName:SetText(string.upper(v[1]))
		spellName:SetFont("Nexus_SpellName")
		if(plyHasSpell) then spellName:SetAlpha(25) end
		spellName:SizeToContents()
		spellName:DockMargin(20, 0, 0, 0)
		spellName:Dock(LEFT)
		
		local buyBtn = vgui.Create("DButton", Dpanel)
		buyBtn:SetSize(100, 45)
		buyBtn:SetText("")
		buyBtn:DockMargin(5, 20, 10, 20)
		buyBtn:Dock(RIGHT)
		
		if(plyHasSpell) then buyBtn:SetEnabled(false) end
		buyBtn.HoverLerp = 0
		buyBtn.Paint = function(_, w, h)
			if buyBtn:IsHovered() then
				buyBtn.HoverLerp = Lerp( FrameTime() * 5, buyBtn.HoverLerp, 1 )
			else
				buyBtn.HoverLerp = Lerp( FrameTime() * 5, buyBtn.HoverLerp, 0.1)
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 225 * buyBtn.HoverLerp))
		end
		
		buyBtn.PaintOver = function(_, w, h)
			if(plyHasSpell) then
				surface.SetDrawColor(Color(255, 255, 255, 25), 1, 1)
			else
				surface.SetDrawColor(Color(255, 255 * buyBtn.HoverLerp, 255 * buyBtn.HoverLerp, 125 * buyBtn.HoverLerp), 1, 1)
			end
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		buyBtn.OnCursorEntered = function(self)
			LocalPlayer():EmitSound("hpwrewrite/enterbtn.wav")
		end
		
		buyBtn.DoClick = function()
			LocalPlayer():EmitSound("hpwrewrite/clickbtn.wav")
			
			local mutatio = LocalPlayer():GetNWInt("hp_mutatio")
			if(mutatio >= v[3]) then
				LocalPlayer():EmitSound("ambient/levels/canals/windchime4.wav", 100, math.random(70, 80), 1)
				LocalPlayer():EmitSound("ambient/levels/canals/windchime4.wav", 100, math.random(110, 120), 1)
				LocalPlayer():EmitSound("physics/metal/paintcan_impact_soft1.wav", 100, math.random(110, 120), 1)
				
				chat.AddText(Color(238, 166, 252), "Your Mutatio infuses your wand, granting you ", Color(255, 255, 255), "[" .. v[1] .. "]")
				
				self:GetParent():Close()
				net.Start("hpwr_nexusmenu_buyspell")
					net.WriteFloat(v[3])
					net.WriteString(v[1])
				net.SendToServer()
			else
				chat.AddText(Color(255, 55, 55), "[ You do not have enough Mutatio! ]")
				LocalPlayer():EmitSound("doors/handle_pushbar_locked1.wav", 100, math.random(70, 80), 1)
			end
		end
		
		local buyBtnLbl = vgui.Create("DLabel", buyBtn)
		buyBtnLbl:SetText("Acquire")
		if(plyHasSpell) then 
			buyBtnLbl:SetText("Owned") 
			buyBtnLbl:SetAlpha(25)
		end
		buyBtnLbl:SetFont("Nexus_Btn")
		buyBtnLbl:SizeToContents()
		buyBtnLbl:Center()
		
		// COST
		
		// Anim icon
		local costIcoPanel = vgui.Create("DPanel", Dpanel)
		costIcoPanel:SetSize(50,0)
		costIcoPanel:Dock(RIGHT)
		costIcoPanel:SetAlpha(255)
		costIcoPanel.Paint = function(_, w, h)

			surface.SetDrawColor(255,255,255,0)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		
		local mutImg = vgui.Create("DImage", costIcoPanel)
		local w, h = 25, 25
		mutImg:SetSize(w, h)
		mutImg:SetPos(0, 30)
		mutImg:CenterHorizontal()
		mutImg.Paint = function(_, w, h)
			surface.SetMaterial(mutatioMat)
			if(plyHasSpell) then
				surface.SetDrawColor(255,255,255,55)
			else
				surface.SetDrawColor(255,255,255,255)
			end
			surface.DrawTexturedRect(0, 0, w, h)
		end
		
		local mutAura2 =  vgui.Create("DImage", costIcoPanel)
		local w, h = 55, 55
		mutAura2:SetPos(0, 15)
		mutAura2:SetSize(w, h)
		mutAura2:CenterHorizontal()
		mutAura2.rot = 90
		mutAura2.Paint = function(_, w, h)
			mutAura2.rot = mutAura2.rot + FrameTime() *5
			surface.SetMaterial(mutatioAura)
			if(plyHasSpell) then
				surface.SetDrawColor(255,255,255,25)
			else
				surface.SetDrawColor(255,255,255,155)
			end
			surface.DrawTexturedRectRotated(w/2, h/2, w, h, mutAura2.rot)
		end

		
		local costLbl = vgui.Create("DLabel", Dpanel)
		costLbl:SetText(v[3])
		costLbl:SetFont("Nexus_CostNum")
		if(plyHasSpell) then costLbl:SetAlpha(25) end
		costLbl:SizeToContents()
		costLbl:DockMargin(0,0,10,0)
		costLbl:Dock(RIGHT)
		
	end
end

vgui.Register("EnchantedNexus:Spells", PANEL, "DScrollPanel")