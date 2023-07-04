include("craftsmanship/crft_fontgen.lua")

if SERVER then return end

--INITIAL PANEL--
local PANEL = {}
local splashIndex = nil
local splashTab = nil

local auramat = Material("materials/UI/crafting/auraglow_2.png", "smooth" )

local matBlurScreen = Material( "pp/blurscreen" )

local CRFT_TYPE = {
[1] = CRAFTING_FURNITURE_TBL,
[2] = CRAFTING_WEAPONS_TBL,
[3] = CRAFTING_MISC_TBL
}

function Derma_DrawBackgroundBlurInside( panel )
        local x, y = panel:LocalToScreen( 0, 0 )
 
        surface.SetMaterial( matBlurScreen )
        surface.SetDrawColor( 255, 255, 255, 255 )
 
        for i=0.33, 1, 0.33 do
                matBlurScreen:SetFloat( "$blur", 5 * i ) -- Increase number 5 for more blur
                matBlurScreen:Recompute()
                if ( render ) then render.UpdateScreenEffectTexture() end
                surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
        end
 
        -- The line below gives the background a dark tint
        surface.SetDrawColor( 10, 10, 10, 150 )
        surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
end

function PANEL:Init()
	
	if splashIndex == nil then self:Remove() return end
	if splashTab == nil then self:Remove() return end
	
	local tbl = CRFT_TYPE[splashTab]
	local active_selection = tbl[splashIndex]
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:Dock(FILL)
	self:Center()
	self:SetDraggable(false)
	self:SetTitle("")
	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:ShowCloseButton(true)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3, 0)
	
	LocalPlayer():EmitSound( "crft_pickup", 100, 80, 2, CHAN_AUTO )
	
	self.Paint = function(self, w, h)
		Derma_DrawBackgroundBlurInside(self)
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 245))	
	end
	
	
	-- Pretty Glow
	
	local glowImg = self:Add("DImage")
	local w, h = 750, 750
	glowImg:SetPos(ScrW()/2 - w/2, ScrH()/2 - h/2)
	glowImg:SetSize(w, h)
	glowImg.rot = 0
	glowImg.Paint = function(_, w, h)
		glowImg.rot = glowImg.rot + FrameTime() *10
		surface.SetMaterial(auramat)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, glowImg.rot)
	end
	
	local glowImg2 = self:Add("DImage")
	local w, h = 650, 650
	glowImg2:SetPos(ScrW()/2 - w/2, ScrH()/2 - h/2)
	glowImg2:SetSize(w, h)
	glowImg2.rot = 0
	glowImg2.Paint = function(_, w, h)
		glowImg2.rot = glowImg2.rot - FrameTime() *10
		surface.SetMaterial(auramat)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, glowImg2.rot)
	end
	
	-- Model Display
	
	local dfurniture = self:Add("DModelPanel")
	local w, h = 450, 450
	dfurniture:SetPos(ScrW()/2, ScrH()/2)
	dfurniture:SetSize(0, 0)
	dfurniture:SetModel(active_selection.model)
	dfurniture:SizeTo(w, h, 1, 0.25, 0.25)
	dfurniture:MoveTo(ScrW()/2  - w/2, ScrH()/2 - h/2, 1, 0.25, 0.25)
	dfurniture:SetCamPos( active_selection.viewvec )
	
	dfurniture.speedmult = 1750
	dfurniture.angrot = 0
	
	if(active_selection.viewoffset ~= nil) then
		dfurniture:SetLookAt(active_selection.viewoffset)
	else
		dfurniture:SetLookAt(Vector(0,0,0))
	end
	
	function dfurniture:LayoutEntity(ent)
		local ang = Angle(0, dfurniture.angrot, 0)
		dfurniture.speedmult = Lerp( FrameTime()*3, dfurniture.speedmult, 35 )
		dfurniture.angrot = dfurniture.angrot + FrameTime()*dfurniture.speedmult
		ent:SetAngles(ang)
		
	end
	--
	
	-- Name
	
	local lbl = self:Add("DLabel")
	lbl:SetFont("CT_SplashFontLarge")
	
	local grammarcheck = string.sub(active_selection.name, 1, 1)
	if(table.HasValue({"a", "e", "i", "o", "u"}, string.lower(grammarcheck)) == true) then
		lbl:SetText("You crafted an ".. active_selection.name .."!")
	else
		lbl:SetText("You crafted a ".. active_selection.name .."!")
	end
	lbl:SizeToContents()
	lbl:SetPos(0, 100)
	lbl:SetAlpha(0)
	lbl:CenterHorizontal()
	local x,y = lbl:GetPos()
	
	lbl:MoveTo(x, 200, 1, 0, 0.25)
	lbl:AlphaTo(255, 1, 0)
	
	
	-- Close Button
	
	local closebtn = self:Add("DButton")
	local w, h = 180, 80
	closebtn:SetText("")
	closebtn:SetSize(w, h)
	closebtn:SetPos(ScrW()/2 - w/2, ScrH()/2 + 305)
	closebtn.Paint = function(_, w, h)
		surface.SetDrawColor(62, 181, 107)
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
	end
	
	function closebtn:DoClick()
		if(splashTab == 1) then
			hook.Call("UpdateCrftUI", GAMEMODE, 0)
		else
			hook.Call("UpdateCrftUI", GAMEMODE, 1)
		end
		hook.Call("Crft_CloseSplashScreen")
		self:GetParent():Close()
	end
	
	local closebtnlbl = closebtn:Add("DLabel")
	closebtnlbl:SetText("O K")
	closebtn:SetColor(Color(255, 255, 255))
	closebtnlbl:SetFont("CT_SplashFontBtn")
	closebtnlbl:SizeToContents()
	closebtnlbl:Center()
	
	--
	
	local TIMEANIMDELAY = 1
	
	timer.Simple(TIMEANIMDELAY, function()
	
		if self:IsValid() == false then return end
		LocalPlayer():EmitSound( "crft_successfulcraft", 100, 80, 2, CHAN_AUTO )
		
	end)	
	
		-- STATS --
	
	local plymoney = self:Add("DLabel")
	money = LocalPlayer():getDarkRPVar("money")
	plymoney:SetText("$".. string.Comma(money))
	plymoney:SetColor(Color(84, 214, 85))
	plymoney:SetFont("CT_SplashFontRegular")
	plymoney:SizeToContents()
	local w, h = plymoney:GetSize()
	plymoney:SetPos(ScrW()/2 - w - 150, ScrH()/2 + 320)
	plymoney:SetAlpha(0)
	plymoney:AlphaTo(255, 0.5, 0)
	
	local newmoney = money
	
	timer.Simple(TIMEANIMDELAY, function()
		
		if self:IsValid() == false then return end
	
		function plymoney:Think()
			if(splashTab == 1) then
				newmoney = Lerp( FrameTime() * 5, newmoney, money + active_selection.price)
			else
				newmoney = Lerp( FrameTime() * 5, newmoney, money - active_selection.price)
			end
			plymoney:SetText("$".. string.Comma(math.Round(newmoney, 0)))
			plymoney:SizeToContents()
		end
	end)
	
	-- MONEY GAIN
	timer.Simple(TIMEANIMDELAY, function()
		
		if self:IsValid() == false then return end
		local plymoneychange = self:Add("DLabel")
		if(splashTab == 1) then
			plymoneychange:SetText("+$"..active_selection.price)
			plymoneychange:SetColor(Color(164, 254, 115))
		else
			plymoneychange:SetText("-$"..active_selection.price)
			plymoneychange:SetColor(Color(239, 81, 81))
		end
		plymoneychange:SetFont("CT_SplashFontRegular")
		plymoneychange:SizeToContents()
		local x, y = plymoney:GetPos()
		plymoneychange:SetPos(x, y - 75)
		local x, y = plymoneychange:GetPos()
		plymoneychange:MoveTo(x, y - 50, 1.25, 0, 0.35)
		plymoneychange:AlphaTo(0, 0.75, 1)
	end)
	
	-- XP GAIN
	
	local xpbar = self:Add("DProgress")
	xpbar:SetSize(300, 40)
	local w, h = xpbar:GetSize()
	xpbar:SetPos(ScrW()/2 - w + 430, ScrH()/2 + 332)
	
	local plylvl = LocalPlayer():GetNWInt("crft_level")
	local plyxp = LocalPlayer():GetNWInt("crft_experience")
	local xpfraction = 0
	local newxpfraction = 0
	if(CRFT_PRESTIGE_ENABLED == false) and (plylvl >= CRAFTING_MAX_LEVEL) then
		xpfraction = 1
		newxpfraction = 1
	else
		xpfraction = plyxp / CRAFTSMANSHIP_LEVELS[plylvl][1]
		newxpfraction = (plyxp + active_selection.xp) / CRAFTSMANSHIP_LEVELS[plylvl][1]
	end
	
	if xpfraction == nil or newxpfraction == nil then
		xpfraction = 0
		newxpfraction = 0
	end
	

	xpbar:SetFraction(xpfraction)
	
	xpbar.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 30, 50, 125))
		draw.RoundedBox(0, 0, 0, w*s:GetFraction(), h, Color(168, 119, 234, 255))
	end
	
	xpbar.lerpxp = xpbar:GetFraction()
	self.LevelUp = false
	
	if(CRFT_PRESTIGE_ENABLED == false) and (plylvl >= CRAFTING_MAX_LEVEL) then
	else
		function xpbar:Think()
			timer.Simple(TIMEANIMDELAY, function()
				if self:IsValid() == false then return end
				
				xpbar.lerpxp = Lerp( FrameTime() * 2, xpbar.lerpxp, newxpfraction)
				xpbar:SetFraction(xpbar.lerpxp)
			end)
			
			if xpbar.lerpxp >= 1.0 then
				plylvl = LocalPlayer():GetNWInt("crft_level")
				plyxp = LocalPlayer():GetNWInt("crft_experience")
				newxpfraction = (plyxp) / CRAFTSMANSHIP_LEVELS[plylvl][1]
				xpbar.lerpxp = Lerp( FrameTime() * 2, xpbar.lerpxp, newxpfraction)
				xpbar:SetFraction(newxpfraction)
			end
		end
	end
	
	local xplabel = xpbar:Add("DLabel")
	if(CRFT_PRESTIGE_ENABLED == false) and (plylvl >= CRAFTING_MAX_LEVEL) then
		xplabel:SetText("MAX")
	else
		xplabel:SetText(plyxp .."/".. CRAFTSMANSHIP_LEVELS[plylvl][1])
	end
	xplabel:SetFont("CT_StatFont")
	xplabel:SetColor(Color(255, 190, 255, 255))
	xplabel:SizeToContents()
	xplabel:Center()
	
	if(CRFT_PRESTIGE_ENABLED == false) and (plylvl >= CRAFTING_MAX_LEVEL) then
	else
		timer.Simple(TIMEANIMDELAY, function()
			if self:IsValid() == false then return end
			
			plylvl = LocalPlayer():GetNWInt("crft_level")
			plyxp = LocalPlayer():GetNWInt("crft_experience")
			xplabel:SetText(plyxp .."/".. CRAFTSMANSHIP_LEVELS[plylvl][1])
			xplabel:SizeToContents()
			xplabel:Center()
		end)
	
		timer.Simple(TIMEANIMDELAY, function()
			
			if self:IsValid() == false then return end
			
			local xpinc = self:Add("DLabel")
			xpinc:SetText("+"..active_selection.xp)
			xpinc:SetColor(Color(188, 139, 254))
			xpinc:SetFont("CT_SplashFontRegular")
			xpinc:SizeToContents()
			local x, y = xpbar:GetPos()
			xpinc:SetPos(x, y - 75 - 12)
			local x, y = xpinc:GetPos()
			xpinc:MoveTo(x, y - 50, 1.25, 0, 0.35)
			xpinc:AlphaTo(0, 0.75, 1)
		end)
	end
	
end

vgui.Register("CraftingTable:SplashScreen", PANEL, "DFrame")

hook.Add("RegisterSplashScreenIndex", "RSSI", function(index, activetab)
	splashIndex = index
	splashTab = activetab
end)
