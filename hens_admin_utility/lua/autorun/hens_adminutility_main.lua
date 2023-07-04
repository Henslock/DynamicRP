//** CONFIG **//

STAFF_TP_ROOM_COODS = {-720.806702, 11.714560, 11798.031250}

STAFF_PERMS = {
["owner"] = true,
["developer"] = true,
["headadmin"] = true,
["superadministrator"] = true,
["administrator"] = true,
["moderator"] = true,
["satan"] = true,
}

STAFF_TP_CMD = {"!staffroom", "!sr"}

STAFF_APPEAR_OFFLINE_CMD = {"!ao", "!appearoffline"}

STAFF_SELF_SUPPLY_WHITELIST = {
["cw_aacgsm"] = true, 
["cw_ak74"] = true, 
["cw_ar15"] = true, 
["cw_bulkcannon"] = true, 
["cw_flash_grenade"] = true, 
["cw_fiveseven"] = true, 
["cw_scarh"] = true, 
["cw_frag_grenade"] = true, 
["cw_g3a3"] = true, 
["cw_g18"] = true, 
["cw_g36c"] = true, 
["cw_ump45"] = true, 
["cw_mp5"] = true, 
["cw_deagle"] = true, 
["cw_l115"] = true, 
["cw_l85a2"] = true, 
["cw_m14"] = true, 
["cw_m1911"] = true, 
["cw_m249_official"] = true, 
["cw_m3super90"] = true, 
["cw_mac11"] = true, 
["cw_mr96"] = true, 
["cw_p99"] = true, 
["cw_pkm"] = true, 
["cw_makarov"] = true, 
["cw_shorty"] = true, 
["cw_smoke_grenade"] = true, 
["cw_vss"] = true, 
["cw_nen_beretta92fs"] = true, 
["cw_scifi_ws_spas15"] = true, 
["cw_tr09_ksg12"] = true, 
["cw_scorpin_evo3"] = true, 
["cw_kimber_kw"] = true, 
["cw_kks_doi_mg42"] = true, 
["cw_mn23"] = true, 
["cw_xm1014"] = true 

}


//** END OF CONFIG **//

//STAFF ROOM TP
hook.Add("PlayerSay", "StaffTPCmd", function(ply, txt, team, isdead)
	local cmd = string.Split(txt, " ")
	
	if(STAFF_PERMS[ply:GetNWString("usergroup")]) then
		if(table.HasValue(STAFF_TP_CMD, cmd[1]) ) then
			
			local numargs = table.Count(cmd)
			local tptargets = {}
			if(numargs >= 2) then
			
				// Support for bringing multiple players
				for i = 2, numargs do
					if(cmd[i] ~= nil) then
						local _find = {}
						local multicheck = 0

						for k, v in pairs (player.GetAll()) do
							local _plynick = v:Nick()
							_find[i] = string.find(string.lower(_plynick), string.lower ( cmd[i] ))
							if(_find[i] ~= nil) then
								multicheck = multicheck + 1
								table.insert(tptargets, v)
							end
							
						end
						
						if (_find[i] == nil) then
							ply:ChatPrint("Could not find any player with the string ''".. cmd[i] .."''.")
							return ""
						end
						
						if (multicheck >= 2) then
							ply:ChatPrint("Found multiple users with string ''".. cmd[i] .."''. Please be more specific.")
							return ""
						end
						
					end
				end
				
			end
			
			if(tptargets~= nil) then
				local r = 80
				local n = table.Count(tptargets)
				for k, v in pairs(tptargets) do
					local x = math.cos(math.pi * 2 * k / n) * r
					local y = math.sin(math.pi * 2 * k / n) * r
					local offset = Vector(x, y, 0)
					v:SetPos(Vector(STAFF_TP_ROOM_COODS[1], STAFF_TP_ROOM_COODS[2], STAFF_TP_ROOM_COODS[3]) + offset)
				end
			end
			
			ply:SetPos(Vector(STAFF_TP_ROOM_COODS[1], STAFF_TP_ROOM_COODS[2], STAFF_TP_ROOM_COODS[3]))
			ply:ChatPrint("Taking you to the staff room.")
			return ""
		end
	end
end)


// APPEAR OFFLINE

hook.Add("PlayerSay", "StaffAppearOffline", function(ply, txt, team, isdead)
	if(STAFF_PERMS[ply:GetNWString("usergroup")]) then
		if(table.HasValue(STAFF_APPEAR_OFFLINE_CMD, string.lower(txt)) ) then
			ply:SetNWBool("hens_ao_toggle", !ply:GetNWBool("hens_ao_toggle"))
			
			if(ply:GetNWBool("hens_ao_toggle") == true) then
				ply:ChatPrint("You are now appearing offline. Players will not be able to see you in the tab menu. Use !ao again to turn this off.")
			else
				ply:ChatPrint("You are now appearing online.")
			end
			return ""
		end
	end
end)
