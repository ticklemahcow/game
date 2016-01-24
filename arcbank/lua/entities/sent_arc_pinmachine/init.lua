AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString( "ARCCHIPMACHINE_STRINGS" )
util.AddNetworkString( "ARCCHIPMACHINE_MENU_OWNER" )
util.AddNetworkString( "ARCCHIPMACHINE_MENU_CUSTOMER" )
function ENT:Initialize()
	self:SetModel( "models/arc/atm_cardmachine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS  )
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake() 
		phys:SetMaterial( "metal" )
	end
	self:SetUseType( SIMPLE_USE )
	self.EnteredAmount = 0
	self.TopScreenText = "**ARCBank**"
	self.BottomScreenText = "No owner is set!"
	self.FromAccount = ""
	self.ToAccount = ""
	self.Reason = "Card Machine"
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_pinmachine")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 4)
	blarg:Spawn()
	blarg:Activate()
	timer.Simple(0.1,function()
		if blarg != NULL then
			blarg._Owner = ply
			blarg:SetScreenMsg("**ARCBank**",string.Replace( ARCBank.CardMsgs.Owner, "%PLAYER%", ply:Nick() ))
			if CPPI then -- Prop protection addons
				blarg:CPPISetOwner(ply)
			end
		end
	end)
	return blarg
end

function ENT:Think()

end

function ENT:OnRemove()

end
--dasdadadsadsa é
function ENT:Use(ply,caller)
	if !self._Owner || self._Owner == NULL || !self._Owner:IsPlayer() then 
		if ply:IsPlayer() then
			self:EmitSound("buttons/button18.wav",75,255)
			self._Owner = ply
			self:SetScreenMsg("**ARCBank**",string.Replace( ARCBank.CardMsgs.Owner, "%PLAYER%", ply:Nick() ))
			if CPPI then -- Prop protection addons
				self:CPPISetOwner(ply)
			end
		end
		return 
	end
	if ply:IsPlayer() then
		if ply == self._Owner then
			if self.DemandingMoney then
				self:EmitSound("buttons/button18.wav",75,255)
				self.DemandingMoney = false
				self:SetScreenMsg("*Operation*","*Cancelled*")
				timer.Simple(1.5,function()
					self:SetScreenMsg("**ARCBank**",string.Replace( ARCBank.CardMsgs.Owner, "%PLAYER%", ply:Nick() ))
				end)
			else
				local accountdir = ARCBank.GetAccountDir("",ply)
				if isnumber(accountdir) then
					local errormsg = string.Replace( ARCBANK_ERRORSTRINGS[accountdir], "\n", " " )
					ply:SendLua("notification.AddLegacy( \"Code "..tostring(accountdir).." - "..errormsg.."\", 1, 5 )")
					ply:SendLua("LocalPlayer():EmitSound( \"buttons/button8.wav\" )")
				elseif file.Exists(accountdir,"DATA") then
				--if true then
					self:EmitSound("buttons/button18.wav",75,255)
					local accounts = ARCBank.GroupAccountAcces(ply)
					table.insert( accounts, 1, ARCBank.ATMMsgs.PersonalAccount )
					net.Start( "ARCCHIPMACHINE_MENU_OWNER" )
					net.WriteEntity(self.Entity)
					net.WriteTable(accounts)
					net.Send(ply)
				else
					ply:SendLua("notification.AddLegacy( \"You don't have a personal bank account.\", 1, 5 )")
					ply:SendLua("LocalPlayer():EmitSound( \"buttons/button8.wav\" )")
				end
			end
		else
			ply:SendLua("notification.AddLegacy( \""..ARCBank.CardMsgs.InvalidOwner.."\", 0, 5 )")
			ply:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
		end
	end
end
function ENT:ATM_USE(ply)
	if self.DemandingMoney then
		local accounts = ARCBank.GroupAccountAcces(ply)
		table.insert( accounts, 1, ARCBank.ATMMsgs.PersonalAccount )
		net.Start( "ARCCHIPMACHINE_MENU_CUSTOMER" )
		net.WriteEntity(self.Entity)
		net.WriteTable(accounts)
		net.Send(ply)
	else
		ply:SendLua("notification.AddLegacy( \""..ARCBank.CardMsgs.NoCard.."\", 0, 5 )")
		ply:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
	end
end
function ENT:SetScreenMsg(strtop,strbottom)
	net.Start( "ARCCHIPMACHINE_STRINGS" )
	net.WriteEntity(self.Entity)
	net.WriteString(strtop)
	net.WriteString(strbottom)
	net.Broadcast()
	self.TopScreenText = strtop
	self.BottomScreenText = strbottom
end
net.Receive( "ARCCHIPMACHINE_STRINGS", function(length,ply)
	local ent = net.ReadEntity()
	net.Start( "ARCCHIPMACHINE_STRINGS" )
	net.WriteEntity(ent)
	net.WriteString(ent.TopScreenText)
	net.WriteString(ent.BottomScreenText)
	net.Send(ply)
end)
net.Receive( "ARCCHIPMACHINE_MENU_OWNER", function(length,ply)
	local ent = net.ReadEntity()
	local account = net.ReadString()
	local amount = net.ReadInt(32) 
	local re = net.ReadString()
	ent.ToAccount = account
	ent.EnteredAmount = amount
	ent.DemandingMoney = true
	ent:SetScreenMsg("Cr "..tostring(amount),ARCBank.CardMsgs.InsertCard)
	ent.Reason = re
end)
net.Receive( "ARCCHIPMACHINE_MENU_CUSTOMER", function(length,ply)
	local ent = net.ReadEntity()
	local account = net.ReadString()
	ent.FromAccount = account
	local errorcode = ARCBank.Transfer(ply,ent._Owner,ent.FromAccount,ent.ToAccount,ent.EnteredAmount,ent.Reason)
	local errormsg = string.Replace( ARCBANK_ERRORSTRINGS[errorcode], "\n", " " )
	ent:SetScreenMsg("Code "..tostring(errorcode),errormsg)
	if errorcode == 0 then
		ply:SendLua("notification.AddLegacy( \"Code "..tostring(errorcode).." - "..errormsg.."\", 0, 5 )")
		ent._Owner:SendLua("notification.AddLegacy( \"Code "..tostring(errorcode).." - "..errormsg.." ("..ply:Nick()..")\", 0, 5 )")
		ply:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
		ent._Owner:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
	else
		ply:SendLua("notification.AddLegacy( \"Code "..tostring(errorcode).." - "..errormsg.."\", 1, 5 )")
		ent._Owner:SendLua("notification.AddLegacy( \"Code "..tostring(errorcode).." - "..errormsg.." ("..ply:Nick()..")\", 1, 5 )")
		ply:SendLua("LocalPlayer():EmitSound( \"buttons/button8.wav\" )")
		ent._Owner:SendLua("LocalPlayer():EmitSound( \"buttons/button8.wav\" )")
	end
	ent.DemandingMoney = false
	timer.Simple(10,function()
		if ent == NULL then return end
		ent:SetScreenMsg("**ARCBank**",string.Replace( ARCBank.CardMsgs.Owner, "%PLAYER%", ent._Owner:Nick() ))
	end)
	
end)