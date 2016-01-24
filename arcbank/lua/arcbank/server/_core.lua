--Font: Eras Demi ITC
ARCBank.Outdated = false
ARCBank.HasCore = true
ARCBank.LogFileWritten = false
ARCBank.LogFile = ""
ARCBank.Loaded = false
ARCBank.Dir = "_arcbank"
ARCBank.AccountPrefix = "ACCOUNT_"
ARCBank.Accounts = {}
ARCBank.Accounts[ARCBANK_PERSONALACCOUNTS_] = ARCBank.Dir.."/personal_account/"
ARCBank.Accounts[ARCBANK_PERSONALACCOUNTS_STANDARD] = ARCBank.Dir.."/personal_account/standard/"
ARCBank.Accounts[ARCBANK_PERSONALACCOUNTS_BRONZE] = ARCBank.Dir.."/personal_account/bronze/"
ARCBank.Accounts[ARCBANK_PERSONALACCOUNTS_SILVER] = ARCBank.Dir.."/personal_account/silver/"
ARCBank.Accounts[ARCBANK_PERSONALACCOUNTS_GOLD] = ARCBank.Dir.."/personal_account/gold/"
ARCBank.Accounts[ARCBANK_GROUPACCOUNTS_] = ARCBank.Dir.."/group_account/"
ARCBank.Accounts[ARCBANK_GROUPACCOUNTS_STANDARD] = ARCBank.Dir.."/group_account/standard/"
ARCBank.Accounts[ARCBANK_GROUPACCOUNTS_PREMIUM] = ARCBank.Dir.."/group_account/premium/"
ARCBank.Logs = {}

ARCBank.Logs[ARCBANK_PERSONALACCOUNTS_] = ARCBank.Dir.."/personal_account/" --UNUSED
ARCBank.Logs[ARCBANK_PERSONALACCOUNTS_STANDARD] = ARCBank.Dir.."/personal_account/standard/logs/"
ARCBank.Logs[ARCBANK_PERSONALACCOUNTS_BRONZE] = ARCBank.Dir.."/personal_account/bronze/logs/"
ARCBank.Logs[ARCBANK_PERSONALACCOUNTS_SILVER] = ARCBank.Dir.."/personal_account/silver/logs/"
ARCBank.Logs[ARCBANK_PERSONALACCOUNTS_GOLD] = ARCBank.Dir.."/personal_account/gold/logs/"
ARCBank.Logs[ARCBANK_GROUPACCOUNTS_] = ARCBank.Dir.."/group_account/" --UNUSED
ARCBank.Logs[ARCBANK_GROUPACCOUNTS_STANDARD] = ARCBank.Dir.."/group_account/standard/logs/"
ARCBank.Logs[ARCBANK_GROUPACCOUNTS_PREMIUM] = ARCBank.Dir.."/group_account/premium/logs/"
ARCBank.Settings = {}
ARCBank.SettingsDesc = {}

ARCBank.Disk = {}
ARCBank.Disk.NommedCards = {}
ARCBank.Disk.ProperShutdown = false

function ARCBankAccountMsg(dir,msg)
	if !ARCBank then return end
	if ARCBank.LogFileWritten then
		file.Append(dir, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\n")
	end
end
hook.Add( "PlayerUse", "ARCBank NoUse", function( ply, ent ) 
	if ent != NULL && ent:IsValid() && !ent.IsAFuckingATM && table.HasValue(ARCBank.Disk.NommedCards,ply:SteamID()) then
		ply:PrintMessage( HUD_PRINTTALK, "ARCBank. Please exit the ATM before doing this." )
		return false
	end 
end)

hook.Add( "PhysgunPickup", "ARCBank NoPhys", function( ply, ent ) if ent.IsAFuckingATM && ent.ARCBank_MapEntity then return false end end)
hook.Add( "GravGunPunt", "ARCBank PuntHacker", function( ply, ent ) if ent:GetClass() == "sent_arc_atmhack" then ent:TakeDamage( 100, ply, ply:GetActiveWeapon() ) end end)
-- ARCBank.CreateAccount(player.GetByID( 1 ),4,100)
hook.Add( "PlayerAuthed", "ARCBank PlyAuth", function( ply ) 
	timer.Simple(10,function()
		if IsValid(ply) && ply:IsPlayer() && table.HasValue(ARCBank.Disk.NommedCards,ply:SteamID()) then
			ply:PrintMessage( HUD_PRINTTALK, "ARCBank. Hello! It seems that your card was eaten by an ATM last time you were on this server." )
		end
	end)
	timer.Simple(15,function()
		if IsValid(ply) && ply:IsPlayer() && table.HasValue(ARCBank.Disk.NommedCards,ply:SteamID()) then
			ply:PrintMessage( HUD_PRINTTALK, "ARCBank. Here's your card back! Have a good day!" )
			ply:Give("weapon_arc_atmcard")
			table.RemoveByValue(ARCBank.Disk.NommedCards,ply:SteamID())
		end
	end)
	timer.Simple(10,function()
		if IsValid(ply) && ply:IsPlayer() then
			for _,v in pairs(ents.FindByClass("sent_arc_atm")) do
				ply:SendLua("ents.GetByIndex("..v:EntIndex()..").ShowHolo = "..tostring(ARCBank.Settings["atm_holo"]))
				ply:SendLua("ents.GetByIndex("..v:EntIndex()..").HoloReal = "..tostring(ARCBank.Settings["atm_holo_flicker"]))
				ply:SendLua("ARCBank.UpdateLang(\""..ARCBank.Settings["atm_language"].."\")")
			end
		end
	end)
end)

ARCBank.SettingsDesc["atm_language"] = "What language should the ATM display? Choose between the following: en - fr - ger - pt_br"
ARCBank.SettingsDesc["starting_cash"] = "How much money the player starts with upon creating a personal account."
ARCBank.SettingsDesc["group_account_limit"] = "How many group accounts can a player have?"
ARCBank.SettingsDesc["perpetual_debt"] = "If the player is already in debt, they will gain more debt at the next 'interest time'."
ARCBank.SettingsDesc["autoban_time"] = "The amount of time a player will be banned for if they try to hack the system. (minutes)"
ARCBank.SettingsDesc["debt_limit"] = "The debt limit of an account."

ARCBank.SettingsDesc["interest_time"] = "The interval time of the giving of interest. (minutes)"

ARCBank.SettingsDesc["standard_interest"] = "The % of interest a standard account will gain when the next 'interest time' comes."
ARCBank.SettingsDesc["bronze_interest"] = "The % of interest a bronze account will gain when the next 'interest time' comes."
ARCBank.SettingsDesc["silver_interest"] = "The % of interest a silver account will gain when the next 'interest time' comes."
ARCBank.SettingsDesc["gold_interest"] = "The % of interest a gold account will gain when the next 'interest time' comes."
ARCBank.SettingsDesc["group_standard_interest"] = "The % of interest a standard group account will gain when the next 'interest time' comes."
ARCBank.SettingsDesc["group_premium_interest"] = "The % of interest a premium group account will gain when the next 'interest time' comes."

ARCBank.SettingsDesc["standard_requirement"] = "The in-game rank(s) the player must be to create a standard account. "
ARCBank.SettingsDesc["bronze_requirement"] = "The in-game rank(s) the player must be to create a bronze account."
ARCBank.SettingsDesc["silver_requirement"] = "The in-game rank(s) the player must be to create a silver account."
ARCBank.SettingsDesc["gold_requirement"] = "The in-game rank(s) the player must be to create a gold account."
ARCBank.SettingsDesc["group_standard_requirement"] = "The in-game rank(s) the player must be to create a group account."
ARCBank.SettingsDesc["group_premium_requirement"] = "The in-game rank(s) the player must be to create a premium group account."
ARCBank.SettingsDesc["everything_requirement"] = "People of these ranks can create any account."

ARCBank.SettingsDesc["atm_holo"] = "Should ATMs have a floating sign over them saying \"ATM\"? (Players must reconnect to see the changes.)"
ARCBank.SettingsDesc["atm_holo_flicker"] = "Should the ATMs floating signs have realistic hologram effects?"
ARCBank.SettingsDesc["atm_hack_notify"] = "(Dark RP Only) Players with the following jobs will be notified when an ATM is being hacked."
function ARCBank.SaveDisk()
	ARCBank.Disk.ProperShutdown = true
	file.Write(ARCBank.Dir.."/__data.txt", util.TableToJSON(ARCBank.Disk) )
end
--[[
 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         
																														 
I have recieved too many questions regarding the "config file" or "The ATM is saying Contact an admin".

So, let me try to explain something to you...
																														 
DO NOT EDIT THIS FILE TO CHANGE THE CONFIG! READ THE GODDAMN README!


arcbank help
^ GIVES YOU A FULL AND DETAILED DESCRIPTION OF ALL COMMANDS

arcbank settings_help (setting)
^ GIVES YOU A FULL DESCRIPTION OF ALL SETTINGS (Leave blank to show a list of all settings.)

arcbank settings (setting) (value)
^ SETS THE SETTING YOU WANT TO THE SPECIFIED VALUE.
]]
function ARCBank.SettingsReset() --DO NOT EDIT THIS!!!!
	--ARCBank.Settings[""]
	
	ARCBank.Settings["atm_hack_notify"] = {"civil protection"}
	ARCBank.Settings["atm_language"] = "en" --DO NOT EDIT THIS!!!!
	
	ARCBank.Settings["atm_holo"] = true --DO NOT EDIT THIS!!!!
	ARCBank.Settings["atm_holo_flicker"] = true --DO NOT EDIT THIS!!!!
	ARCBank.Settings["group_account_limit"] = 4 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["starting_cash"] = 500 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["perpetual_debt"] = false --DO NOT EDIT THIS!!!!
	ARCBank.Settings["autoban_time"] = 120 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["debt_limit"] = 10000  --DO NOT EDIT THIS!!!!
	
	ARCBank.Settings["interest_time"] = 300 --DO NOT EDIT THIS!!!!
	
	ARCBank.Settings["standard_interest"] = 1 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["bronze_interest"] = 2 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["silver_interest"] = 4 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["gold_interest"] = 8 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["group_standard_interest"] = 2.5 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["group_premium_interest"] = 5 --DO NOT EDIT THIS!!!!
	ARCBank.Settings["standard_requirement"] = {"user"} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["bronze_requirement"] = {} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["silver_requirement"] = {} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["gold_requirement"] = {"admin"} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["group_standard_requirement"] = {} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["group_premium_requirement"] = {"admin"} --DO NOT EDIT THIS!!!!
	ARCBank.Settings["everything_requirement"] = {"operator","superadmin"} --DO NOT EDIT THIS!!!!
end
ARCBank.SettingsReset()
function ARCBank.AddAccountInterest()
	ARCBankMsg("Giving free money...")
	for i,dir in pairs(ARCBank.Accounts) do
		for _,account in pairs(file.Find( dir.."*", "DATA" )) do
			local rank
			if i > 5 then
				rank = "group_"..string.Explode( "/",dir)[3]
			else
				rank = string.Explode( "/",dir)[3]
			end
			local accountdata = util.JSONToTable(file.Read(dir..account, "DATA" ))
			if accountdata && tonumber(accountdata[ARCBANK_BALANCE]) > 0 then

				accountdata[ARCBANK_BALANCE] = tostring(math.Round(tonumber(accountdata[ARCBANK_BALANCE])*(1+(ARCBank.Settings[rank.."_interest"]/100))))
				if tonumber(accountdata[ARCBANK_BALANCE]) > 1e14 then
					accountdata[ARCBANK_BALANCE] = "1e14"
				end
				file.Write(dir..account,util.TableToJSON(accountdata))
				ARCBankAccountMsg(ARCBank.Logs[i]..account,"Added "..tostring(ARCBank.Settings[rank.."_interest"]).."% interest to account. ("..accountdata[ARCBANK_BALANCE]..")")
			end
		end
	end
end
function ARCBank.GetAccountID(name)
	return ARCBank.AccountPrefix..string.upper(string.gsub(name, "[^_%w]", "_"))
end
function ARCBank.GetLogTable(dir)
	if !ARCBank.Loaded then return {"**ARCBank File Viewer Error**","","System didn't load properly!"} end
	
	if file.Exists( dir, "DATA" ) then
		local shit = string.Explode( "\n", file.Read( dir, "DATA" ) )
		table.remove(shit)
		return shit
	else
		return {"**ARCBank File Viewer Error**","","Requested File: ",dir,"","File doesn't exist!"}
	end
end
function ARCBank.CreateAccount(ply,rank,initbalance,groupname)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local newb = true
	for k,v in pairs( ARCBank.Settings["everything_requirement"] ) do
		if ply:IsUserGroup( v ) then
			newb = false
			MsgN(ply:Nick().." is "..v)
		end
	end
	if newb then
		if rank < ARCBANK_GROUPACCOUNTS_ then
			for i=rank,ARCBANK_PERSONALACCOUNTS_GOLD do
				for k,v in pairs( ARCBank.Settings[""..ARCBANK_ACCOUNTSTRINGS[i].."_requirement"] ) do
					if ply:IsUserGroup( v ) then
						newb = false
						MsgN(ply:Nick().." is "..v)
					end
				end
			end
		else
			for i=rank,ARCBANK_GROUPACCOUNTS_PREMIUM do
				for k,v in pairs( ARCBank.Settings[""..ARCBANK_ACCOUNTSTRINGS[i].."_requirement"] ) do
					if ply:IsUserGroup( v ) then
						newb = false
						MsgN(ply:Nick().." is "..v)
					end
				end
			end
		end
	end
	if newb then return ARCBANK_ERROR_UNDERLING end
	local accountdata = {}
	local filename
	if !groupname || groupname == "" || rank < ARCBANK_GROUPACCOUNTS_ then
		accountdata[ARCBANK_NAME] =  ply:Nick()
		filename = ARCBank.AccountPrefix..string.Replace( ply:SteamID(), ":", "_" )..".txt"
	else
		accountdata.players = {}
		accountdata[ARCBANK_GROUP_OWNER] = ply:SteamID()
		accountdata[ARCBANK_NAME] = groupname
		filename = ARCBank.GetAccountID(groupname)..".txt"
	end
	accountdata[ARCBANK_BALANCE] = tostring(initbalance)
	--for i=1,7 do
		--if file.Exists(ARCBank.Accounts[i]..filename,"DATA") then
		if file.Exists(ARCBank.Accounts[rank]..filename,"DATA") then
			ARCBankMsg(ply:Nick().."("..ply:SteamID()..") Attempted to create a dupe account. \""..ARCBank.Accounts[rank]..filename.."\" Already exists.")
			return ARCBANK_ERROR_NAME_DUPE
		end
	--end
	file.Write(ARCBank.Accounts[rank]..filename,util.TableToJSON(accountdata))
	if !file.Exists(ARCBank.Accounts[rank]..filename,"DATA") then
		ARCBankMsg(ply:Nick().."("..ply:SteamID()..") failed to create an account. \""..ARCBank.Accounts[rank]..filename.."\" is not a valid name.")
		return ARCBANK_ERROR_INVALID_NAME
	end
	ARCBankMsg(ply:Nick().."("..ply:SteamID()..") ceated an account named "..accountdata[ARCBANK_NAME].." with "..initbalance.." munnies in "..ARCBank.Accounts[rank]..filename)
	ARCBankAccountMsg(ARCBank.Logs[rank]..filename,"Account Created/Reset!")
	return ARCBANK_ERROR_NONE
end
function ARCBank.RemoveAccount(ply,groupname)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accountdir = ARCBank.GetAccountDir(groupname,ply)
	if !isstring(accountdir) then
		return accountdir
	end
	local accountdata = util.JSONToTable(file.Read(accountdir, "DATA" ))
	if !accountdata then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	if tonumber(accountdata[ARCBANK_BALANCE]) < 0 then
		return ARCBANK_ERROR_DEBT
	end
	file.Delete(accountdir) 
	ARCBankMsg(ply:Nick().."("..ply:SteamID()..") closed their account named "..accountdata[ARCBANK_NAME].." in "..accountdir)
	return ARCBANK_ERROR_NONE
end
function ARCBank.AddPlayerToGroup(ply,newguysteamid,groupname)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accountdata
	local accountdir
	local accountrank
	for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to premium
		local f = ARCBank.Accounts[rank]..ARCBank.GetAccountID(groupname)..".txt"
		if file.Exists( f, "DATA" ) then
			accountdata = util.JSONToTable(file.Read(f, "DATA" ))
			if accountdata[ARCBANK_GROUP_OWNER] != ply:SteamID() then --Only owners can add/remove players from a group.
				return ARCBANK_ERROR_NO_ACCES
			end
			accountdir = f
			accountrank = rank
		end
	end
	if !accountdata then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	if table.HasValue(accountdata.players,newguysteamid) || newguysteamid == ply:SteamID() then
		return ARCBANK_ERROR_DUPE_PLAYER
	end
	local accountfile = string.Replace(string.GetFileFromFilename( accountdir ),".txt","")
	table.insert( accountdata.players, newguysteamid )
	file.Write(accountdir,util.TableToJSON(accountdata))
	ARCBankAccountMsg(ARCBank.Logs[accountrank]..accountfile..".txt","Added ("..newguysteamid..") to group.")
	return ARCBANK_ERROR_NONE
end
function ARCBank.RemovePlayerFromGroup(ply,guysteamid,groupname)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accountdata
	local accountdir
	local accountrank
	for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to premium
		local f = ARCBank.Accounts[rank]..ARCBank.GetAccountID(groupname)..".txt"
		if file.Exists( f, "DATA" ) then
			accountdata = util.JSONToTable(file.Read(f, "DATA" ))
			if accountdata[ARCBANK_GROUP_OWNER] != ply:SteamID() then --Only owners can add/remove players from a group.
				return ARCBANK_ERROR_NO_ACCES
			end
			accountdir = f
			accountrank = rank
		end
	end
	if !accountdata then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	local accountfile = string.Replace(string.GetFileFromFilename( accountdir ),".txt","")
	if !table.HasValue(accountdata.players,guysteamid) then
		return ARCBANK_ERROR_NIL_PLAYER
	end
	table.RemoveByValue( accountdata.players, guysteamid ) 
	file.Write(accountdir,util.TableToJSON(accountdata))
	ARCBankAccountMsg(ARCBank.Logs[accountrank]..accountfile..".txt","Removed ("..guysteamid..") from group.")
	return ARCBANK_ERROR_NONE
end
function ARCBank.GroupAccountAcces(ply)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local sid = ""
	if !isstring(ply)&& ply:IsPlayer() then
		sid = ply:SteamID()
	elseif string.StartWith(ply,"STEAM_") then
		sid = ply
	else
		return ARCBANK_ERROR_NIL_PLAYER
	end
	local names = {}
	for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to gold
		local files, directories = file.Find( ARCBank.Accounts[rank].."*", "DATA" )
		for _,v in pairs( files ) do
			local accountdata = util.JSONToTable(file.Read( ARCBank.Accounts[rank]..v, "DATA" ))
			if accountdata[ARCBANK_GROUP_OWNER] == sid || table.HasValue( accountdata.players, sid ) then
				table.insert( names, accountdata[ARCBANK_NAME] )
			end
		end
	end
	return names
end
--lua_run ARCBank.AtmFunc(0,player.GetByID(1),10)
function ARCBank.GetAccountDir(groupname,ply)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local sid = ""
	if isstring(ply) && string.StartWith(ply,"STEAM_") then
		sid = ply
	elseif ply:SteamID() then
		sid = ply:SteamID()
	else
		return ARCBANK_ERROR_NIL_PLAYER
	end
	local accountdir
	local accountrank
	if !groupname || groupname == "" then --If no group name is specified, we assume it's for a personal transaction.
		for rank=ARCBANK_PERSONALACCOUNTS_STANDARD,ARCBANK_PERSONALACCOUNTS_GOLD do --check from standard to premium
			local f = ARCBank.Accounts[rank]..ARCBank.AccountPrefix..string.Replace( sid, ":", "_" )..".txt"
			if file.Exists( f, "DATA" ) then
				accountdir = f
				accountrank = rank
			end
		end
	else
		for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to premium
			local f = ARCBank.Accounts[rank]..ARCBank.GetAccountID(groupname)..".txt"
			if file.Exists( f, "DATA" ) then
				accountdir = f
				accountrank = rank
				local accountdata = util.JSONToTable(file.Read( f, "DATA" ))
				if accountdata[ARCBANK_GROUP_OWNER] != sid && !table.HasValue( accountdata.players, sid ) then
					accountdir = ARCBANK_ERROR_NO_ACCES
					accountrank = nil
				end
			end
		end
	end
	if !accountdir then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	return accountdir,accountrank
end
function ARCBank.CanAfford(ply,amount,groupname)
if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accountdir = ARCBank.GetAccountDir(groupname,ply)
	if !isstring(accountdir) then
		return accountdir
	end
	local accountdata = util.JSONToTable(file.Read(accountdir, "DATA" ))
	if !accountdata then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	if tonumber(accountdata[ARCBANK_BALANCE])+ARCBank.Settings["debt_limit"] < amount then
		return ARCBANK_ERROR_NO_CASH
	end
	return ARCBANK_ERROR_NONE
end
function ARCBank.GetAllAccounts(amount)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accounts = {}
	for rank=ARCBANK_PERSONALACCOUNTS_STANDARD,ARCBANK_PERSONALACCOUNTS_GOLD do --check from standard to premium
		local files, directories = file.Find( ARCBank.Accounts[rank].."*", "DATA" )
		for _,v in pairs( files ) do
			if string.StartWith( v, ARCBank.AccountPrefix.."STEAM_" ) then
				local accountdata = util.JSONToTable(file.Read( ARCBank.Accounts[rank]..v, "DATA" ))
				if tonumber(accountdata[ARCBANK_BALANCE])+ARCBank.Settings["debt_limit"] >= amount then
					table.insert(accounts,ARCBank.Accounts[rank]..v)
				end
			end
		end
	end
	for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to gold
		local files, directories = file.Find( ARCBank.Accounts[rank].."*", "DATA" )
		for _,v in pairs( files ) do
			if string.StartWith( v, ARCBank.AccountPrefix ) then
				local accountdata = util.JSONToTable(file.Read( ARCBank.Accounts[rank]..v, "DATA" ))
				if tonumber(accountdata[ARCBANK_BALANCE])+ARCBank.Settings["debt_limit"] >= amount then
					table.insert(accounts,math.Round((#accounts/1.75)*(rank-5)),ARCBank.Accounts[rank]..v)
				end
			end
		end
	end
	return accounts
end
function ARCBank.PlayerCanAfford(ply,amount)
	if GAMEMODE.Name=="DarkRP" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) then
			return ply:canAfford(amount)
		else
			return ply:CanAfford(amount)
		end
	else
		return true
	end
end
function ARCBank.PlayerAddMoney(ply,amount)
	if string.lower(GAMEMODE.Name) == "darkrp" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) then
			ply:addMoney(amount)
		else
			ply:AddMoney(amount)
		end
	else
		ply:SendLua("notification.AddLegacy( \"I'm going to pretend that your wallet is unlimited because this is an unsupported gamemode.\", 0, 5 )")
	end
end
function ARCBank.StealMoney(ply,amount,victimaccountdir,hidden)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	
	if victimaccountdir == "*stealth mode*" then
		local accounts = ARCBank.GetAllAccounts(amount)
		local money = 0
		for i=1,math.floor(amount/5) do
			ARCBank.StealMoney(ply,5,accounts[arc_randomexp(1,#accounts)],true)
			money = money + 5
		end
		ARCBankMsg(ply:Nick().."("..ply:SteamID()..") performed a stealthy hack. All accounts were affected. Stole a total of "..tostring(amount))
	else
		local accountdata = util.JSONToTable(file.Read(victimaccountdir, "DATA" ))
		if !accountdata then
			return ARCBANK_ERROR_NIL_ACCOUNT
		end
		accountdata[ARCBANK_BALANCE] = tostring(tonumber(accountdata[ARCBANK_BALANCE]) - amount)
		file.Write(victimaccountdir,util.TableToJSON(accountdata))
		if !hidden then
			ARCBankMsg(ply:Nick().."("..ply:SteamID()..") hacked into "..victimaccountdir.." stole "..tostring(amount))
		end
	end
	
	ARCBank.PlayerAddMoney(ply,amount)
	return ARCBANK_ERROR_NONE
end
function ARCBank.AtmFunc(take,ply,amount,groupname)
	return ARCBank._AtmFunc(take,ply,amount,groupname)
end
function ARCBank._AtmFunc(take,ply,amount,groupname)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	if take == 0 then take = -1 end
	local accountdir,accountrank = ARCBank.GetAccountDir(groupname,ply)
	if !isstring(accountdir) then
		return accountdir
	end
	local accountdata = util.JSONToTable(file.Read(accountdir, "DATA" ))
	--ply:Nick().."("..ply:SteamID..")"
	if !accountdata then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	local accountfile = string.Replace(string.GetFileFromFilename( accountdir ),".txt","")
	local mode = "Added "..amount.." to "
	if take == 1 then
		mode = "Subtracted "..amount.." from "
		if tonumber(accountdata[ARCBANK_BALANCE])+ARCBank.Settings["debt_limit"] < amount then
			ARCBankMsg(ply:Nick().."("..ply:SteamID()..")  Tried to take too much cash from "..accountdata[ARCBANK_NAME].."'s account. ("..accountfile..") (From "..accountdata[ARCBANK_BALANCE].." to "..tonumber(accountdata[ARCBANK_BALANCE])-amount..")")
			--ARCBankAccountMsg(ARCBank.Logs[accountrank]..accountfile..".txt",ply:Nick().."("..ply:SteamID()..") tried to take too much cash from account. (From "..accountdata[ARCBANK_BALANCE].." to "..accountdata[ARCBANK_BALANCE]-amount..")")
			return ARCBANK_ERROR_NO_CASH
		end
	else
		if !ARCBank.PlayerCanAfford(ply,amount) then
			ARCBankMsg(ply:Nick().."("..ply:SteamID()..") didn't have enough cash to do his transaction.")
			return ARCBANK_ERROR_NO_CASH_PLAYER
		end
	end
	accountdata[ARCBANK_BALANCE] = tostring(tonumber(accountdata[ARCBANK_BALANCE]) + (amount*-take))
	if tonumber(accountdata[ARCBANK_BALANCE]) >= 1e14 && take == -1 then
		return ARCBANK_ERROR_TOO_MUCH_CASH
	end
	ARCBank.PlayerAddMoney(ply,amount*take)
	--playermoney = playermoney + (amount*take)
	ARCBankMsg(ply:Nick().."("..ply:SteamID()..") "..mode..accountdata[ARCBANK_NAME].."'s Account. ("..accountfile..") (From "..tonumber(accountdata[ARCBANK_BALANCE])-(amount*-take).." to "..accountdata[ARCBANK_BALANCE]..")")
	ARCBankAccountMsg(ARCBank.Logs[accountrank]..accountfile..".txt","("..ply:SteamID()..")\n"..mode.."Account. (From "..tonumber(accountdata[ARCBANK_BALANCE])-(amount*-take).." to "..accountdata[ARCBANK_BALANCE]..")")
	file.Write(accountdir,util.TableToJSON(accountdata))
	return ARCBANK_ERROR_NONE
end
function ARCBank.Transfer(fromply,toply,fromname,toname,amount,reason)
	if !ARCBank.Loaded then return ARCBANK_ERROR_NOT_LOADED end
	local accountdirfrom,accountrankfrom = ARCBank.GetAccountDir(fromname,fromply)
	if !isstring(accountdirfrom) then
		return accountdirfrom
	end
	local accountdatafrom = util.JSONToTable(file.Read(accountdirfrom, "DATA" ))

	local accountdirto,accountrankto = ARCBank.GetAccountDir(toname,toply)
	if !isstring(accountdirto) then
		return accountdirto
	end
	local accountdatato = util.JSONToTable(file.Read(accountdirto, "DATA" ))
	if !fromname || fromname == "" then
		accountdatafrom[ARCBANK_NAME] = fromply:Nick()
	end
	if (!toname || toname == "") && toply:IsPlayer() then
		accountdatato[ARCBANK_NAME] = toply:Nick()
	end
	if !accountdatato || !accountdatato then
		return ARCBANK_ERROR_NIL_ACCOUNT
	end
	local accountfilefrom = string.Replace(string.GetFileFromFilename( accountdirfrom ),".txt","")
	local accountfileto = string.Replace(string.GetFileFromFilename( accountdirto ),".txt","")
	if tonumber(accountdatafrom[ARCBANK_BALANCE])+ARCBank.Settings["debt_limit"] < amount then
		ARCBankAccountMsg(ARCBank.Logs[accountrankfrom]..accountfilefrom..".txt",fromply:Nick().."("..fromply:SteamID()..")\n tried to take too much cash from account. (From "..accountdatafrom[ARCBANK_BALANCE].." to "..tonumber(accountdatafrom[ARCBANK_BALANCE])-amount..")")
		ARCBankMsg(fromply:Nick().."("..fromply:SteamID()..") tried to give "..amount.." to "..toply:Nick().."("..toply:SteamID().."), but he/she didn't have enough money D: (From Accounts "..accountfilefrom.." to "..accountfileto..")")
		return ARCBANK_ERROR_NO_CASH
	end
	if accountdirfrom != accountdirto then --Fixed an exploit that the player could create more money
		accountdatafrom[ARCBANK_BALANCE] = tostring(tonumber(accountdatafrom[ARCBANK_BALANCE]) - amount)
		accountdatato[ARCBANK_BALANCE] = tostring(tonumber(accountdatato[ARCBANK_BALANCE]) + amount)
	end
	file.Write(accountdirfrom,util.TableToJSON(accountdatafrom))
	file.Write(accountdirto,util.TableToJSON(accountdatato))
	ARCBankAccountMsg(ARCBank.Logs[accountrankfrom]..accountfilefrom..".txt","("..fromply:SteamID()..")\ngave "..amount.." to ("..toply:SteamID()..") (From accounts [this one] to "..accountfileto..") ["..tostring(reason).."]")
	ARCBankAccountMsg(ARCBank.Logs[accountrankto]..accountfileto..".txt","("..fromply:SteamID()..")\ngave "..amount.." to ("..toply:SteamID()..") (From accounts "..accountfilefrom.." to [this one]) ["..tostring(reason).."]")
	ARCBankMsg(fromply:Nick().."("..fromply:SteamID()..") gave "..amount.." to "..toply:Nick().."("..toply:SteamID()..") (From accounts "..accountfilefrom.." to "..accountfileto..") ["..tostring(reason).."]")	
	return ARCBANK_ERROR_NONE
end

hook.Add( "PreCleanupMap", "ARCBank PreATM", function()
	for _, oldatms in pairs( ents.FindByClass("sent_arc_atm") ) do
		oldatms.ARCBank_MapEntity = false
		oldatms:Remove()
	end
end )
hook.Add( "PostCleanupMap", "ARCBank PreATM", function() --[[timer.Simple(10,function() ]]ARCBank.SpawnATMs()--[[ end ) ]]end )
hook.Add( "InitPostEntity", "ARCBank SpawnATMs", function() --[[timer.Simple(10,function() ]]ARCBank.SpawnATMs()--[[ end ) ]]end )
function ARCBank.SpawnATMs()
	local shit = file.Read(ARCBank.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt", "DATA" )
	if !shit then
		ARCBankMsg("Cannot spawn ATMs. No file associated with this map.")
		return false
	end
	local atmdata = util.JSONToTable(shit)
	if !atmdata then
		ARCBankMsg("Cannot spawn ATMs. Currupt file associated with this map.")
		return false
	end
	for _, oldatms in pairs( ents.FindByClass("sent_arc_atm") ) do
		oldatms.ARCBank_MapEntity = false
		oldatms:Remove()
	end
	ARCBankMsg("Spawning Map ATMs...")
	for i=1,atmdata.atmcount do
			local shizniggle = ents.Create ("sent_arc_atm")
			if !IsValid(shizniggle) then
				atmdata.atmcount = 1
				ARCBankMsg("ATMs failed to spawn.")
			return false end
			shizniggle:SetPos(atmdata.pos[i])
			shizniggle:SetAngles(atmdata.angles[i])
			shizniggle:Spawn()
			shizniggle:Activate()
			local phys = shizniggle:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion( false )
			end
			shizniggle.ARCBank_MapEntity = true
			shizniggle.ARitzDDProtected = true
	end
	return true
end
function ARCBank.SaveATMs()
	ARCBankMsg("Saving ATMs...")
	local atmdata = {}
	atmdata.angles = {}
	atmdata.pos = {}
	local atms = ents.FindByClass("sent_arc_atm")
	atmdata.atmcount = table.maxn(atms)
	if atmdata.atmcount <= 0 then
		ARCBankMsg("No ATMs to save!")
		return false
	end
	for i=1,atmdata.atmcount do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		atms[i].ARCBank_MapEntity = true
		atms[i].ARitzDDProtected = true
		atmdata.pos[i] = atms[i]:GetPos()
		atmdata.angles[i] = atms[i]:GetAngles()
	end
	PrintTable(atmdata)
	local savepos = ARCBank.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Write(savepos,util.TableToJSON(atmdata))
	if file.Exists(savepos,"DATA") then
		ARCBankMsg("ATMs Saved in: "..savepos)
		return true
	else
		ARCBankMsg("Error while saving map.")
		return false
	end
end
function ARCBank.UnSaveATMs()
	ARCBankMsg("UnSaving ATMs...")
	local atms = ents.FindByClass("sent_arc_atm")
	if table.maxn(atms) <= 0 then
		ARCBankMsg("No ATMs to Unsave!")
		return false
	end
	for i=1,table.maxn(atms) do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( true )
		end
		atms[i].ARCBank_MapEntity = false
		atms[i].ARitzDDProtected = false
	end
	local savepos = ARCBank.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Delete(savepos)
	return true
end
function ARCBank.ClearATMs()
	for _, oldatms in pairs( ents.FindByClass("sent_arc_atm") ) do
		oldatms.ARCBank_MapEntity = false
		oldatms:Remove()
	end
	ARCBankMsg("All ATMs Removed.")
end
hook.Add( "ShutDown", "ARCBank Shutdown", function() 
	ARCBank.ClearATMs()
	ARCBank.SaveDisk()
	file.Write(ARCBank.Dir.."/__data.txt", util.TableToJSON(ARCBank.Disk) )	
	file.Write(ARCBank.Dir.."/_saved_settings.txt",util.TableToJSON(ARCBank.Settings))
end )
function ARCBank.Load()
	ARCBank.Loaded = false
--[[
	http.Fetch( "http://dl.dropboxusercontent.com/u/14940709/ADDONS/arcbank/CurrentVer.txt",
	function( body, len, headers, code )
		-- The first argument is the HTML we asked for.
		ARCBankMsg("HTTP: "..body)
	end,
	function( error )
		ARCBankMsg("WARNING! Failed to get update version. ("..error..")")
	end
	);
	]]
--[[
	ARCBankMsg("Running Directory Check...")
	if game.SinglePlayer() then
		ARCBankMsg("CRITICAL ERROR! THIS IS A SINGLE PLAYER GAME!")
		ARCBankMsg("LOADING FALIURE!")
		return
	end
]]
	if !file.IsDir( ARCBank.Dir, "DATA" ) then
		ARCBankMsg("Created Folder: "..ARCBank.Dir)
		file.CreateDir(ARCBank.Dir)
	end
	
	if !file.IsDir( ARCBank.Dir, "DATA" ) then
		ARCBankMsg("CRITICAL ERROR! FAILED TO CREATE ROOT FOLDER!")
		ARCBankMsg("LOADING FALIURE!")
		return
	end
	if !file.Exists(ARCBank.Dir.."/_about_atm.txt","DATA") then
		ARCBankMsg("Copied atm about file")
		file.Write(ARCBank.Dir.."/_about_atm.txt", file.Read( "arcbank/data/about_atm.lua", "LUA" ) )
	end
	--		 = false
	if file.Exists(ARCBank.Dir.."/__data.txt","DATA") then
		ARCBank.Disk = util.JSONToTable(file.Read( ARCBank.Dir.."/__data.txt", "DATA" ))
	end
	if ARCBank.Disk.ProperShutdown then
		ARCBank.Disk.ProperShutdown = false
	else
		ARCBankMsg("WARNING! THE SYSTEM DIDN'T SHUT DOWN PROPERLY!")
	end
	
	if file.Exists(ARCBank.Dir.."/_saved_settings.txt","DATA") then
		local disksettings = util.JSONToTable(file.Read(ARCBank.Dir.."/_saved_settings.txt","DATA"))
		if disksettings then
			for k,v in pairs(ARCBank.Settings) do
				if disksettings[k] || isbool(disksettings[k]) then
					ARCBank.Settings[k] = disksettings[k]
				else
					ARCBankMsg(""..k.." not found in disk settings. Possibly out of date. Using default.")
				end
			end
			ARCBankMsg("Settings succesfully set.")
		else
			ARCBankMsg("Settings file is corrupt or something! Using defaults.")
		end
	else
		ARCBankMsg("No settings file found! Using defaults.")
	end
	
	ARCBank.UpdateLang(ARCBank.Settings["atm_language"])
	for _,v in pairs(player.GetHumans()) do
		if IsValid(v) && v:IsPlayer() then
			v:SendLua("ARCBank.UpdateLang(\""..ARCBank.Settings["atm_language"].."\")")
		end
	end
		
		
	for _,v in pairs( ARCBank.Accounts ) do
		if !file.IsDir( v, "DATA" ) then
			ARCBankMsg("Created Folder: "..v)
			file.CreateDir(v)
		end
	end
	for _,v in pairs( ARCBank.Logs ) do
		if !file.IsDir( v, "DATA" ) && v != ARCBANK_PERSONALACCOUNTS_ && v != ARCBANK_GROUPACCOUNTS_ then
			ARCBankMsg("Created Folder: "..v)
			file.CreateDir(v)
		end
	end
	if !file.IsDir( ARCBank.Dir.."/saved_atms", "DATA" ) then
		ARCBankMsg("Created Folder: "..ARCBank.Dir.."/saved_atms")
		file.CreateDir(ARCBank.Dir.."/saved_atms")
	end
	ARCBank.LogFile = os.date(ARCBank.Dir.."/systemlog - %d %b %Y - "..tostring(os.date("%H")*60+os.date("%M"))..".log.txt")
	file.Write(ARCBank.LogFile,"***ARCBank System Log***    \nIT IS RECCOMENDED TO USE NOTEPAD++ TO VIEW THIS FILE!    \nDates are in DD-MM-YYYY\n")
	ARCBank.LogFileWritten = true
	ARCBankMsg("Log File Created at "..ARCBank.LogFile)
	ARCBankMsg("**STARTING FILESYSTEM CHECK!**")
	ARCBankMsg("Checking Personal Accounts...")
	for rank=ARCBANK_PERSONALACCOUNTS_STANDARD,ARCBANK_PERSONALACCOUNTS_GOLD do --check from standard to premium
		ARCBankMsg(ARCBank.Accounts[rank])
		local files, directories = file.Find( ARCBank.Accounts[rank].."*", "DATA" )
		ARCBankMsg(tostring(#files).." accounts found.")
		for _,v in pairs( files ) do
			if string.StartWith( v, ARCBank.AccountPrefix.."STEAM_" ) then
				ARCBankMsg("    Account: "..v)
				local accountdata = util.JSONToTable(file.Read( ARCBank.Accounts[rank]..v, "DATA" ))
				if !accountdata then
					ARCBankMsg("        WARNING! file is is corrupt or something! REMOVING!")
					file.Delete( ARCBank.Accounts[rank]..v )
				else
					ARCBankMsg("        Name: "..tostring(accountdata[ARCBANK_NAME]))
					ARCBankMsg("        Balance: "..tostring(accountdata[ARCBANK_BALANCE]))
				end
			else
				ARCBankMsg("Warning! Stray file: "..v)
			end
		end
	end
	ARCBankMsg("Personal Accounts Done!")
	
	ARCBankMsg("Checking Group Accounts...")
	for rank=ARCBANK_GROUPACCOUNTS_STANDARD,ARCBANK_GROUPACCOUNTS_PREMIUM do --check from standard to gold
		ARCBankMsg(ARCBank.Accounts[rank])
		local files, directories = file.Find( ARCBank.Accounts[rank].."*", "DATA" )
		ARCBankMsg(tostring(#files).." accounts found.")
		for _,v in pairs( files ) do
				if string.StartWith( v, ARCBank.AccountPrefix ) then
				ARCBankMsg("    Account: "..v)
				local accountdata = util.JSONToTable(file.Read( ARCBank.Accounts[rank]..v, "DATA" ))
				if !accountdata then
					ARCBankMsg("        WARNING! file is corrupt or something! REMOVING!")
					file.Delete( ARCBank.Accounts[rank]..v )
				else
					ARCBankMsg("        Name: "..tostring(accountdata[ARCBANK_NAME]))
					ARCBankMsg("        Balance: "..tostring(accountdata[ARCBANK_BALANCE]))
					if !accountdata[ARCBANK_GROUP_OWNER] || !string.StartWith( accountdata[ARCBANK_GROUP_OWNER], "STEAM_" ) then
						ARCBankMsg("        WARNING! Owner of account is invalid! REMOVING!")
						file.Delete( ARCBank.Accounts[rank]..v )
					else
						ARCBankMsg("        Group Owner: "..tostring(accountdata[ARCBANK_GROUP_OWNER]))
					end
					if !accountdata.players then
						ARCBankMsg("        WARNING! File doesn't have a player acces table! REMOVING!")
						file.Delete( ARCBank.Accounts[rank]..v )
					else
						ARCBankMsg("        Players with acces:")
						for __,vv in pairs(accountdata.players) do
							ARCBankMsg("            "..vv)
						end
					end
				end
			else
				ARCBankMsg("Warning! Stray file: "..v)
			end
		end
	end
	ARCBankMsg("Group Accounts Done!")
	
	ARCBankMsg("**END OF FILESYSTEM CHECK!**")
	if timer.Exists( "ARCBANK_INTEREST" ) then
		ARCBankMsg("Stopping current interest timer...")
		timer.Destroy( "ARCBANK_INTEREST" )
	end
	ARCBankMsg("Giving out interest every "..string.NiceTime(ARCBank.Settings["interest_time"]*60))
	timer.Create( "ARCBANK_INTEREST", ARCBank.Settings["interest_time"]*60, 0, function() ARCBank.AddAccountInterest() end )
	timer.Start( "ARCBANK_INTEREST" ) 
	if timer.Exists( "ARCBANK_SAVEDISK" ) then
		ARCBankMsg("Stopping current savedisk timer...")
		timer.Destroy( "ARCBANK_SAVEDISK" )
	end
	timer.Create( "ARCBANK_SAVEDISK", 5*60, 0, function() 
		file.Write(ARCBank.Dir.."/__data.txt", util.TableToJSON(ARCBank.Disk) )
		ARCBank.UpdateLang(ARCBank.Settings["atm_language"])
		for _,v in pairs(player.GetHumans()) do
			if IsValid(v) && v:IsPlayer() then
				v:SendLua("ARCBank.UpdateLang(\""..ARCBank.Settings["atm_language"].."\")")
			end
		end
	end )
	timer.Start( "ARCBANK_SAVEDISK" ) 
	ARCBank.Loaded = true
end
ARCBank.VarTypeExamples = {}
ARCBank.VarTypeExamples["list"] = {"aritz,snow,cathy,kenzie,issac","bob,joe,frank,bill","red,green,blue,yellow","lol,wtf,omg,rly"}
ARCBank.VarTypeExamples["number"] = {"1337","15","27","9","69"}
ARCBank.VarTypeExamples["boolean"] = {"true","false"}
ARCBank.VarTypeExamples["string"] = {"word","helloworld","iloveyou","MONEY!","bob","aritz"}
ARCBank.Commands = { --Make sure they are less then 16 chars long.$
	["help"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			if args[1] then
				if ARCBank.Commands[args[1]] then
					ARCBankMsgCL(ply,args[1]..tostring(ARCBank.Commands[args[1]].usage).." - "..tostring(ARCBank.Commands[args[1]].description))
				else
					ARCBankMsgCL(ply,"No such command as "..tostring(args[1]))
				end
			else
				local cmdlist = "\n*** ARCBANK HELP MENU ***\n\nSyntax:\n<name(type)> = required argument\n[name(type)] = optional argument\n\nList of commands:"
				for key,a in SortedPairs(ARCBank.Commands) do
					if !ARCBank.Commands[key].hidden then
						local desc = "*                                                 - "..ARCBank.Commands[key].description.."" -- +2
						for i=1,string.len( key..ARCBank.Commands[key].usage ) do
							desc = string.SetChar( desc, (i+2), string.GetChar( key..ARCBank.Commands[key].usage, i ) )
						end
						cmdlist = cmdlist.."\n"..desc
					end
				end
				for _,v in pairs(string.Explode( "\n", cmdlist ))do
					ARCBankMsgCL(ply,v)
				end
			end
			
		end, 
		usage = " [command(string)]",
		description = "Gives you a description of every command.",
		adminonly = false,
		hidden = false
	},
	["test"] = {
		command = function(ply,args) 
			local str = "Arguments:"
			for _,arg in ipairs(args) do
				str = str.." | "..arg
			end
			ARCBankMsgCL(ply,str)
		end, 
		usage = " [argument(any)] [argument(any)] [argument(any)]",
		description = "[Debug] Tests arguments",
		adminonly = false,
		hidden = true
	},
	["settings"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			if !args[1] then ARCBankMsgCL(ply,"You didn't enter a setting!") return end
			if ARCBank.Settings[args[1]] || isbool(ARCBank.Settings[args[1]]) then
				if isnumber(ARCBank.Settings[args[1]]) then
					if tonumber(args[2]) then
						ARCBank.Settings[args[1]] = tonumber(args[2])
						ARCBankMsgCL(ply,args[1].." has been set to: "..tostring(tonumber(args[2])))
					else
						ARCBankMsgCL(ply,"You cannot set "..args[1].." to "..tostring(tonumber(args[2])))
					end
				elseif istable(ARCBank.Settings[args[1]]) then
					if args[2] == "" || args[2] == " " then
						ARCBank.Settings[args[1]] = {}
					else
						ARCBank.Settings[args[1]] = string.Explode( ",", args[2])
					end
					ARCBankMsgCL(ply,args[1].." has been set to: "..args[2])
				elseif isstring(ARCBank.Settings[args[1]]) then
					ARCBank.Settings[args[1]] = string.gsub(args[2], "[^_%w]", "_")
					ARCBankMsgCL(ply,args[1].." has been set to: "..string.gsub(args[2], "[^_%w]", "_"))
				elseif isbool(ARCBank.Settings[args[1]]) then
					ARCBank.Settings[args[1]] = tobool(args[2])
					ARCBankMsgCL(ply,args[1].." has been set to: "..tostring(tobool(args[2])))
				end
			else
				ARCBankMsgCL(ply,"Invalid setting "..args[1])
			end
		end, 
		usage = " <setting(string)> <value(any)>",
		description = "Changes settings (see settings_help)",
		adminonly = true,
		hidden = false
	},
	["settings_help"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			if !args[1] then 
				for k,v in SortedPairs(ARCBank.Settings) do
					if istable(v) then
						local s = ""
						for o,p in pairs(v) do
							if o > 1 then
								s = s..","..p
							else
								s = p
							end
						end
						ARCBankMsgCL(ply,tostring(k).." = "..s)
					else
						ARCBankMsgCL(ply,tostring(k).." = "..tostring(v))
					end
				end
				ARCBankMsgCL(ply,"Type 'settings_help (setting) for a more detailed description of a setting.")
				return
			end
			if ARCBank.Settings[args[1]] || isbool(ARCBank.Settings[args[1]]) then
				if isnumber(ARCBank.Settings[args[1]]) then
					ARCBankMsgCL(ply,"Type: number")
					ARCBankMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCBank.VarTypeExamples["number"]))
					ARCBankMsgCL(ply,"Description: "..ARCBank.SettingsDesc[args[1]])
					ARCBankMsgCL(ply,"Currently set to: "..tostring(ARCBank.Settings[args[1]]))
				elseif istable(ARCBank.Settings[args[1]]) then
					local s = ""
					for o,p in pairs(ARCBank.Settings[args[1]]) do
						if o > 1 then
							s = s..","..p
						else
							s = p
						end
					end
					ARCBankMsgCL(ply,"Type: list")
					ARCBankMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCBank.VarTypeExamples["list"]))
					ARCBankMsgCL(ply,"Description: "..ARCBank.SettingsDesc[args[1]])
					ARCBankMsgCL(ply,"Currently set to: "..s)
				elseif isstring(ARCBank.Settings[args[1]]) then
					ARCBankMsgCL(ply,"Type: string")
					ARCBankMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCBank.VarTypeExamples["string"]))
					ARCBankMsgCL(ply,"Description: "..ARCBank.SettingsDesc[args[1]])
					ARCBankMsgCL(ply,"Currently set to: "..ARCBank.Settings[args[1]])
				elseif isbool(ARCBank.Settings[args[1]]) then
					ARCBankMsgCL(ply,"Type: boolean")
					ARCBankMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCBank.VarTypeExamples["boolean"]))
					ARCBankMsgCL(ply,"Description: "..ARCBank.SettingsDesc[args[1]])
					ARCBankMsgCL(ply,"Currently set to: "..tostring(ARCBank.Settings[args[1]]))
				end
			else
				ARCBankMsgCL(ply,"Invalid setting")
			end
		end, 
		usage = " [setting(string)]",
		description = "Shows you and gives you a description of all the settings",
		adminonly = false,
		hidden = false
	},
	["settings_save"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			ARCBankMsgCL(ply,"Saving settings...")
			ARCBankMsg("Saving settings...")
			file.Write(ARCBank.Dir.."/_saved_settings.txt",util.TableToJSON(ARCBank.Settings))
			if file.Exists(ARCBank.Dir.."/_saved_settings.txt","DATA") then
				ARCBankMsgCL(ply,"Settings Saved!")
				ARCBankMsg("Settings Saved!")
			else
				ARCBankMsgCL(ply,"Error saving settings!")
				ARCBankMsg("Error saving settings!")
			end
		end, 
		usage = "",
		description = "Removes the ATMs from the map.",
		adminonly = true,
		hidden = false
	},
	["atm_save"] = {
		command = function(ply,args)
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			ARCBankMsgCL(ply,"Saving ATMs to map...")
			if ARCBank.SaveATMs() then
				ARCBankMsgCL(ply,"ATMs saved onto map!")
			else
				ARCBankMsgCL(ply,"An error occured while saving the ATMs onto the map.")
			end
		end, 
		usage = "",
		description = "Makes all active ATMs a part of the map.",
		adminonly = true,
		hidden = false
	},
	["atm_unsave"] = {
		command = function(ply,args)
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			ARCBankMsgCL(ply,"Detatching ATMs from map...")
			if ARCBank.UnSaveATMs() then
				ARCBankMsgCL(ply,"ATMs Detached from map!")
			else
				ARCBankMsgCL(ply,"An error occured while detatching ATMs from map.")
			end
		end, 
		usage = "",
		description = "Makes all active ATMs a part of the map.",
		adminonly = true,
		hidden = false
	},
	["atm_respawn"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			ARCBankMsgCL(ply,"Spawning Map-Based ATMs...")
			if ARCBank.SpawnATMs() then
				ARCBankMsgCL(ply,"Map-Based ATMs Spawned!")
			else
				ARCBankMsgCL(ply,"No ATMs associated with this map. (Non-existent/Currupt file)")
			end
		end, 
		usage = "",
		description = "Respawns all Map-Based ATMs.",
		adminonly = true,
		hidden = false
	},
	["give_money"] = {
		command = function(ply,args) 
			if !ARCBank.Loaded then ARCBankMsgCL(ply,"System reset required!") return end
			if !args[1] || !args[2] || !args[3] then
				ARCBankMsgCL(ply,"Not enough argumetns!")
				return
			end
			if !tonumber(args[1]) || !ARCBank.Accounts[tonumber(args[1])] || tonumber(args[1]) == 0 || tonumber(args[1]) == 5 then
				ARCBankMsgCL(ply,"Invalid rank "..args[1])
				return
			end
			local accountfile = file.Read(ARCBank.Accounts[tonumber(args[1])]..args[2],"DATA")
			if !accountfile then
				ARCBankMsgCL(ply,"Invalid filename "..args[2])
			end
			local accountdata = util.JSONToTable(accountfile)
			if tonumber(args[3]) then
				accountdata[ARCBANK_BALANCE] = tostring(tonumber(accountdata[ARCBANK_BALANCE]) + args[3])
			else
				ARCBankMsgCL(ply,"Gave Invalid amount "..args[3])
				return
			end
			file.Write(ARCBank.Accounts[tonumber(args[1])]..args[2],util.TableToJSON(accountdata))
			ARCBankMsgCL(ply,"Gave "..args[3].." to "..accountdata[ARCBANK_NAME])
			ARCBankAccountMsg(ARCBank.Logs[tonumber(args[1])]..args[2],"[admin] added "..args[3].." to account.")
		end, 
		usage = " <account rank(number)> <account filename(string)> <money(number)>",
		description = "Gives or takes away money from an account",
		adminonly = true,
		hidden = false
	},
	["reset"] = {
		command = function(ply,args) 
			ARCBankMsgCL(ply,"Resetting ARCBank system...")
			ARCBank.SaveDisk()
			ARCBank.Load()
			if ARCBank.Loaded then
				ARCBankMsgCL(ply,"System resetted!")
			else
				ARCBankMsgCL(ply,"Error. Check server console for details.")
			end
		end, 
		usage = "",
		description = "Updates settings and checks for any currupt or invalid accounts. (SAVE YOUR SETTINGS BEFORE DOING THIS!)",
		adminonly = true,
		hidden = false
	}
}
concommand.Add( "arcbank", function( ply, cmd, args )
	local comm = args[1]
	table.remove( args, 1 )
	if ARCBank.Commands[comm] then
		if ARCBank.Commands[comm].adminonly && ply && ply:IsPlayer() && !ply:IsAdmin() && !ply:IsSuperAdmin() then
			ARCBankMsgCL(ply,"You must be an admin to use this command!")
		return end
		
		
		if ply && ply:IsPlayer() then
			local shitstring = ply:Nick().." ("..ply:SteamID()..") used the command: "..comm
			for i=1,#args do
				shitstring = shitstring.." "..args[i]
			end
			ARCBankMsg(shitstring)
		end
		ARCBank.Commands[comm].command(ply,args)
	elseif !comm then
		ARCBankMsgCL(ply,"No command. Type 'arcbank help' for help.")
	else
		ARCBankMsgCL(ply,"Invalid command '"..tostring(comm).."' Type 'arcbank help' for help.")
	end
end)

