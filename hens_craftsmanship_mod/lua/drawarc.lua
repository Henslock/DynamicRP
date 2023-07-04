
-- VERSION 2.0 released 03/26/2017
-- Changes: 
--   1.	Half as many polygons per arc
--   2.	Only one loop for inner and outer points
--   3.	Uses quads instead of triangles
--   4.	Odd-degreed arcs aren't malformed.
--   5.	No longer needs roughness. Just put 1 in case of old version conflicts.
--   6.	Microoptimizations.
-- Enjoy! ~Bobbleheadbob

-- Draws an arc on your screen.
-- startang and endang are in degrees, 
-- radius is the total radius of the outside edge to the center.
-- cx, cy are the x,y coordinates of the center of the arc.
-- roughness is only used in old versions. Just put 1 to prevent conflicts
local cos, sin, abs, max, rad1, log, pow = math.cos, math.sin, math.abs, math.max, math.rad, math.log, math.pow
local surface = surface
function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
end

function surface.DrawArc(arc) -- Draw a premade arc.
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local quadarc = {}
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	-- Define step
	-- roughness = roughness or 1
	local diff = abs(startang-endang)
	local smoothness = log(diff,2)/2
	local step = diff / (pow(2,smoothness))
	if startang > endang then
		step = abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local outer = {}
	local ct = 1
	local r = radius - thickness
	
	for deg=startang, endang, step do
		local rad = rad1(deg)
		-- local rad = deg2rad * deg
		local cosrad, sinrad = cos(rad), sin(rad) --calculate sin,cos
		
		local ox, oy = cx+(cosrad*r), cy+(-sinrad*r) --apply to inner distance
		inner[ct] = {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		}
		
		local ox2, oy2 = cx+(cosrad*radius), cy+(-sinrad*radius) --apply to outer distance
		outer[ct] = {
			x=ox2,
			y=oy2,
			u=(ox2-cx)/radius + .5,
			v=(oy2-cy)/radius + .5,
		}
		
		ct = ct + 1
	end
	
	-- QUAD the points.
	for tri=1,ct do
		local p1,p2,p3,p4
		local t = tri+1
		p1=outer[tri]
		p2=outer[t]
		p3=inner[t]
		p4=inner[tri]
		
		quadarc[tri] = {p1,p2,p3,p4}
	end
	
	-- Return a table of triangles to draw.
	return quadarc
	
end

-- -- This is a pretty decent demo of the tech.
-- concommand.Add("test_arc", function()
	-- hook.Remove("HUDPaint", "arcTest")
	
	-- local arcs = {}
	
	-- local function AddArc()
		-- local r = math.Rand(10,250)
		-- table.insert(arcs, {
			-- r = r,
			-- t = math.Clamp(r - math.Rand(r-5,r-100),5,r-8),
			-- x = math.random(ScrW()),
			-- y = math.random(ScrH()),
			-- sa = math.random(358), 
			-- ea = math.random(358),
			-- rough = math.random(25),
			-- c = Color(math.random(255),math.random(255),math.random(255),math.random(200,255))
		-- })
	-- end
	-- timer.Create("AddArc", .5,0,AddArc)
	
	-- hook.Add("HUDPaint", "arcTest", function()
		-- for k,arc in pairs(arcs)do
			-- arc.sa = arc.sa + 5
			-- arc.ea = arc.ea + 5
			-- draw.Arc(arc.x,arc.y,arc.r,arc.t,arc.sa,arc.ea,arc.rough,arc.c)
		-- end
	-- end)
-- end)

-- -- Practical example:
-- local h = 100
-- hook.Add("HUDPaint","Draw Arc Healthbar",function()
	-- local x,y = 200,200
	-- local radius = 100
	-- local thickness = 20
	-- local max = LocalPlayer():GetMaxHealth()
	
	-- -- h = math.abs(math.cos(RealTime()))*max -- test health bar which fluctuates
	-- h = math.Clamp(LocalPlayer():Health(), 0, max) -- real health bar
	
	-- local startAng,endAng = 360, ( math.Round(max-h) / max ) * 360
	
	-- draw.Arc(x,y,radius,thickness,startAng,endAng,1,Color(0,255,0))
	
	-- surface.SetTextPos(x,y)
	-- surface.SetTextColor(255,255,0,255)
	-- surface.SetFont("DermaLarge")
	-- surface.DrawText(math.Round(h))
-- end)

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end