include("craftsmanship/crft_fontgen.lua")

if SERVER then

util.AddNetworkString("craftingtable_open")

end

if SERVER then return end

local bgw, bgh

local crft_UI_BG =  ( "materials/UI/crafting/mainPanelBG.png" )
local crft_furni_ICO = Material( "UI/crafting/icoFurniture.png", "smooth" )
local crft_wep_ICO = Material( "UI/crafting/icoWeapons.png", "smooth" )
local crft_misc_ICO = Material( "UI/crafting/icoMisc.png", "smooth" )

local TABS = {
FURNITURE = 1,
WEAPONS = 2,
MISC = 3
}

local activeTab = TABS.FURNITURE
local myPanel = nil

local matBlurScreen = Material( "pp/blurscreen" )
 
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

--INITIAL PANEL--
local PANEL = {}

function PANEL:Init()
	--Init look
	bgw = 1280
	bgh = 900
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:Dock(FILL)
	self:Center()
	self:SetDraggable(false)
	self:SetTitle("")
	self:SetSize(bgw, bgh)
	self:Center()
	self:ShowCloseButton(true)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3, 0)
	
	if(LocalPlayer():GetNWInt("crft_level") == 0) then
		self:Close()
		net.Start("craftingInitData")
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
		return
	end
	
	LocalPlayer():EmitSound( "inv_open", 100, 80, 1, CHAN_AUTO )
	
	local blur = Material("pp/blurscreen")
	self.Paint = function(self, w, h)
		Derma_DrawBackgroundBlurInside(self)
		draw.RoundedBox(10, (ScrW() / 2) - (bgw/2) , (ScrH() / 2) - (bgh/2), bgw, bgh, Color(0, 0, 0, 0))	
	end
	

	
	-- Draw Panel BG
	self.invPanelBG = self:Add("DImage")
	self.invPanelBG:SetPos(ScrW() / 2 - bgw*0.5, ScrH()/2 - bgh*0.5)
	self.invPanelBG:SetSize(bgw, bgh)
	self.invPanelBG:SetImage( crft_UI_BG )
	
	-- User Data
	local userName = LocalPlayer():GetName()
	if(string.len(userName) > 28) then
		userName = string.sub(userName, 0, 28)
		userName = userName.. ".."
	end
	self.invUserName = self:Add("DLabel")
	self.invUserName:SetFont("CT_StatFont")
	self.invUserName:SetText(userName)
	self.invUserName:SetPos((ScrW() / 2) - (bgw/2) + 40, ScrH()/2 - bgh*0.5 + 120)
	self.invUserName:SizeToContents()
	self.invUserName:SetColor(Color(255,255,255))
	
	self.invUserLevel = self:Add("DLabel")
	self.invUserLevel:SetFont("CT_StatFont")
	self.invUserLevel:SetText("Lv. "..LocalPlayer():GetNWInt("crft_level"))
	self.invUserLevel:SetPos((ScrW() / 2) - (bgw/2) + 40, ScrH()/2 - bgh*0.5 + 150)
	self.invUserLevel:SizeToContents()
	self.invUserLevel:SetColor(Color(255,255,255))
	
	self.closebtn = vgui.Create("CraftingTable:InventoryClosingButton", self)
	self.craftselection = vgui.Create("CraftingTable:CraftSelection", self)
	self.craftingpnl = vgui.Create("CraftingTable:CraftingPanel", self)
	self.craftingxpbar = vgui.Create("CraftingTable:XPBar", self)
	
	hook.Add("UpdateCrftNewDisplay", "Update Level Display", function()
		self.invUserLevel:SetText("Lv. "..LocalPlayer():GetNWInt("crft_level"))
	end)
	
end

vgui.Register("CraftingTable:MainMenu", PANEL, "DFrame")

net.Receive("craftingtable_open", function()
	if(IsValid(myPanel)) then return end
	myPanel = vgui.Create("CraftingTable:MainMenu")
end)

-- CLOSING BUTTON
local PANEL = {}

function PANEL:Init()
	self:SetPos((ScrW() / 2) + (bgw/2) - 45, ScrH()/2 - bgh*0.5 + 80)
	self:SetSize(16, 16)
	self:SetText("")
	self:SetImage("UI/inventory/invCloseBtn.png")
	
	self.DoClick = function (self)
			LocalPlayer():EmitSound( "inv_close", 100, 80, 1, CHAN_AUTO )
			self:GetParent():Close()
		end
end

vgui.Register("CraftingTable:InventoryClosingButton", PANEL, "DImageButton")

-- XP BAR

local PANEL = {}

function PANEL:Init()
	self:SetPos((ScrW() / 2) - (bgw/2) + 40, ScrH()/2 - (bgh/2) + 180)
	self:SetSize(155, 20)
	self:SetText("")
	
	local plylvl = LocalPlayer():GetNWInt("crft_level")
	local plyxp = LocalPlayer():GetNWInt("crft_experience")
	self.ratio = plyxp / CRAFTSMANSHIP_LEVELS[plylvl][1]
	self.Paint = function(_, w, h)
		-- BG Bar
		surface.SetDrawColor(0,0,0,225)
		surface.DrawRect(0,0,w,h)
		-- XP Bar
		
		if(plylvl >= CRAFTING_MAX_LEVEL) and (CRFT_PRESTIGE_ENABLED == false) then
			local col = Color(168, 109 + (30 * (math.cos(RealTime()*2)) ), 214 + (30 * (math.sin(RealTime()*2)) ) )
			surface.SetDrawColor(col)
			surface.DrawRect(3, 3, (w-6) , h-6)
		else
			surface.SetDrawColor(168, 119, 234,225)
			surface.DrawRect(3, 3, (w-6) * self.ratio, h-6)
		end
	end
	
	hook.Add("UpdateCrftXPBar", "UpdateMainGUIXPBar", function()
		plylvl = LocalPlayer():GetNWInt("crft_level")
		plyxp = LocalPlayer():GetNWInt("crft_experience")
		self.ratio = plyxp / CRAFTSMANSHIP_LEVELS[plylvl][1]
	end)
end

vgui.Register("CraftingTable:XPBar", PANEL, "DPanel")


-- Material Check --

function CheckPlayerMats(mats)
	for k, v in pairs(mats) do
		if(LocalPlayer():GetNWInt(k) < v) then
			return false
		end
	end
	
	return true
end


-- CRAFT SELECTION

local PANEL = {}
local active_selection = {}
local active_selection_index = 0
local crft_btn = {
	[TABS.FURNITURE] = {},
	[TABS.WEAPONS] = {},
	[TABS.MISC] = {}
	} or crft_btn

function PANEL:Init()
	
	crft_btn = {
		[TABS.FURNITURE] = {},
		[TABS.WEAPONS] = {},
		[TABS.MISC] = {}
	}
	
	for k, v in pairs(crft_btn) do
		for i, j in pairs(v) do
			if(j:IsValid()) then
				j:Remove()
			end
		end
	end
	
	local x, y = 450, 600
	self:SetPos((ScrW() / 2) - (bgw/2) + 35, ScrH()/2 - bgh*0.5 + 245)
	self:SetSize(x, y)
	self:SetText("")
	
	self.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))	
	end

	local furnitureSheet = self:Add("DScrollPanel")
	furnitureSheet:SetSize(x, y)
	furnitureSheet.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	furnitureSheet.id = 0
	
	--Modify Scroll Bar--
	
	local sbar = furnitureSheet:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(0, 8, 0, (w/2), h, Color(0, 0, 0, 125))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(0, 9, 0, (w/2), h, Color(155, 155, 155, 255))
	end
	
	--UPDATE the buttons if the player levels up
	hook.Add("UpdateCrftNewDisplay", "UpdateButtonsUponLeveling", function()
		local plylvl = LocalPlayer():GetNWInt("crft_level")
		
		for i, j in ipairs(CRAFTING_FURNITURE_TBL) do
			if(plylvl >= j.reqlevel) then
				crft_btn[TABS.FURNITURE][i]:SetEnabled(true)
				crft_btn[TABS.FURNITURE][i].dmodelpanel:SetColor(Color(255, 255, 255))
				crft_btn[TABS.FURNITURE][i].dlevel:SetColor(Color(255, 255, 255))
				crft_btn[TABS.FURNITURE][i].dfurniturelabel:SetColor(Color(255, 255, 255))
				crft_btn[TABS.FURNITURE][i].dpricelabel:SetColor(Color(164, 254, 115))
				crft_btn[TABS.FURNITURE][i].dxplabel:SetColor(Color(188, 139, 254))
				crft_btn[TABS.FURNITURE][i].isClickable = true
			end
		end

		for i, j in ipairs(CRAFTING_WEAPONS_TBL) do
			if(plylvl >= j.reqlevel) then
				crft_btn[TABS.WEAPONS][i]:SetEnabled(true)
				crft_btn[TABS.WEAPONS][i].dmodelpanel:SetColor(Color(255, 255, 255))
				crft_btn[TABS.WEAPONS][i].dlevel:SetColor(Color(255, 255, 255))
				if(crft_btn[TABS.WEAPONS][i].dfurniturelabel ~= nil) then
				crft_btn[TABS.WEAPONS][i].dfurniturelabel:SetColor(Color(255, 255, 255))
				end
				crft_btn[TABS.WEAPONS][i].dpricelabel:SetColor(Color(164, 254, 115))
				crft_btn[TABS.WEAPONS][i].dxplabel:SetColor(Color(188, 139, 254))
				crft_btn[TABS.WEAPONS][i].isClickable = true
			end
		end
		
		for i, j in ipairs(CRAFTING_MISC_TBL) do
			if(crft_btn[TABS.MISC][i] == nil) then return end
			if(plylvl >= j.reqlevel) then
				crft_btn[TABS.MISC][i]:SetEnabled(true)
				crft_btn[TABS.MISC][i].dmodelpanel:SetColor(Color(255, 255, 255))
				crft_btn[TABS.MISC][i].dlevel:SetColor(Color(255, 255, 255))
				if(crft_btn[TABS.MISC][i].dfurniturelabel ~= nil) then
				crft_btn[TABS.MISC][i].dfurniturelabel:SetColor(Color(255, 255, 255))
				end
				crft_btn[TABS.MISC][i].dpricelabel:SetColor(Color(164, 254, 115))
				crft_btn[TABS.MISC][i].dxplabel:SetColor(Color(188, 139, 254))
				crft_btn[TABS.MISC][i].isClickable = true
			end
		end

	end)
	
	// Hook to disable all craftables buttons!
	hook.Add("DisableCrftBtns", "DisableCraftablesButtons", function()
		for i, j in ipairs(CRAFTING_FURNITURE_TBL) do
			crft_btn[TABS.FURNITURE][i]:SetEnabled(false)
			crft_btn[TABS.FURNITURE][i].isClickable = false
		end
		
		for i, j in ipairs(CRAFTING_WEAPONS_TBL) do
			crft_btn[TABS.WEAPONS][i]:SetEnabled(false)
			crft_btn[TABS.WEAPONS][i].isClickable = false
		end
		
		for i, j in ipairs(CRAFTING_MISC_TBL) do
			if(crft_btn[TABS.MISC][i] == nil) then return end
			crft_btn[TABS.MISC][i]:SetEnabled(false)
			crft_btn[TABS.MISC][i].isClickable = false
		end
	end)
	
	// Hook to enable all craftables buttons!
	hook.Add("EnableCrftBtns", "EnableCraftablesButtons", function()
		local plylvl = LocalPlayer():GetNWInt("crft_level")
		for i, j in ipairs(CRAFTING_FURNITURE_TBL) do
			if(plylvl >= j.reqlevel) then
			crft_btn[TABS.FURNITURE][i]:SetEnabled(true)
			crft_btn[TABS.FURNITURE][i].isClickable = true
			end
		end
		
		for i, j in ipairs(CRAFTING_WEAPONS_TBL) do
			if(plylvl >= j.reqlevel) then
			crft_btn[TABS.WEAPONS][i]:SetEnabled(true)
			crft_btn[TABS.WEAPONS][i].isClickable = true
			end
		end
		
		for i, j in ipairs(CRAFTING_MISC_TBL) do
			if(plylvl >= j.reqlevel) then
			if(crft_btn[TABS.MISC][i] == nil) then return end
			crft_btn[TABS.MISC][i]:SetEnabled(true)
			crft_btn[TABS.MISC][i].isClickable = true
			end
		end
	end)

	
	// CREATE FURNITURE //
	
	for k, v in ipairs(CRAFTING_FURNITURE_TBL) do
	
		local btn = vgui.Create( "DButton", furnitureSheet )
		btn:SetSize(0,100)
		btn:Dock(TOP)
		btn:SetText("")
		btn.isActive = false
		btn.isClickable = false
		local plylvl = LocalPlayer():GetNWInt("crft_level")
		
		if(plylvl < v.reqlevel) then
			btn:SetEnabled(false)
		else
			btn.isClickable = true
		end
		
		table.insert(crft_btn[TABS.FURNITURE], btn)

		if(k~=1) then
			btn:DockMargin(0, 10, 0, 0)
		end
		
		btn.HoverLerp = 0
		btn.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.5 )
			end
			
			if(not btn.isClickable) then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
			else
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125 * s.HoverLerp))
			end
		end
		
		btn.PaintOver = function(self, w, h)
			if(btn.isActive) then
				surface.SetDrawColor(47, 113, 73, 255)
				surface.DrawOutlinedRect( 0, 0, w, h)
			end
		end
		
		btn.dmodelpanel = vgui.Create("DModelPanel", btn)
		local dmodelpanel = btn.dmodelpanel
		dmodelpanel:SetSize(85,100)
		dmodelpanel:SetModel(v.model)
		dmodelpanel:SetCamPos( v.viewvec )
		if(plylvl < v.reqlevel) then
			dmodelpanel:SetColor(Color(0, 0, 0))
		else
			dmodelpanel:SetColor(Color(255, 255, 255))
		end
		if(v.viewoffset ~= nil) then
			dmodelpanel:SetLookAt(v.viewoffset)
		else
			dmodelpanel:SetLookAt(Vector(0,0,0))
		end
		dmodelpanel:Dock(LEFT)
		dmodelpanel:DockMargin(7, 7, 7, 7)
		
		-- If a player can craft an item, change the portrait. This will be a nice QOL fix
		btn.matCheck = CheckPlayerMats(v.materials)
		
		dmodelpanel.PaintOver = function(self, w, h)
			if(not btn.isClickable) then
				surface.SetDrawColor(0, 0, 0, 255)
			else
				surface.SetDrawColor(255, 255, 255, 25)
				
				if (btn.matCheck) then surface.SetDrawColor(97, 213, 123, 255) end
			end
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
		
		-- FURNITURE NAME
		btn.dfurniturelabel = vgui.Create("DLabel", btn)
		local dfurniturelabel = btn.dfurniturelabel
		dfurniturelabel:SetText(v.name)
		dfurniturelabel:SetPos(105, 0)
		dfurniturelabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dfurniturelabel:SetColor(Color(155, 155, 155))
		end
		dfurniturelabel:SetFont("CT_PanelLarge")
		
		-- XP LABEL
		btn.dxplabel = vgui.Create("DLabel", btn)
		local dxplabel = btn.dxplabel
		dxplabel:SetText("Awards "..v.xp.." XP")
		dxplabel:SetPos(105, 30)
		dxplabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dxplabel:SetColor(Color(75, 75, 75))
		else
			dxplabel:SetColor(Color(188, 139, 254))
		end
		dxplabel:SetFont("CT_PanelRegular")
		
		-- PRICE LABEL
		btn.dpricelabel = vgui.Create("DLabel", btn)
		local dpricelabel = btn.dpricelabel
		dpricelabel:SetText("Sells for $"..string.Comma(v.price))
		dpricelabel:SetPos(105, 60)
		dpricelabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dpricelabel:SetColor(Color(75, 75, 75))
		else
			dpricelabel:SetColor(Color(164, 254, 115))
		end
		dpricelabel:SetFont("CT_PanelRegular")		
		
		-- REQUIRED LEVEL
		btn.dlevel = vgui.Create("DLabel", btn)
		local dlevel = btn.dlevel
		dlevel:SetText("Lv."..v.reqlevel)
		dlevel:SetFont("CT_PanelSmall")
		dlevel:SetPos(380, 0)
		dlevel:SizeToContents()
		if(plylvl < v.reqlevel) then
			dlevel:SetColor(Color(255, 100, 100))
		else
			dlevel:SetColor(Color(255, 255, 255))
		end
		
		function btn:DoClick()
			for _, j in ipairs(crft_btn[TABS.FURNITURE]) do
				j.isActive = false
			end
			LocalPlayer():EmitSound("crft_uiClick")
			btn.isActive = true
			active_selection = v
			active_selection_index = k
			activeTab = TABS.FURNITURE	//1
			hook.Call("UpdateCrftUI", GAMEMODE, 0)
			hook.Call("UpdateCrftUIMats")
			
		end
	end
	
	self:AddSheet("Furniture", furnitureSheet)
	
	// CREATE WEAPONS //
	
	local wpnSheet = self:Add("DScrollPanel")
	wpnSheet:SetSize(x, y)
	wpnSheet.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	wpnSheet.id = 1
	
	--Modify Scroll Bar--
	
	local sbar = wpnSheet:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(0, 8, 0, (w/2), h, Color(0, 0, 0, 125))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(0, 9, 0, (w/2), h, Color(155, 155, 155, 255))
	end
	
	for k, v in ipairs(CRAFTING_WEAPONS_TBL) do
	
		local btn = vgui.Create( "DButton", wpnSheet )
		btn:SetSize(0,100)
		btn:Dock(TOP)
		btn:SetText("")
		btn.isActive = false
		btn.isClickable = false
		local plylvl = LocalPlayer():GetNWInt("crft_level")
		
		if(plylvl < v.reqlevel) then
			btn:SetEnabled(false)
		else
			btn.isClickable = true
		end
		
		table.insert(crft_btn[TABS.WEAPONS], btn)

		if(k~=1) then
			btn:DockMargin(0, 10, 0, 0)
		end
		
		btn.HoverLerp = 0
		btn.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.5 )
			end
			
			if(not btn.isClickable) then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
			else
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125 * s.HoverLerp))
			end
		end
		
		btn.PaintOver = function(self, w, h)
			if(btn.isActive) then
				surface.SetDrawColor(47, 113, 73, 255)
				surface.DrawOutlinedRect( 0, 0, w, h)
			end
		end
		
		btn.dmodelpanel = vgui.Create("DModelPanel", btn)
		local dmodelpanel = btn.dmodelpanel
		dmodelpanel:SetSize(85,100)
		dmodelpanel:SetModel(v.model)
		dmodelpanel:SetCamPos( v.viewvec )
		if(plylvl < v.reqlevel) then
			dmodelpanel:SetColor(Color(0, 0, 0))
		else
			dmodelpanel:SetColor(Color(255, 255, 255))
		end
		if(v.viewoffset ~= nil) then
			dmodelpanel:SetLookAt(v.viewoffset)
		else
			dmodelpanel:SetLookAt(Vector(0,0,0))
		end
		dmodelpanel:Dock(LEFT)
		dmodelpanel:DockMargin(7, 7, 7, 7)
		
		-- If a player can craft an item, change the portrait. This will be a nice QOL fix
		btn.matCheck = CheckPlayerMats(v.materials)
		dmodelpanel.PaintOver = function(self, w, h)
			if(not btn.isClickable) then
				surface.SetDrawColor(0, 0, 0, 255)
			else
				surface.SetDrawColor(255, 255, 255, 25)
				
				if (btn.matCheck) then surface.SetDrawColor(97, 213, 123, 255) end
			end
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
		
		-- WEP NAME
		btn.dweplabel = vgui.Create("DLabel", btn)
		local dweplabel = btn.dweplabel
		dweplabel:SetText(v.name)
		dweplabel:SetPos(105, 0)
		dweplabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dweplabel:SetColor(Color(155, 155, 155))
		end
		dweplabel:SetFont("CT_PanelLarge")
		
		-- XP LABEL
		btn.dxplabel = vgui.Create("DLabel", btn)
		local dxplabel = btn.dxplabel
		dxplabel:SetText("Awards "..v.xp.." XP")
		dxplabel:SetPos(105, 30)
		dxplabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dxplabel:SetColor(Color(75, 75, 75))
		else
			dxplabel:SetColor(Color(188, 139, 254))
		end
		dxplabel:SetFont("CT_PanelRegular")
		
		-- PRICE LABEL
		btn.dpricelabel = vgui.Create("DLabel", btn)
		local dpricelabel = btn.dpricelabel
		dpricelabel:SetText("Costs $"..string.Comma(v.price))
		dpricelabel:SetPos(105, 60)
		dpricelabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dpricelabel:SetColor(Color(75, 75, 75))
		else
			dpricelabel:SetColor(Color(164, 254, 115))
		end
		dpricelabel:SetFont("CT_PanelRegular")		
		
		-- REQUIRED LEVEL
		btn.dlevel = vgui.Create("DLabel", btn)
		local dlevel = btn.dlevel
		dlevel:SetText("Lv."..v.reqlevel)
		dlevel:SetFont("CT_PanelSmall")
		dlevel:SetPos(380, 0)
		dlevel:SizeToContents()
		if(plylvl < v.reqlevel) then
			dlevel:SetColor(Color(255, 100, 100))
		else
			dlevel:SetColor(Color(255, 255, 255))
		end
		
		function btn:DoClick()
			for _, j in ipairs(crft_btn[TABS.WEAPONS]) do
				j.isActive = false
			end
			LocalPlayer():EmitSound("crft_uiClick")
			btn.isActive = true
			active_selection = v
			active_selection_index = k
			activeTab = TABS.WEAPONS	//2
			hook.Call("UpdateCrftUI", GAMEMODE, 1)
			hook.Call("UpdateCrftUIMats")
			
		end
	end
	
	self:AddSheet("Weapons", wpnSheet)
	
	// CREATE MISC //
	
	local miscSheet = self:Add("DScrollPanel")
	miscSheet:SetSize(x, y)
	miscSheet.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	miscSheet.id = 2
		
	--Modify Scroll Bar--
	
	local sbar = miscSheet:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(0, 8, 0, (w/2), h, Color(0, 0, 0, 125))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(0, 9, 0, (w/2), h, Color(155, 155, 155, 255))
	end
	
	for k, v in ipairs(CRAFTING_MISC_TBL) do
	
		local btn = vgui.Create( "DButton", miscSheet )
		btn:SetSize(0,100)
		btn:Dock(TOP)
		btn:SetText("")
		btn.isActive = false
		btn.isClickable = false
		local plylvl = LocalPlayer():GetNWInt("crft_level")
		
		if(plylvl < v.reqlevel) then
			btn:SetEnabled(false)
		else
			btn.isClickable = true
		end
		
		table.insert(crft_btn[TABS.MISC], btn)

		if(k~=1) then
			btn:DockMargin(0, 10, 0, 0)
		end
		
		btn.HoverLerp = 0
		btn.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.5 )
			end
			
			if(not btn.isClickable) then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
			else
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125 * s.HoverLerp))
			end
		end
		
		btn.PaintOver = function(self, w, h)
			if(btn.isActive) then
				surface.SetDrawColor(47, 113, 73, 255)
				surface.DrawOutlinedRect( 0, 0, w, h)
			end
		end
		
		btn.dmodelpanel = vgui.Create("DModelPanel", btn)
		local dmodelpanel = btn.dmodelpanel
		dmodelpanel:SetSize(85,100)
		dmodelpanel:SetModel(v.model)
		dmodelpanel:SetCamPos( v.viewvec )
		if(plylvl < v.reqlevel) then
			dmodelpanel:SetColor(Color(0, 0, 0))
		else
			dmodelpanel:SetColor(Color(255, 255, 255))
		end
		if(v.viewoffset ~= nil) then
			dmodelpanel:SetLookAt(v.viewoffset)
		else
			dmodelpanel:SetLookAt(Vector(0,0,0))
		end
		dmodelpanel:Dock(LEFT)
		dmodelpanel:DockMargin(7, 7, 7, 7)
		
		-- If a player can craft an item, change the portrait. This will be a nice QOL fix
		btn.matCheck = CheckPlayerMats(v.materials)

		dmodelpanel.PaintOver = function(self, w, h)
			if(not btn.isClickable) then
				surface.SetDrawColor(0, 0, 0, 255)
			else
				surface.SetDrawColor(255, 255, 255, 25)
				
				if (btn.matCheck) then surface.SetDrawColor(97, 213, 123, 255) end
			end
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
		
		-- MISC ITEM NAME
		btn.dweplabel = vgui.Create("DLabel", btn)
		local dweplabel = btn.dweplabel
		dweplabel:SetText(v.name)
		dweplabel:SetPos(105, 0)
		dweplabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dweplabel:SetColor(Color(155, 155, 155))
		end
		dweplabel:SetFont("CT_PanelLarge")
		
		-- XP LABEL
		btn.dxplabel = vgui.Create("DLabel", btn)
		local dxplabel = btn.dxplabel
		dxplabel:SetText("Awards "..v.xp.." XP")
		dxplabel:SetPos(105, 30)
		dxplabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dxplabel:SetColor(Color(75, 75, 75))
		else
			dxplabel:SetColor(Color(188, 139, 254))
		end
		dxplabel:SetFont("CT_PanelRegular")
		
		-- PRICE LABEL
		btn.dpricelabel = vgui.Create("DLabel", btn)
		local dpricelabel = btn.dpricelabel
		dpricelabel:SetText("Costs $"..string.Comma(v.price))
		dpricelabel:SetPos(105, 60)
		dpricelabel:SetSize(400, 32)
		if(plylvl < v.reqlevel) then
			dpricelabel:SetColor(Color(75, 75, 75))
		else
			dpricelabel:SetColor(Color(164, 254, 115))
		end
		dpricelabel:SetFont("CT_PanelRegular")		
		
		-- REQUIRED LEVEL
		btn.dlevel = vgui.Create("DLabel", btn)
		local dlevel = btn.dlevel
		dlevel:SetText("Lv."..v.reqlevel)
		dlevel:SetFont("CT_PanelSmall")
		dlevel:SetPos(380, 0)
		dlevel:SizeToContents()
		if(plylvl < v.reqlevel) then
			dlevel:SetColor(Color(255, 100, 100))
		else
			dlevel:SetColor(Color(255, 255, 255))
		end
		
		function btn:DoClick()
			for _, j in ipairs(crft_btn[TABS.MISC]) do
				j.isActive = false
			end
			LocalPlayer():EmitSound("crft_uiClick")
			btn.isActive = true
			active_selection = v
			active_selection_index = k
			
			activeTab = TABS.MISC	//3
			hook.Call("UpdateCrftUI", GAMEMODE, 1)
			hook.Call("UpdateCrftUIMats")
			
		end
	end
	
	self:AddSheet("Misc", miscSheet)
	
	// ** OVERRIDE BUTTONS ** //
	// Set up paint overrides

	for k, v in pairs(self:GetItems()) do
		for i, j in pairs(v) do
			if(i == "Tab") then
				
				j:SetFont("CRFT_InvFontSmall")
				--[[
				j.GetTabHeight = function()
					return 200
				end
				--]]
				j.Paint = function(s, w, h)
					if(j:IsActive()) then
						draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,255))
					else
						draw.RoundedBox(0, 0, 0, w, h, Color(25,25,25,255))
					end
				end
				
			end
		end
	end

end

vgui.Register("CraftingTable:CraftSelection", PANEL, "DPropertySheet")

-- CRAFT MAIN CRAFTING PANEL

local PANEL = {}
local isCrafting = false
local curStartTime = -1
local curCraftTime= -1
local splashPnl = nil

function PANEL:Init()
	self:SetPos((ScrW() / 2) - (bgw/2) + 495, ScrH()/2 - bgh*0.5 + 275)
	self:SetSize(750, 575)
	self:SetText("")
	isCrafting = false
	splashPnl = nil
	self.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))	
	end
	
	local dlbl = self:Add("DLabel")
	dlbl:SetPos(self:GetWide()/2, self:GetTall()/2 - 200)
	dlbl:SetFont("CT_PanelHuge")
	dlbl:SetText("Select A Craft")
	dlbl:SizeToContents()
	dlbl:CenterHorizontal()	
	
	local dlvl = self:Add("DLabel")
	dlvl:SetPos(self:GetWide()/2, self:GetTall()/2 - 160)
	dlvl:SetFont("CT_PanelRegular")
	dlvl:SetText("...")
	dlvl:SizeToContents()
	dlvl:CenterHorizontal()	
	
	local displaymodel = self:Add("DModelPanel")
	displaymodel:SetPos(self:GetWide()/2, self:GetTall()/2 - 120)
	displaymodel:SetSize(250, 250)
	displaymodel:SetModel("models/props_c17/FurnitureChair001a.mdl")
	displaymodel:SetColor(Color(0, 0, 0))
	displaymodel:SetCamPos(Vector(40, 0, 20))
	displaymodel:SetLookAt(Vector(0, 0, 0))
	displaymodel:CenterHorizontal()
	displaymodel:SetCursor("arrow")
	
	local rewardlbl = self:Add("DLabel")
	rewardlbl:SetText("Rewards:")
	rewardlbl:SetFont("CT_PanelSmall")
	rewardlbl:SetPos(5, 460)
	rewardlbl:SetColor(Color(125, 125, 125))
	rewardlbl:SizeToContents()	
	rewardlbl:SetAlpha(0)

	local xplbl = self:Add("DLabel")
	xplbl:SetText("+0 XP")
	xplbl:SetFont("CT_PanelMedium")
	xplbl:SetPos(5, 480)
	xplbl:SetColor(Color(188, 139, 254))
	xplbl:SizeToContents()
	xplbl:SetAlpha(0)
	
	local moneylbl = self:Add("DLabel")
	moneylbl:SetText("+$"..string.Comma(0))
	moneylbl:SetFont("CT_PanelMedium")
	moneylbl:SetPos(5, 510)
	moneylbl:SetColor(Color(164, 254, 115))
	moneylbl:SizeToContents()
	moneylbl:SetAlpha(0)
	
	
	-- CRAFTING BTN
	local crftbtn = self:Add("DImageButton")
	crftbtn:SetText("")
	crftbtn:SetImage("UI/crafting/craftButton.png")
	crftbtn:SetSize(162, 54)
	crftbtn:SetPos(0, 460)
	crftbtn:SetAlpha(0)
	crftbtn:SetEnabled(false)
	crftbtn:CenterHorizontal()
	
	local crftProg = self:Add("DProgress")
	crftProg:SetSize(162, 22)
	crftProg:SetPos(0, 430)
	crftProg:CenterHorizontal()
	crftProg.Paint = function(_, w, h)
		if(isCrafting) then
			local ratio = ((CurTime() - curStartTime) / (curCraftTime - curStartTime))
			local timeremaning = math.max(curCraftTime - CurTime(), 0)
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,125))
			draw.RoundedBox(0, 2, 2, (w - 4) * ratio, h -4, Color(47, 163, 73,255))	//Actual prog bar
			
			draw.DrawText(math.Truncate(timeremaning, 1), "CT_PanelSmall", (w/2), 0, Color(255,255,255,255), 1)
		end
	end
	
	local function craftItem()
		--
		if active_selection_index == 0 or active_selection_index == nil then return end
		crftbtn:SetEnabled(true)
		crftbtn:SetImage("UI/crafting/craftButton.png")
		local oldplylvl = LocalPlayer():GetNWInt("crft_level")
		--Update splash screen info
		local activeTabTbl = {
		[1] = CRAFTING_FURNITURE_TBL,
		[2] = CRAFTING_WEAPONS_TBL,
		[3] = CRAFTING_MISC_TBL
		}

		if(CheckPlayerMats(activeTabTbl[activeTab][active_selection_index].materials) == false) then return end
		hook.Call("RegisterSplashScreenIndex", GAMEMODE, active_selection_index, activeTab)
		--Hide the BG model to avoid weird clipping error
		displaymodel:SetColor(Color(0, 0, 0, 0))
		if(splashPnl == nil) then
			splashPnl = vgui.Create("CraftingTable:SplashScreen", self:GetParent():GetParent():GetParent())
		end
		
		hook.Add("Crft_CloseSplashScreen", "Close Splash Panel", function()
			splashPnl = nil
		end)
		
		-- Give money and XP
		net.Start("craftingUpdateStats")
			net.WriteFloat(active_selection.price)
			net.WriteFloat(active_selection.xp)
			net.WriteFloat(activeTab)
		net.SendToServer()
		
		-- Take away materials
		net.Start("craftingUpdateMaterials")
			net.WriteTable(active_selection.materials)
		net.SendToServer()
		
		if(activeTab ~= TABS.FURNITURE) then
			-- Give entity
			net.Start("craftingGiveEnt")
				net.WriteString(active_selection.ent)
			net.SendToServer()
		end
		
		--Now reupdate the UI
		timer.Simple(0.5, function()
			hook.Call("UpdateCrftUIMats")
			hook.Call("UpdateCrftXPBar")
			
			local newplylvl = LocalPlayer():GetNWInt("crft_level")
			
			for k, v in ipairs(CRAFTING_FURNITURE_TBL) do
				if(crft_btn[TABS.FURNITURE][k] ~= nil) then
					crft_btn[TABS.FURNITURE][k].matCheck = CheckPlayerMats(v.materials)
				end
			end			
			
			for k, v in ipairs(CRAFTING_WEAPONS_TBL) do
				if(crft_btn[TABS.WEAPONS][k] ~= nil) then
					crft_btn[TABS.WEAPONS][k].matCheck = CheckPlayerMats(v.materials)
				end
			end			
			
			for k, v in ipairs(CRAFTING_MISC_TBL) do
				if(crft_btn[TABS.MISC][k] ~= nil) then
					crft_btn[TABS.MISC][k].matCheck = CheckPlayerMats(v.materials)
				end
			end
			
			if(newplylvl > oldplylvl) then
				-- If the player levels up, new craftables need to be updated in the UI. This doesnt matter if the player is max level though as they can craft anything anyways
				-- We should also update their new level
				hook.Call("UpdateCrftNewDisplay")
			end
			
		end)
	end
	
	function crftbtn:DoClick()
		
		//This should prevent auto-clickers from breaking shit
		if(self:IsEnabled() == false) then return end
		local activeTabTbl = {
		[1] = CRAFTING_FURNITURE_TBL,
		[2] = CRAFTING_WEAPONS_TBL,
		[3] = CRAFTING_MISC_TBL
		}
		
		if(CheckPlayerMats(activeTabTbl[activeTab][active_selection_index].materials) == false) then return end
		//
		
		local ply = LocalPlayer()
		local speedmod = (math.max(1 / (active_selection.crafttime / 2), 1))
		ply:EmitSound("ui/uiCrafting.mp3", 100, 100 * speedmod, 0.4, CHAN_AUTO)
		self:SetEnabled(false)
		self:SetImage("UI/crafting/craftButtonOff.png")
		hook.Call("DisableCrftBtns")
		isCrafting = true
		curStartTime = CurTime()
		curCraftTime = CurTime() + active_selection.crafttime
		timer.Simple(active_selection.crafttime, function()
			if(!IsValid(ply) or !IsValid(myPanel) or self == nil) then return end
			if(crftbtn == nil or !IsValid(crftbtn)) then return end
			craftItem()
			hook.Call("EnableCrftBtns")
			isCrafting = false
		end)
	end
	--
	
	-- Draw the required materials
	self.craftingpnlmats = vgui.Create("CraftingTable:CraftingPanelMaterials", self)
	self.craftingpnlmats:SetAlpha(0)
	
	hook.Add("UpdateCrftUI", "Updates Craft UI", function(crftType)
		
		/*crftType
			This variable tells us if we are crafting to sell for a profit, or to create an item for personal use
			The former gives us darkRP money, the later will require the user to pay darkRP money
			the UI must reflect this change.
		*/
		--Update furniture name
		dlbl:SetText(active_selection.name)
		dlbl:SizeToContents()
		dlbl:CenterHorizontal()
		dlbl:SetAlpha(0)
		dlbl:AlphaTo(255, 0.5, 0)
		
		--Update required level
		dlvl:SetText("Lv."..active_selection.reqlevel)
		dlvl:SizeToContents()
		dlvl:CenterHorizontal()
		dlvl:SetAlpha(0)
		dlvl:AlphaTo(255, 0.5, 0)
		
		--Update the rewards text
		rewardlbl:AlphaTo(255, 0.5, 0)
		
		xplbl:SetText("+"..active_selection.xp.. " XP")
		xplbl:SizeToContents()
		xplbl:AlphaTo(255, 0.5, 0)
		
		if(crftType == 1) then	// COSTS MONEY
			moneylbl:SetText("-$"..string.Comma(active_selection.price))
			moneylbl:SizeToContents()
			moneylbl:SetColor(Color(239, 81, 81))
			moneylbl:AlphaTo(255, 0.5, 0)
		else								// GIVES MONEY
			moneylbl:SetText("+$"..string.Comma(active_selection.price))
			moneylbl:SizeToContents()
			moneylbl:SetColor(Color(164, 254, 115))
			moneylbl:AlphaTo(255, 0.5, 0)
		end
		
		crftbtn:AlphaTo(255, 0.5, 0)
		
		if(CheckPlayerMats(active_selection.materials) == true) then
			crftbtn:SetEnabled(true)
			crftbtn:SetImage("UI/crafting/craftButton.png")
		else
			crftbtn:SetEnabled(false)
			crftbtn:SetImage("UI/crafting/craftButtonOff.png")
		end
		
		//Money Check
		if(activeTab ~= TABS.FURNITURE) then
			local money =  LocalPlayer():getDarkRPVar("money")
			if(money - active_selection.price < 0) then
				crftbtn:SetEnabled(false)
				crftbtn:SetImage("UI/crafting/craftButtonOff.png")
			elseif (CheckPlayerMats(active_selection.materials) == true) and (money - active_selection.price > 0) then
				crftbtn:SetEnabled(true)
				crftbtn:SetImage("UI/crafting/craftButton.png")
			end
		end
		
		--Fade the required materials in
		self.craftingpnlmats:AlphaTo(255, 0.5, 0)
		
		--Setup the correct display model
		displaymodel:SetModel(active_selection.model)
		displaymodel:SetCamPos( active_selection.viewvec )
		displaymodel:SetColor(Color(0, 0, 0, 255))
		displaymodel:ColorTo(Color(255, 255, 255), 0.5, 0)
		if(active_selection.viewoffset ~= nil) then
			displaymodel:SetLookAt(active_selection.viewoffset)
		else
			displaymodel:SetLookAt(Vector(0,0,0))
		end
	end)
	
	
end

vgui.Register("CraftingTable:CraftingPanel", PANEL, "DPanel")

-- REQUIRED MATERIALS

local PANEL = {}
local LabelTbl = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(215, 25)
	self:SetText("")
	local offset = 0
	
	self.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))	
	end
	
	local reqmatslbl = self:Add("DLabel")
	reqmatslbl:SetText("Required:")
	reqmatslbl:SetColor(Color(125, 125, 125))
	reqmatslbl:SetFont("CT_PanelSmall")
	reqmatslbl:SetPos(5, 0)
	
	hook.Add("UpdateCrftUIMats", "Updates Craft UI Materials", function()
		local mats = active_selection.materials
		local offset = 20
		
		for k, v in pairs(LabelTbl) do
			if(v:IsValid()) then
				v:Remove()
			end
		end
		
		for k, v in pairs(mats) do
			local dlbl = self:Add("DLabel")
			local dmatlbl = self:Add("DLabel")
			dlbl:SetFont("CT_PanelSmall")
			dmatlbl:SetFont("CT_PanelSmall")
			
			table.insert(LabelTbl, dlbl)
			table.insert(LabelTbl, dmatlbl)
			
			local x, y = dlbl:GetPos()
			dlbl:SetText(CRAFTING_MAT_NAME[k])
			dlbl:SizeToContents()
			dlbl:SetPos(x + 5, y + offset)
			
			dmatlbl:SetText(LocalPlayer():GetNWInt(k).."/"..v)
			if(LocalPlayer():GetNWInt(k) >= v) then
				dmatlbl:SetColor(Color(100, 255, 100))
			else
				dmatlbl:SetColor(Color(255, 100, 100))
			end
			dmatlbl:SizeToContents()
			dmatlbl:SetPos(x + 165, y + offset)
			
			offset = offset + 20
		end
		self:SizeTo(215, 10 + offset, 0.25, 0, 1)
	end)

end

vgui.Register("CraftingTable:CraftingPanelMaterials", PANEL, "DPanel")