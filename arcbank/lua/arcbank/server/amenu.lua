--GUI for ARitz Cracker Bank (Serverside)$#
if ARCBank && ARCBank.HasCore then
	util.AddNetworkString( "ARCBank_Admin_GUI" )
	util.AddNetworkString( "ARCBank_Admin_Send" )
	util.AddNetworkString( "ARCBank_Admin_SendAccounts" )
	ARCBank.Commands["admin_gui"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			net.Start( "ARCBank_Admin_GUI" )
			net.WriteTable(ARCBank.Settings)
			net.WriteTable(ARCBank.SettingsDesc)
			net.WriteTable(file.Find( ARCBank.Dir.."/systemlog*", "DATA", "datedesc" ) )
			net.Send(ply)
		end, 
		usage = "",
		description = "Opens the admin interface.",
		adminonly = true,
		hidden = false
	}

	net.Receive( "ARCBank_Admin_Send", function(length,ply)
		if !ply:IsAdmin() && !ply:IsSuperAdmin() then return end
		local rank = net.ReadInt(ARCBANK_ACCOUNTBITRATE)
		local log = net.ReadString()
		local tab 
		if rank == 0 then
			tab = ARCBank.GetLogTable(ARCBank.Dir.."/"..log)
		else
			tab = ARCBank.GetLogTable(ARCBank.Logs[rank].."/"..log)
			
		end
		for i=1,#tab do
			timer.Simple((i/50),function()
				net.Start( "ARCBank_Admin_Send" )
				net.WriteString(tostring(i))
				net.WriteString(tostring(#tab))
				net.WriteString(tab[i])
				net.Send(ply)
			end)
		end
	end)
	net.Receive( "ARCBank_Admin_SendAccounts", function(length,ply)
		if !ply:IsAdmin() && !ply:IsSuperAdmin() then return end
		local rank = net.ReadInt(ARCBANK_ACCOUNTBITRATE)	
		local accounts = file.Find(ARCBank.Accounts[rank].."ACCOUNT_*","DATA")
		for i=1,#accounts do
			timer.Simple((i/50),function()
				local data = util.JSONToTable(file.Read(ARCBank.Accounts[rank]..accounts[i],"DATA"))
				data[ARCBANK_ID] = accounts[i]
				net.Start( "ARCBank_Admin_SendAccounts" )
				net.WriteString(tostring(i))
				net.WriteString(tostring(#accounts))
				net.WriteTable(data)
				net.Send(ply)
			end)
		end
	end)
end