--SERVER MSG PRINTS
if SERVER then
	local PLAYER = FindMetaTable("Player")
	util.AddNetworkString( "ColoredMessage" )
	function BroadcastMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Broadcast()
	end
	function PLAYER:PlayerMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Send(self)
	end
	elseif CLIENT then
	net.Receive("ColoredMessage",function(len)local msg = net.ReadTable()
		chat.AddText(unpack(msg))
		chat.PlaySound()
	end)
end