-- Custom Fonts Register --

surface.CreateFont( "SciFi_FontItalic", {
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
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "SciFi_FontRegular", {
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
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "SciFi_FontTitle", {
	font = "Century Gothic",
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

local width = 600
local height = 700

-- INITIAL PANEL --

local PANEL = {}

function PANEL:Init()
		--Init look
	
	local posx, posy = 0
	posx = (ScrW() / 2) - (width/2)
	posy = (ScrH() / 2) - (height/2)
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:Dock(FILL)
	self:Center()
	self:SetDraggable(false)
	self:SetTitle("")
	self:SetSize(width, height)
	self:Center()
	--self:SetBackgroundBlur(true)
	
	--print("Popped up init menu!")
	
	self.Paint = function(self)
		draw.RoundedBox(5, posx, posy, width, height, Color(0, 0, 0, 235))
	end
	
	-- Create Panels
	self.toppanel = vgui.Create("ScifiPanel:NPCFrame", self)
	self.chatpanel = vgui.Create("ScifiPanel:ChatFrame", self)
	self.chatpanel = vgui.Create("ScifiPanel:WeaponPanel", self)
	--
	
	-- Exit Button
	
	self.closeBtn = self:Add("DButton")
	self.closeBtn:SetPos(posx + width - 30, posy + 5)
	self.closeBtn:SetSize(20, 20)
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
		
		draw.RoundedBox(5, 0, 0, w, h, Color(255, 255, 255, 255* s.HoverLerp))
		
	end
	--
	

	local Drect = vgui.Create( "DShape", self)
	Drect:SetType("Rect")
	Drect:SetColor(Color(255, 255, 255))
	Drect:SetPos(posx, posy + 138)
	Drect:SetSize(width, 1)
	
end

vgui.Register("ScifiPanel:Menu", PANEL, "DFrame")

net.Receive("scifi_menu_open", function()
	vgui.Create("ScifiPanel:Menu")
end)

-- NPC PANEL --

local PANEL = {}

function PANEL:Init()
	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 5
	
	self:SetSize(x/1.5 - topframepad, y / 3)
	self:SetPos(posx - 50 + topframepad, posy -100 + topframepad)
	
	
	function self:LayoutEntity( Entity )
	self:RunAnimation()
	end	-- Disable cam rotation (WIKI)
	
	self:SetModel(SCIFI_NPC_MODEL)

	
	local eyepos = self:GetEntity():GetBonePosition( 14 )
	
	self:SetLookAt(eyepos - Vector(0,-3,12))
	self:SetCamPos( eyepos-Vector( -40, 10, 12 ) )
	self:SetAnimated(true)
	local animSeq = self:GetEntity():LookupSequence( "Idle01" )
	self:GetEntity():SetSequence(animSeq)
	
	self:SetCursor("arrow")
	
end

vgui.Register("ScifiPanel:NPCFrame", PANEL, "DModelPanel")

-- CHAT PANEL

local PANEL = {}

local test = 0 

function PANEL:Init()
	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 20
	test = 0
	
	self:SetSize(x - 255 - topframepad*2, y / 7)
	self:SetPos(posx + topframepad + 250, posy + topframepad + 10)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 0))
	end
	
	msg = table.Random(VENDOR_GREET_MSGS)
	--Greeting MSG
	Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("SciFi_FontItalic")
	Dlabel:SizeToContents()
	Dlabel:SetSize( self:GetSize() )
	Dlabel:SetPos(0, 10)
	Dlabel:SetWrap(true)
	Dlabel:SetAutoStretchVertical(true)
	Dlabel:SetAlpha(0)
	Dlabel:SetColor(Color(255, 255, 255))
	
	Dlabel:AlphaTo(255, 1.5, 0)
	Dlabel:MoveTo(0, 0, 1, 0, -1)
	
end

function PANEL:Think()
	if  not (Dlabel:IsValid()) then self:GetParent():Remove() return end
	test = Lerp(FrameTime()/5, test, 255)
	Dlabel:SetText(string.sub(msg, 0, test))
end

vgui.Register("ScifiPanel:ChatFrame", PANEL, "DPanel")

-- =============== --
-- == WEAPON PANEL == --
-- =============== --

local PANEL = {}

function PANEL:Init()
	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 5
	
	self:SetSize(x - topframepad*2, y - 135 - topframepad*2)
	self:SetPos(posx + topframepad, posy + 135 + topframepad)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
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
	--CREATE WEAPONS--
	for k, v in pairs(SCIFI_WEPS) do
		
		local buyButton
		
		--Panel container
		local Dpanel = vgui.Create( "DPanel", self )
		Dpanel.HoverLerp = 0
		Dpanel:SetSize(0, 125)
		Dpanel:Dock(TOP)
		Dpanel:DockMargin( 10, 10, 10, 0 ) 
		Dpanel.Paint = function(s, w, h)
		
			if s:IsHovered() or buyButton:IsHovered() then
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 1 )
			else
				Dpanel.HoverLerp = Lerp( FrameTime() * 5, Dpanel.HoverLerp, 0 )
			end
		
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150* Dpanel.HoverLerp))
		end
		
		
		local offset = 120
		
		--Purchase Button--
		
		buyButton = vgui.Create( "DButton", Dpanel)
		
		buyButton:SetPos(425, Dpanel:GetTall()/2 - 57.5)
		buyButton:SetSize(120, 45)
		buyButton:SetText("")
		buyButton.HoverLerp = 0
		buyButton.Paint = function(_, w, h)
			if buyButton:IsHovered() then
				buyButton.HoverLerp = Lerp( FrameTime() * 5, buyButton.HoverLerp, 1 )
			else
				buyButton.HoverLerp = Lerp( FrameTime() * 5, buyButton.HoverLerp, 0.1)
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 225 * buyButton.HoverLerp))
		end
		
		buyButton.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125 * buyButton.HoverLerp), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		buyButton.DoClick = function (self)
			if((LocalPlayer():getDarkRPVar("money") or "0") > v[2]) then
				if (LocalPlayer():HasWeapon(v[1]) == false) then
					LocalPlayer():EmitSound( table.Random(VENDOR_PURCHASE_VO), 100, 80, 1, CHAN_VOICE )
					net.Start("scifi_givewep")
						net.WriteString(v[1])
						net.WriteString(v[2])
					net.SendToServer()
					self:GetParent():GetParent():GetParent():GetParent():Close()
				else
					chat.AddText(Color(255, 66, 75), ply, "You already have this weapon.")
					surface.PlaySound("buttons/button5.wav")
				end
			else
				chat.AddText(Color(255, 66, 75), ply, "You do not have enough money.")
				surface.PlaySound("buttons/button5.wav")
			end
			
		end
		
		local Dlabel = vgui.Create( "DLabel", buyButton )
		Dlabel:SetFont("SciFi_FontRegular")
		Dlabel:SetText("P U R C H A S E")
		Dlabel:SizeToContents()
		Dlabel:Center()
		Dlabel:SetColor(Color(255,255,255, 255))
		Dlabel.HoverLerp = 0
		Dlabel.Paint = function(_, w, h)
			if Dpanel:IsHovered() or buyButton:IsHovered() then
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 1 )
			else
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 0.1 )
			end
			Dlabel:SetColor(Color(255,255,255, 125 * Dlabel.HoverLerp))
		end
		--
		
		
		--Gun Icon
		local GunIco = vgui.Create( "DImage" , Dpanel ) -- SpawnIcon
		GunIco:SetPos( 0, 10 )
		GunIco:SetSize(100, 100)
		if(v[5] ~= "") then
			GunIco:SetImage( v[5] )
		end
		GunIco.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		--Gun Name
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		Dlabel:SetFont("SciFi_FontTitle")
		Dlabel:SetText(v[3])
		Dlabel:SizeToContents()
		Dlabel:SetPos(offset, 0)
		Dlabel:SetColor(Color(255,255,255, 255))
		
		--Gun Desc.
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		Dlabel:SetFont("SciFi_FontRegular")
		Dlabel:SizeToContents()
		Dlabel:SetPos(offset, 25)
		Dlabel:SetSize(300, 100)
		Dlabel:SetText(v[4])
		Dlabel:SetColor(Color(255,255,255, 55))
		Dlabel.HoverLerp = 0
		Dlabel.Paint = function(s, w, h)
		
			if Dpanel:IsHovered() or buyButton:IsHovered() then
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 1 )
			else
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 0.15 )
			end
		
			Dlabel:SetColor(Color(255,255,255, 125 * Dlabel.HoverLerp))
		end
		Dlabel:SetWrap(true)
		Dlabel:SetAutoStretchVertical(true)
				
		--Gun Price
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		local costTag = " Cost: $".. string.Comma(v[2])
		Dlabel:SetFont("SciFi_FontRegular")
		Dlabel:SetText(costTag)
		Dlabel:SizeToContents()
		Dlabel:SetPos(offset, 55)
		Dlabel:SetSize(300, 100)
		Dlabel:SetColor(Color(105,255,105, 255))
		Dlabel.HoverLerp = 0
		Dlabel.CashHighlightLerp = 0
		Dlabel.Paint = function(_, w, h)
		
			if Dpanel:IsHovered() or buyButton:IsHovered()then
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 1 )
			else
				Dlabel.HoverLerp = Lerp( FrameTime() * 5, Dlabel.HoverLerp, 0.15 )
			end
			
			if buyButton:IsHovered()then
				Dlabel.CashHighlightLerp = Lerp( FrameTime() * 5, Dlabel.CashHighlightLerp, 1 )
			else
				Dlabel.CashHighlightLerp = Lerp( FrameTime() * 5, Dlabel.CashHighlightLerp, 0 )
			end
			
			surface.SetFont("SciFi_FontRegular")
			surface.SetDrawColor(Color(100, 255, 100, 25 * Dlabel.CashHighlightLerp), 1, 1)
			surface.DrawOutlinedRect(0, 40, surface.GetTextSize(costTag) + 5, h/4.5)
			Dlabel:SetColor(Color(105,255,105, 255 * Dlabel.HoverLerp))
		end

		-- Line break
		local Drect = vgui.Create( "DShape", Dpanel)
		Drect:SetType("Rect")
		Drect:SetColor(Color(255, 255, 255))
		Drect:SetPos(110, 5)
		Drect:SetSize(1, 110)

	end
end

vgui.Register("ScifiPanel:WeaponPanel", PANEL, "DScrollPanel")
