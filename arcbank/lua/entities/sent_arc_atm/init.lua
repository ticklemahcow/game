AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString( "ARCATM_USE" )
util.AddNetworkString( "ARCATM_COMM" )
function ENT:Initialize()
	self.MonehDelay = CurTime()
	self.UseDelay = CurTime() + 1
	self.CommInit = false
	self.CommInitDelay = 0
	self:SetModel( "models/arc/atm.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake() 
		phys:SetMaterial( "metal" )
	end
	self.buttonpos = {}
	self:SetSkin( 2 )
	timer.Simple(2,function()
	for k,v in pairs(player.GetAll()) do
		v:SendLua("ents.GetByIndex("..self:EntIndex()..").ShowHolo = "..tostring(ARCBank.Settings["atm_holo"]))
		v:SendLua("ents.GetByIndex("..self:EntIndex()..").HoloReal = "..tostring(ARCBank.Settings["atm_holo_flicker"]))
		--MsgN(tostring(ARCBank.Settings["atm_holo"]))
	end
	end)
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_atm")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	return blarg
end
function ENT:Think()

	if self.CommInitDelay <= CurTime() then
		self.CommInit = ARCBank.Loaded
		self.CommInitDelay = CurTime() + 5
	end
		if self.UsePlayer and !IsValid(self.UsePlayer) then
			self.InUse = false
			self.UsePlayer = nil
			MsgN("ATM: NO PLAYAH!")
			return
		end
		--[[
	if IsValid(self.UsePlayer) && (self:GetPos()+(self:GetAngles():Up() * -20)+(self:GetAngles():Forward() * 40)):Distance(self.UsePlayer:GetPos()) > 25 then
		--self:EmitSound("arcbank/atm/beep_short.wav")
		self.UsePlayer:SetPos(self:GetPos() + ((self:GetAngles():Up() * -30) + (self:GetAngles():Forward() * 40)))
		self.UsePlayer:SetVelocity(self.UsePlayer:GetVelocity()*-1)
		self:NextThink( CurTime() + 0.08 )
		return true
	end
	]]
	
	if self.PlayerNeedsToDoSomething then
		self.Beep = true
	elseif self.Beep && self.TakingMoney then
		timer.Simple(0.1, function() self:SetSkin( 2 ) end)
		if self.Hacked then
			self:EmitSound("arcbank/atm/close.wav",65,math.random(95,110))
		else
			self:EmitSound("arcbank/atm/close.wav",65,100)
		end
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( self )
		net.WriteInt(self.errorc,ARCBANK_ERRORBITRATE)
		net.WriteInt(ARCBANK_ATM_CASH,ARCBANK_ATMBITRATE)
		net.WriteTable({})
		net.Send(self.UsePlayer)
		self.Beep = false
	end
	if self.Beep then
		if self.Hacked then
			--self:EmitSound("arcbank/atm/beep_short.wav",75,15)
			self.UsePlayer = player.GetNearest(self:GetPos())
			self:EmitSound("arcbank/atm/beep.wav",65,math.random(95,110))
		else
			self:EmitSound("arcbank/atm/beep.wav",65,100)
			if IsValid(self.UsePlayer) && (self:GetPos()+(self:GetAngles():Up() * -20)+(self:GetAngles():Forward() * 40)):Distance(self.UsePlayer:GetPos()) > 25 then
				--self:EmitSound("arcbank/atm/beep_short.wav")
				self.UsePlayer:SetPos(self:GetPos() + ((self:GetAngles():Up() * -30) + (self:GetAngles():Forward() * 40)))
				self.UsePlayer:SetVelocity(self.UsePlayer:GetVelocity()*-1)
				self:NextThink( CurTime() + 0.08 )
			end
		end
		self:NextThink( CurTime() + 1 )
		self:SetSkin( 0 )
		timer.Simple(0.5, function() self:SetSkin( 1 ) end)
		return true
	end
	if self.SendingLog then
		if self.CurrentLogTable <= table.maxn(self.LogTable) then
			local data = {}
			data[1] = self.LogTable[self.CurrentLogTable]
			data[ARCBANK_CHUNK] = self.CurrentLogTable
			data[ARCBANK_CHUNK_TOTAL] = table.maxn(self.LogTable)
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ERROR_NONE,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_LOG,ARCBANK_ATMBITRATE)
			net.WriteTable( data )
			net.Send(self.UsePlayer)
			self.CurrentLogTable = self.CurrentLogTable + 1
			--if self.CurrentLogTable > table.maxn(self.LogTable)/2 then
			--	self.CurrentLogTable = self.CurrentLogTable + 1
			--end
			self:NextThink( CurTime() + 0.1 )
			return true
		else
			self.SendingLog = false
		end
	end
	if self.SendingName then
		if self.CurrentNameTable <= table.maxn(self.NameTable) then
			local data = {}
			data[1] = self.NameTable[self.CurrentNameTable]
			data[ARCBANK_CHUNK] = self.CurrentNameTable
			data[ARCBANK_CHUNK_TOTAL] = table.maxn(self.NameTable)
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ERROR_NONE,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
			net.WriteTable( data )
			net.Send(self.UsePlayer)
			self.CurrentNameTable = self.CurrentNameTable + 1
			--if self.CurrentLogTable > table.maxn(self.LogTable)/2 then
			--	self.CurrentLogTable = self.CurrentLogTable + 1
			--end
			self:NextThink( CurTime() + 0.1 )
			return true
		else
			self.SendingName = false
		end
	end
end
net.Receive( "ARCATM_USE", function(length)
	local atm = net.ReadEntity() 
	local ply = atm.UsePlayer
	if IsValid(ply) && ply:IsPlayer() then
		timer.Simple(0.5,function()
			ply:Give("weapon_arc_atmcard")
			ply:SelectWeapon("weapon_arc_atmcard")
		end)
		atm:ATM_USE(atm.UsePlayer)
	end
end)
function ENT:OnRemove()
	if self.ARCBank_MapEntity then
		ARCBank.SpawnATMs()
	end
end
function ENT:CPPICanTool(ply,tool)
	if !ply:IsPlayer() || self.ARCBank_MapEntity then
		return false
	else
		return true
	end
end
function ENT:Use( ply, caller )
	if self.InUse && ply == self.UsePlayer && self.PlayerNeedsToDoSomething then
		self.UsingHole = false --Still trying to figure out if this is dirty or not
		self.CurPos = ply:GetEyeTrace().HitPos
		self.buttonpos[1] = self:GetPos() + ((self:GetAngles():Up() * 6.6) + (self:GetAngles():Forward() * 14.3) + (self:GetAngles():Right() * 1))
		self.buttonpos[2] = self:GetPos() + ((self:GetAngles():Up() * 6.6) + (self:GetAngles():Forward() * 14.3) + (self:GetAngles():Right() * 4))
		self.buttonpos[3] = self:GetPos() + ((self:GetAngles():Up() * 6.6) + (self:GetAngles():Forward() * 14.3) + (self:GetAngles():Right() * 7))
		for i=1,3 do
			if self.buttonpos[i] && self.buttonpos[i]:IsEqualTol(self.CurPos,1.6) then
				self.UsingHole = true
			end
		end
		if self.UsingHole && self.MonehDelay < CurTime() then
			self.MonehDelay = CurTime() + 1
			if self.TakingMoney then
				if self.Hacked then
					self.errorc = ARCBank.StealMoney(self.UsePlayer,self.args[ARCBANK_MONEY],self.args[ARCBANK_NAME])
					self.UsePlayer = nil
					timer.Simple(math.Rand(2,10),function()
						if IsValid(self.HackUnit) then
							self.HackUnit:StopHack()
						end
					end)
				else
					self.errorc = ARCBank.AtmFunc(1,self.UsePlayer,-self.args[ARCBANK_MONEY],self.args[ARCBANK_NAME])
				end
				self.moneyprop:Remove()
				
				self:EmitSound("foley/alyx_hug_eli.wav",75,math.random(225,255))
			else
				self.errorc = ARCBank.AtmFunc(0,self.UsePlayer,self.args[ARCBANK_MONEY],self.args[ARCBANK_NAME])
				if self.errorc == 0 then
					self:EmitSound("arcbank/atm/eat-duh-cashnomnom.wav",65,100)
					local moneyproppos = self:GetPos() + ((self:GetAngles():Up() * 6.3) + (self:GetAngles():Forward() * 15) + (self:GetAngles():Right() * 4))
					local moneyproptopos = moneyproppos - (self:GetPos() + ((self:GetAngles():Up() * 6.3) + (self:GetAngles():Forward() * 14) + (self:GetAngles():Right() * 4)))
					self.moneyprop = ents.Create( "prop_physics" )
					self.moneyprop:SetModel( "models/props/cs_assault/money.mdl" )
					self.moneyprop:SetKeyValue("spawnflags","516")
					self.moneyprop:SetPos( moneyproppos)
					local moneyang = self:GetAngles()
					moneyang:RotateAroundAxis( moneyang:Up(), -90 )
					self.moneyprop:SetAngles( moneyang )
					self.moneyprop:Spawn()
					self.moneyprop:GetPhysicsObject():EnableCollisions(false)
					self.moneyprop:GetPhysicsObject():EnableGravity(false)
					self.moneyprop:GetPhysicsObject():SetVelocity(moneyproptopos*-2)
					timer.Simple(3.5,function() self.moneyprop:Remove() end)
					timer.Simple(7,function() self.TakingMoney = true end)
				else
					self:EmitSound("arcbank/atm/eat-duh-cash-stop.wav",65,100)
					timer.Simple(2,function() self.TakingMoney = true end)
				end
				self.whirsound:Stop()
			end
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(0,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
			net.WriteTable({false,0})
			net.Send(self.UsePlayer)
			self.PlayerNeedsToDoSomething = false
		end
	end
end
function ENT:ATM_USE(activator)
	if IsValid(activator) && activator:IsPlayer()  then
		if self.Hacked then return end
		if self.InUse then
			if activator == self.UsePlayer then
				self:EmitSound("arcbank/atm/cardremove.wav",55,math.random(95,105))
				self.InUse = false
				table.RemoveByValue(ARCBank.Disk.NommedCards,activator:SteamID())
				self.UsePlayer = nil
				net.Start( "ARCATM_USE" )
				net.WriteEntity( self )
				net.WriteBit(false)
				net.Send(activator)
				if !ARCBank.Loaded then
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( self )
					net.WriteInt(0,ARCBANK_ERRORBITRATE)
					net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
					net.WriteTable( {false} )
					net.Broadcast()
					self.CommInit = false
				end
			else
				activator:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
				activator:SendLua("notification.AddLegacy( \"This ATM is already in use by "..self.UsePlayer:Nick().."!\", 0, 5 )")
			end
		elseif self.CommInit then
			self:EmitSound("arcbank/atm/cardinsert.wav",55,math.random(95,105))
			self.InUse = true
			table.insert(ARCBank.Disk.NommedCards,activator:SteamID())
			self.UsePlayer = activator
			activator:SwitchToDefaultWeapon() 
			activator:StripWeapon( "weapon_arc_atmcard" ) 
			--activator:SendLua( "achievements.EatBall()" );
			net.Start( "ARCATM_USE" )
			net.WriteEntity( self )
			net.WriteBit(true)
			net.Send(activator)
		else
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(0,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
			net.WriteTable( {false} )
			net.Broadcast()
		end
	end
end


net.Receive( "ARCATM_COMM", function(length,ply)
	local atm = net.ReadEntity() 
	local operation = net.ReadInt(ARCBANK_ATMBITRATE)
	local accountdata = {}
	if operation != ARCBANK_ATM_PING then
		if !IsValid(atm) || !atm.IsAFuckingATM || (atm.UsePlayer && atm.UsePlayer != ply) then 
			ARCBankMsg("ARCATM_COMM ERROR. Some stupid shit by the name of "..ply:Nick().." ("..ply:SteamID()..") tried to use the net exploint thing.")
			if ply.ARCBank_AFuckingIdiot then
				ply:Ban(ARCBank.Settings["autoban_time"], "ARCBank Autobanned for "..string.NiceTime( ARCBank.Settings["autoban_time"]*60 ).." - Tried to be a L33T H4X0R" ) 
			else
				ARCBankMsgCL(ply,"I fucking swear, you better not try that again.")
				ply.ARCBank_AFuckingIdiot = true
			end
			return 
		end
	end
	local args = net.ReadTable()
	--MsgN("ATM: "..operation)
	if operation == ARCBANK_ATM_PING then
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( atm )
		net.WriteInt(0,ARCBANK_ERRORBITRATE)
		net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
		net.WriteTable( {atm.CommInit} )
		--MsgN(atm.CommInit)
		net.Send(args[1])
	elseif operation == ARCBANK_ATM_ACCOUNTINFO then
		local errorc = 15
		local dir,rank = ARCBank.GetAccountDir(args[ARCBANK_NAME],atm.UsePlayer)
		if isnumber(dir) then
			errorc = dir
		else
			accountdata = util.JSONToTable(file.Read(dir, "DATA" ))
			if (!accountdata) then
				errorc = ARCBANK_ERROR_NIL_ACCOUNT
			else
				errorc = 0
				accountdata[ARCBANK_RANK] = rank
			end
		end
		accountdata[ARCBANK_BALANCE] = gibemoniplos(tonumber(accountdata[ARCBANK_BALANCE]))
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( atm )
		net.WriteInt(errorc,ARCBANK_ERRORBITRATE)
		net.WriteInt(ARCBANK_ATM_ACCOUNTINFO,ARCBANK_ATMBITRATE)
		net.WriteTable( accountdata )
		net.Send(atm.UsePlayer)
	elseif operation == ARCBANK_ATM_CASH then
		atm.errorc = 0
		atm.args = args
		if args[ARCBANK_MONEY] < 0 then
			atm.TakingMoney = true
			atm.errorc = ARCBank.CanAfford(atm.UsePlayer,-args[ARCBANK_MONEY],args[ARCBANK_NAME])
			if atm.errorc == 0 then
				local moneyproppos = atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward()*8) + (atm:GetAngles():Right() * 4))
				local moneyproptopos = moneyproppos - (atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward() * 14) + (atm:GetAngles():Right() * 4)))
				moneyproptopos:Normalize()
				--local moneyproppos = :RotateAroundAxis( atm.displayangle1:Right(), -90 )
				atm.moneyprop = ents.Create( "prop_physics" )
				atm.moneyprop:SetModel( "models/props/cs_assault/money.mdl" )
				atm.moneyprop:SetKeyValue("spawnflags","516")
				atm.moneyprop:SetPos( moneyproppos)
				local moneyang = atm:GetAngles()
				moneyang:RotateAroundAxis( moneyang:Up(), -90 )
				atm.moneyprop:SetAngles( moneyang )
				atm.moneyprop:Spawn()
				atm.moneyprop:GetPhysicsObject():EnableCollisions(false)
				atm.moneyprop:GetPhysicsObject():EnableGravity(false)
				
				
				atm:EmitSound("arcbank/atm/spit-out.wav",65,100)
				timer.Simple(6.5,function() atm.moneyprop:GetPhysicsObject():SetVelocity(moneyproptopos*-13) 
				atm:SetSkin( 1 ) end)
				timer.Simple(7,function() 
					atm.moneyprop:GetPhysicsObject():SetVelocity(Vector(0,0,0)) 
					atm.moneyprop:GetPhysicsObject():EnableMotion( false) 
				end)
				atm.MonehDelay = CurTime() + 8.5
				timer.Simple(7.5,function()
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( atm )
					net.WriteInt(0,ARCBANK_ERRORBITRATE)
					net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
					net.WriteTable({false,2})
					net.Send(atm.UsePlayer)
					atm.UsePlayer:SendLua("notification.AddLegacy( \"Use the money to pick it up. (Press E)\", 3, 5 )")
					atm.PlayerNeedsToDoSomething = true
				end)
				--[[
				timer.Simple(8.5,function()
					
					atm:EmitSound("arcbank/atm/close.wav")
				end)]]
			end
		else
			atm.TakingMoney = false
			if atm.errorc == 0 then
				atm:EmitSound("arcbank/atm/eat-duh-cash1.wav",65,100)
				atm.whirsound = CreateSound( atm, "arcbank/atm/eat-duh-cash-loop.wav" ) 
				atm.whirsound:ChangeVolume( 65, 0.1) 
				atm.MonehDelay = CurTime() + 5
				timer.Simple(0.6, function() atm:SetSkin( 1 ) end)
				timer.Simple(4,function()
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( atm )
					net.WriteInt(0,ARCBANK_ERRORBITRATE)
					net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
					net.WriteTable({false,1})
					net.Send(atm.UsePlayer)
					atm.UsePlayer:SendLua("notification.AddLegacy( \"Use the mouth of the ATM to deposit money. (Press E)\", 3, 5 )")
					atm.PlayerNeedsToDoSomething = true
					atm.whirsound:Play()
				end)
			end
		end
		--6.9
		if atm.errorc != 0 then
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( atm )
			net.WriteInt(atm.errorc,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_CASH,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.Send(atm.UsePlayer)
		end
	elseif operation == ARCBANK_ATM_TRANSFER then
		local errorc = 0
		local plyent = player.GetBySteamID(args[ARCBANK_PLAYER])
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( atm )
		errorc = ARCBank.Transfer(atm.UsePlayer,plyent,args[ARCBANK_NAME],args[ARCBANK_NAMETO],args[ARCBANK_MONEY],"ATM")
		--args[ARCBANK_NAME]
		--
		--args[ARCBANK_MONEY]
		--[[
		if ARCBank.CanAfford() then
		
		end
		]]
		net.WriteInt(errorc,ARCBANK_ERRORBITRATE)
		net.WriteInt(ARCBANK_ATM_TRANSFER,ARCBANK_ATMBITRATE)
		net.WriteTable( accountdata )
		net.Send(atm.UsePlayer)
	elseif operation == ARCBANK_ATM_CREATE then
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( atm )
		if args[ARCBANK_UPGRADE] then
			local fuckyou, rank = ARCBank.GetAccountDir(args[ARCBANK_NAME],atm.UsePlayer)
			if isstring(fuckyou) then
				accountdata = util.JSONToTable(file.Read(fuckyou, "DATA" ))
			end
			local errorc = 0
			if !accountdata[ARCBANK_NAME] then
				errorc = ARCBANK_ERROR_NIL_ACCOUNT
			else
			--	accountdata[ARCBANK_NAME] = atm.UsePlayer:Nick() -- Updates nickname
				accountdata[ARCBANK_RANK] = rank + 1
				if accountdata[ARCBANK_RANK] == ARCBANK_GROUPACCOUNTS_ || accountdata[ARCBANK_RANK] > ARCBANK_GROUPACCOUNTS_PREMIUM then
					errorc = ARCBANK_ERROR_INVALID_RANK
				else
					if accountdata[ARCBANK_GROUP_OWNER] && accountdata[ARCBANK_GROUP_OWNER] != atm.UsePlayer:SteamID() then
						--MsgN("NO ACCES!")
						errorc = ARCBANK_ERROR_NO_ACCES
					else
						errorc = ARCBank.CreateAccount(atm.UsePlayer,accountdata[ARCBANK_RANK],accountdata[ARCBANK_BALANCE],accountdata[ARCBANK_NAME])
					end
					if errorc == 0 then
						if args[ARCBANK_NAME] == "" then
							args[ARCBANK_NAME] = ARCBank.GetAccountID(atm.UsePlayer:SteamID())
						else
							args[ARCBANK_NAME] = ARCBank.GetAccountID(args[ARCBANK_NAME])
						end
						if file.Exists(ARCBank.Accounts[accountdata[ARCBANK_RANK]-1]..args[ARCBANK_NAME]..".txt","DATA") then
							local oldlog = file.Read(ARCBank.Logs[accountdata[ARCBANK_RANK]-1]..args[ARCBANK_NAME]..".txt","DATA")
							if oldlog then
								file.Delete(ARCBank.Logs[accountdata[ARCBANK_RANK]-1]..args[ARCBANK_NAME]..".txt")
								file.Write(ARCBank.Logs[accountdata[ARCBANK_RANK]]..args[ARCBANK_NAME]..".txt",oldlog)
							end
							ARCBankAccountMsg(ARCBank.Logs[accountdata[ARCBANK_RANK]]..args[ARCBANK_NAME]..".txt","Account Upgraded to "..ARCBANK_ACCOUNTSTRINGS[accountdata[ARCBANK_RANK]])
							file.Delete(ARCBank.Accounts[accountdata[ARCBANK_RANK]-1]..args[ARCBANK_NAME]..".txt")
						else
							errorc = ARCBANK_ERROR_UNKNOWN
						end
					end
				end
			end
			net.WriteInt(errorc,ARCBANK_ERRORBITRATE)
		else
			--
				local err = 15
				local dirname = args[ARCBANK_NAME]
				if dirname == "" then
					dirname = atm.UsePlayer:SteamID()
				end
				for i=1,7 do
					if file.Exists(ARCBank.Accounts[i]..ARCBank.GetAccountID(dirname)..".txt","DATA") then
						err = ARCBANK_ERROR_NAME_DUPE
					end
				end
				local startingcash = ARCBank.Settings["starting_cash"]
				if err == 15 then
					local accountcount = 0
					if args[ARCBANK_RANK] > 5 then
						startingcash = 0
						for i=6,7 do
							for _,account in pairs(file.Find( ARCBank.Accounts[i].."*", "DATA" )) do
								local accountdata = util.JSONToTable(file.Read(ARCBank.Accounts[i].. account, "DATA" ))
								if accountdata[ARCBANK_GROUP_OWNER] == atm.UsePlayer:SteamID() then
									accountcount = accountcount + 1
								end
							end
						end
						if accountcount > ARCBank.Settings["group_account_limit"] then
							err = ARCBANK_ERROR_TOO_MANY_ACCOUNTS
						end
					end
				end
				if err == 15 then
					err = ARCBank.CreateAccount(atm.UsePlayer,args[ARCBANK_RANK],startingcash,args[ARCBANK_NAME])
				end
				net.WriteInt(err,ARCBANK_ERRORBITRATE)
		end
		net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
		net.WriteTable( accountdata )
		net.Send(atm.UsePlayer)
	elseif operation == ARCBANK_ATM_GROUPADMIN then
	if args[5] then
		local accountdata = util.JSONToTable(file.Read( ARCBank.GetAccountDir(args[3],atm.UsePlayer),"DATA"))
		if !accountdata then
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( atm )
			net.WriteInt(ARCBANK_ERROR_NIL_PLAYER,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.Send(atm.UsePlayer)
			atm.SendingName = false
		else
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( atm )
			net.WriteInt(ARCBank.RemoveAccount(atm.UsePlayer,args[3]),ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.Send(atm.UsePlayer)
		end
	elseif args[4] then
		local plys = util.JSONToTable(file.Read( ARCBank.GetAccountDir(args[3],atm.UsePlayer),"DATA")).players
		if !plys || #plys == 0 then
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( atm )
			net.WriteInt(ARCBANK_ERROR_NIL_PLAYER,ARCBANK_ERRORBITRATE)
			net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.Send(atm.UsePlayer)
			atm.SendingName = false
		else
			atm.CurrentNameTable = 1
			atm.NameTable = {}
			for i,id in pairs(plys) do
				table.insert( atm.NameTable, player.GetBySteamID(id):Nick().."\n"..id )
			end
			atm.SendingName = true
		end
	else
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( atm )
		if args[1] then
			net.WriteInt(ARCBank.AddPlayerToGroup(atm.UsePlayer,args[2],args[3]),ARCBANK_ERRORBITRATE)
		else
			net.WriteInt(ARCBank.RemovePlayerFromGroup(atm.UsePlayer,args[2],args[3]),ARCBANK_ERRORBITRATE)
		end
		net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
		net.WriteTable({})
		net.Send(atm.UsePlayer)
	end
	
	elseif operation == ARCBANK_ATM_GETGROUPS then
		atm.CurrentNameTable = 1
		if args[1] then
			atm.NameTable = ARCBank.GroupAccountAcces(args[2])
			if isnumber(atm.NameTable) then
				atm.NameTable = {} --The Function ARCBank.GroupAccountAcces() doesn't return a table if the player doesn't exsit.
			end
			if args[3] && (ARCBank.CanAfford(args[2],0,"") == 0) then
				table.insert( atm.NameTable,1, ARCBank.ATMMsgs.PersonalAccount )
			end
			if args[4] then
				table.insert( atm.NameTable, ARCBank.ATMMsgs.CreateGroupAccount )
			end
		else
			atm.NameTable = {}
			local players = player.GetAll() 
			for i=1,table.maxn(players) do
				atm.NameTable[i] = players[i]:Nick().."\n"..players[i]:SteamID()
			end
			if !args[3] then
				table.insert( atm.NameTable, ARCBank.ATMMsgs.OfflinePlayer )
			end
		end
		if table.Count(atm.NameTable) == 0 then
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( atm )
			if args[3] then
				net.WriteInt(ARCBANK_ERROR_NIL_PLAYER,ARCBANK_ERRORBITRATE)
			else
				net.WriteInt(ARCBANK_ERROR_PLAYER_FOREVER_ALONE,ARCBANK_ERRORBITRATE)
			end
			net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.Send(atm.UsePlayer)
			atm.SendingName = false
		else
			atm.SendingName = true
		end
	elseif operation == ARCBANK_ATM_LOG then
		atm.CurrentLogTable = 1
		if args[ARCBANK_RANK] == 0 then
			atm.LogTable = ARCBank.GetLogTable(ARCBank.Dir.."/_about_atm.txt")
		else
			atm.LogTable = ARCBank.GetLogTable(ARCBank.Logs[args[ARCBANK_RANK]]..ARCBank.GetAccountID(args[ARCBANK_NAME])..".txt")
		end
		atm.SendingLog = true
	end
end)
