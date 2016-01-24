AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString( "ARCATMHACK_BEGIN" )
ENT.ARitzDDProtected = true
function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever01d.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.whirang = 0
	self.hacktime = 0
	self.left = 1
	self.HackMoneh = 20
		self.spark = ents.Create("env_spark")
		self.spark:SetPos( self:GetPos() )
		self.spark:Spawn()
		self.spark:SetKeyValue("Magnitude",1)
		self.spark:SetKeyValue("TrailLength",1)
		self.spark:SetParent( self.Entity )
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_atmhack")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	blarg.Hacker = ply
	return blarg
end
function ENT:BeginHack()
	if self.OurHealth <= 0 then return end
	self:EmitSound("npc/dog/dog_servo12.wav",75,75)
	local atm = self:GetParent()
	if atm != NULL then
		if atm.Hacked || atm.InUse then
			local pos = self:GetParent():WorldToLocal(self:GetPos()) - Vector(0,-self.left,0)
			self:SetPos(pos)
			atm.HackUnit = NULL
			self:SetParent()
			self:GetPhysicsObject():Wake()
		return end
		atm.Hacked = true
		atm.InUse = true
		if atm:WorldToLocal(self:GetPos()):__index("y") < 0 then
			self.left = -1
			MsgN("LEFT")
		end
		self.init = true
	end
end
 ENT.OurHealth = 25; -- Amount of damage that the entity can handle - set to 0 to make it indestructible
function ENT:StopHack()
	if IsValid(self:GetParent())then
		local atm = self:GetParent()
		net.Start( "ARCATMHACK_BEGIN" )
		net.WriteFloat(0)
		net.WriteEntity(atm)
		net.WriteBit(false)
		net.Broadcast()
		atm.CommInit = false
		atm.CommInitDelay = CurTime() + math.Rand(5,60) + (self.bhacktime/23)
		--atm.CommInitDelay = CurTime() + 100
		atm.InUse = false
		atm.HackUnit = NULL
		atm.Hacked = false
		self.init = false
		local pos = self:GetParent():WorldToLocal(self:GetPos()) - Vector(0,-self.left,0)
		self:SetPos(pos)
		self:SetParent()
		self:EmitSound("ambient/energy/powerdown2.wav")
		if self.HackSound then
			self.HackSound:Stop()
		end
		self:GetPhysicsObject():Wake()
	end
end
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg); -- React physically when getting shot/blown
	self.OurHealth = self.OurHealth - dmg:GetDamage(); -- Reduce the amount of damage took from our health-variable
	MsgN(self.OurHealth)
	if(self.OurHealth <= 0) then -- If our health-variable is zero or below it
		if self:GetParent() != NULL && self:GetParent().UsePlayer then return end
		if self:GetParent() != NULL && !self:GetParent().UsePlayer then
			MsgN("HERO!")
			local attname
			if dmg:GetAttacker():IsPlayer() then
				attname = dmg:GetAttacker():Nick()
			elseif IsEntity(dmg:GetAttacker()) then
				attname = dmg:GetAttacker():GetClassName()
			else
				attname "UNKNOWN"
			end
			if IsValid(self.Hacker) && dmg:GetAttacker() != self.Hacker && self.Hacker:IsPlayer() && self.hacktime > 0 then 
				self.Hacker:ConCommand("say OH NO! I AM A NOOB HACKER! "..string.upper(tostring(attname)).." IS SO MUCH BETTER THAN ME!")
				for k,v in pairs(player.GetAll()) do
					if IsValid(v) && v:IsPlayer() then
						v:PrintMessage( HUD_PRINTTALK , tostring(attname).." just stopped "..tostring(self.Hacker:Nick()).." from hacking an ATM and stealing your money! "..tostring(attname).." IS A HERO!" ) 
					end
				end
			end
		end
		self:StopHack()
		
		if self.spark && self.spark != NULL then
			self.spark:Fire( "SparkOnce","",0.01 )
			self.spark:Fire( "SparkOnce","",0.02 )
			for i=1,math.random(5,40) do
				self.spark:Fire( "SparkOnce","",math.random(i/10,i) )
			end
			self.spark:Fire( "Kill","",41 )
			--math.random(10,40)
			local rtime = math.random(5,35)
			for i=1,28 do
				self.spark:Fire( "SparkOnce","",rtime+(i/10) )
			end
			timer.Simple(rtime+math.Rand(1,3),function()
				if !self || self == NULL then return end
				local effectdata = EffectData()
				effectdata:SetStart(self:GetPos()) -- not sure if we need a start and origin (endpoint) for this effect, but whatever.
				effectdata:SetOrigin(self:GetPos())
				effectdata:SetScale(1)
				self:EmitSound("npc/turret_floor/detonate.wav")
				util.Effect( "HelicopterMegaBomb", effectdata )	
				util.Effect( "cball_explode", effectdata )	
				self:Remove()
			end)
		end
	end
end
function ENT:Think()
	if !self.init || self.OurHealth <= 0 then return end
	if self:GetParent() == NULL then
		self.init = false
		return
	end
	if self.whirang < 90 then
		self.whirang = self.whirang + 2.5
		local ang = self:GetAngles()
		--ang:RotateAroundAxis( ang:Up(), -22.5*self.left )
		ang:RotateAroundAxis( ang:Up(), -2.5*self.left )
		self:SetAngles(ang)
		local pos = self:GetParent():WorldToLocal(self:GetPos()) - Vector(0.02,0,0)
		self:SetPos(pos)
		self:NextThink( CurTime() )
		return true
	end
	if self.hacking then
		if self.hacktime > 0 then
			if self.hacktime <= CurTime() then
			self:EmitSound("weapons/stunstick/alyx_stunner1.wav",100,math.random(125,155))
			self:EmitSound("ambient/levels/citadel/stalk_poweroff_on_17_10.wav")
			self.HackSound:Stop()
			self.hacktime = 0
			timer.Simple(math.random(0.5,5),function()
				if !self || self == NULL then return end
				local atm = self:GetParent()
				if !atm || atm == NULL || !atm.IsAFuckingATM then return end
				local accounts = ARCBank.GetAllAccounts(self.HackMoneh)
				if isnumber(accounts) || !accounts[1] then
					MsgN("HACK ERORR:"..tostring(accounts))
					self:StopHack()
					return
				end
				atm.args = {} 
				atm.args[ARCBANK_MONEY] = self.HackMoneh
				if self.HackRandom then
					atm.args[ARCBANK_NAME] = "*stealth mode*"
				else
					atm.args[ARCBANK_NAME] = accounts[arc_randomexp(1,#accounts)]
					PrintTable(accounts)
					--arc_randomexp
				end
				atm.UsePlayer = self.Hacker
				atm.TakingMoney = true
				atm:EmitSound("arcbank/atm/spit-out.wav")
				if self.bhacktime > 2700 then
					timer.Simple(6.5,function() atm:SetSkin( 1 ) end)
					timer.Simple(6.8,function() 
					
						atm:EmitSound("arcbank/atm/lolhack.wav")
						local moneyproppos = atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward()*15) + (atm:GetAngles():Right() * 4))
						local moneyproptopos = moneyproppos - (atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward() * 14) + (atm:GetAngles():Right() * 4)))
						atm.UsePlayer = nil
						timer.Destroy( "ATM_WIN" ) 
						timer.Create( "ATM_WIN", 0.2, math.Rand(10,20), function()
						
						local moneyprop = ents.Create( "base_anim" ) --I don't want to create another entity. 
						moneyprop:SetModel( "models/props/cs_assault/money.mdl" )
						moneyprop:SetPos( moneyproppos)
						local moneyang = atm:GetAngles()
						moneyang:RotateAroundAxis( moneyang:Up(), -90 )
						moneyprop:SetAngles( moneyang )
						moneyprop:PhysicsInit( SOLID_VPHYSICS )
						moneyprop:SetMoveType( MOVETYPE_VPHYSICS )
						moneyprop:SetSolid( SOLID_VPHYSICS )
						moneyprop:GetPhysicsObject():SetVelocity((moneyproptopos*3)*(VectorRand()*5)) 
						function moneyprop:Use( ply, caller )
							ARCBank.PlayerAddMoney(ply,1000)
							moneyprop:Remove()
						end
						moneyprop:Spawn()
						
						end)
					end)
					timer.Simple(11,function() 
						atm:SetSkin( 2 ) 
						atm:EmitSound("arcbank/atm/close.wav")
					end)
				else
					local moneyproppos = atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward()*8) + (atm:GetAngles():Right() * 4))
					local moneyproptopos = moneyproppos - (atm:GetPos() + ((atm:GetAngles():Up() * 6.3) + (atm:GetAngles():Forward() * 14) + (atm:GetAngles():Right() * 4)))
					moneyproptopos:Normalize()
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

					timer.Simple(6.5,function() atm.moneyprop:GetPhysicsObject():SetVelocity(moneyproptopos*-13) 
						atm:SetSkin( 1 ) end)
					timer.Simple(7,function() 
						atm.moneyprop:GetPhysicsObject():SetVelocity(Vector(0,0,0)) 
						atm.moneyprop:GetPhysicsObject():EnableMotion(false) 
					end)
						atm.MonehDelay = CurTime() + 8.5
					timer.Simple(7.5,function()
						atm.PlayerNeedsToDoSomething = true
					end)
				end
			end)
			else
				if !self.Hacker || self.Hacker == NULL || !self.Hacker:IsPlayer() then
					self:StopHack()
				end
				self.HackSound:ChangePitch( 85+((((self.hacktime-CurTime())/self.bhacktime)-1)*-100), 0.2 ) 
				local pos = self.StartPos - Vector(0.0,((((self.hacktime-CurTime())/self.bhacktime)-1)*1.25)*-self.left,0)
				self:SetPos(pos)
				if !self.HackRandom || (tobool(math.Round(math.random())) && tobool(math.Round(math.random())) && tobool(math.Round(math.random()))) then
					self.spark:Fire( "SparkOnce","",math.Rand(0,0.2) )
				end
			end
		end
	else
		self.StartPos = self:GetParent():WorldToLocal(self:GetPos())
		self.spark:Fire( "SparkOnce","",0.01 )
		--self.spark:Fire( "Kill","",0.01 )
		--self.spark:Fire("kill","",0.2)
		self.hacking = true
		self:EmitSound("buttons/button6.wav")
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav",100,math.random(92,125))
		self.HackSound = CreateSound(self, "ambient/energy/electric_loop.wav" )
		self.HackSound:Play();
		self.HackSound:ChangePitch( 85, 0.1 ) 
		if self.HackRandom then
			self.HackSound:ChangeVolume( 0.275, 0.45 ) 
		
		end
		--Player.getJobTable( )
		--ARCBank.UserMsgs.Hack
		if string.lower(GAMEMODE.Name) == "darkrp" then
			for _,v in pairs(player.GetHumans()) do
				if string.StartWith( GAMEMODE.Version, "2.5." ) then
					if table.HasValue(ARCBank.Settings["atm_hack_notify"],string.lower(v:getJobTable().name)) then
						v:SendLua("notification.AddLegacy( tostring(ARCBank.UserMsgs.Hack), 1, 5 )")
					end
				end
			end
		end
		self:NextThink( CurTime() + 0.5 )
		local basetime = math.Round((((self.HackMoneh/200)^2+28)*(1+booltonumber(self.HackRandom)*3)))
		self.bhacktime = math.Rand(basetime-math.Round(basetime^0.725),basetime+math.Round(basetime^0.725))
		self.hacktime = self.bhacktime + CurTime()
		net.Start( "ARCATMHACK_BEGIN" )
		net.WriteFloat(self.hacktime-CurTime())
		net.WriteEntity(self:GetParent())
		net.WriteBit(true)
		net.Broadcast()
		self:GetParent().HackUnit = self.Entity
		return true
	end
end

function ENT:OnRemove()
	if self.spark && self.spark != NULL then
		self.spark:Fire( "Kill","",0.01 )
	end
end

function ENT:Use( ply, caller )--self:StopHack()
	if (IsValid(self.Hacker) && self.Hacker:IsPlayer() && ply != self.Hacker) || self.OurHealth <= 0 then return end
	if self.init then
		if self:GetParent() != NULL && self:GetParent().UsePlayer then return end
		self:StopHack()
	else
		ply:Give("weapon_arc_atmhack")
		self.Entity:Remove()
		ply:SelectWeapon("weapon_arc_atmhack")
	end
end
--[[
function ENT:Touch(activator, caller) --Based on easy engine wrench
	if self.OurHealth <= 0 then return end
	if activator == self.Hacker && !self.init then
	end
end
]]
function ENT:CPPICanTool(ply,tool)
	if !ply:IsPlayer() || self.ARCBank_MapEntity then
		return false
	else
		return true
	end
end
--[[





]]