local hudNotification = {}
local verticalPadding = 0
local collapseSpeed = 50

function addNotification( text, dietime, height, width, quantity, icon, mtype )
	hudNotification[#hudNotification+1] = {
		["icon"] = icon,
		["deathTime"] = CurTime() + dietime,
		["height"] = height,
		["width"] = width,
		["virtualHeight"] = height,
		["text"] = text,
		["type"] = mtype,
		["textrise"] = 0
	}
end

-- Big thanks to A1Steaksa for the help! <3
--[[ Type 0 = Inventory Gains. Type 1 = XP gains.]]
hook.Add("HUDPaint", "DrawNotifications", function()
	local startX = ScrW()/2 + 175
	local startY = ScrH() - 50

	local curHeight = 0
	for i = 1, #hudNotification do
		local currNotification = hudNotification[i]
		
		if not currNotification then continue end
		
		if CurTime() >= currNotification.deathTime then

			currNotification.virtualHeight = currNotification.virtualHeight - collapseSpeed * FrameTime()
		
			if currNotification.virtualHeight <= 0 then
				table.remove( hudNotification, i )
				continue;
			end
		end
		
		if(currNotification.type == 0) then
		
			local y = startY - curHeight
			local alpha = ( currNotification.virtualHeight / currNotification.height ) * 255
			
			surface.SetTextColor( Color( 255, 255, 255, alpha ) )
			surface.SetFont( "CRFT_GainFont" )
			surface.SetTextPos( startX , y)
			surface.DrawText(currNotification.text)
			
			if(currNotification.icon ~= "") then
				surface.SetDrawColor( Color( 255, 255, 255, alpha ) )
				surface.SetMaterial(Material(currNotification.icon))
				surface.DrawTexturedRect(startX + surface.GetTextSize(currNotification.text) + 5, y, 24, 24)
			end
			
			curHeight = curHeight + currNotification.virtualHeight + verticalPadding
		else
			currNotification.textrise = Lerp(FrameTime()*1.5, currNotification.textrise, 100)
			local alpha = 1 - ( currNotification.textrise / 100 )
			surface.SetTextColor( Color( 200, 255, 200, 255 * alpha ) )
			surface.SetFont( "CRFT_GainFontLarge" )
			surface.SetTextPos(ScrW()/2 + currNotification.height, ScrH()/2 + currNotification.width - currNotification.textrise)
			surface.DrawText(currNotification.text)
			
		end
		
	end
end)

net.Receive("sendNotification", function()
	local msg = net.ReadString()
	local mtype = net.ReadInt(2)
	local micon = net.ReadString()
	
	if(mtype == 0) then
		addNotification(msg or "", 2, 25, 0, 1, micon, mtype)
	else
		addNotification(msg or "", 3, math.random(-150, 150), math.random(-100, 100), 1, 0, mtype)
	end
end)
