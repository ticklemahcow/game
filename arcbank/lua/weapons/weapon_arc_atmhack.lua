
if SERVER then
	AddCSLuaFile("weapon_arc_atmhack.lua")
	util.AddNetworkString( "arcatmhack_gui" )
end


SWEP.ARCBank_IsHacker = true
SWEP.Author = "ARitz Cracker"
SWEP.Contact = "aritz-rocks@hotmail.com"
SWEP.Purpose = "Be All Mafia"
SWEP.Category = "ARitz Cracker Bank"

SWEP.Spawnable = true;
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 56
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.PrintName = "ATM Hacking Unit"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.HoldType = "slam"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/props_lab/reciever01d.mdl"


SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0.8), angle = Angle(0, 0, -0) },
	["Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.6, -1.6), angle = Angle(0, 0, 0) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-1.9, 0.5, 0.317), angle = Angle(0, 0, 0) }
}
if CLIENT then
end
function SWEP:PrimaryAttack()
	if self.Aiming then
		self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple(0.3,function() 
			if self.Aiming then
				self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH2 ) 
				if !SERVER then return end
				local trace = self.Owner:GetEyeTrace()
				local Ang = trace.HitNormal:Angle()
				Ang.pitch = Ang.pitch + 90
				local blarg = ents.Create ("sent_arc_atmhack")
				blarg:SetPos(trace.HitPos+ trace.HitNormal * 2)
				blarg:SetParent(trace.Entity)
				blarg:SetAngles(Ang)
				blarg:Spawn()
				blarg:Activate()
				blarg.Hacker = self.Owner
				blarg.HackMoneh = self.Settings[1]
				blarg.HackRandom = self.Settings[2]
				self.Owner:StripWeapon(self:GetClass())
				timer.Simple(math.Rand(0,2),function()
					if blarg && blarg != NULL then
						blarg:BeginHack()
					end
				end)
				--constraint.Weld( blarg, trace.Entity, 0, 0, 0, true, false ) 
			else
			
			end
		end)
        self:SetNextPrimaryFire( CurTime() + 1.5 )
        self:SetNextSecondaryFire( CurTime() + 1.5 )
		--timer.Simple(1,function() self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_ND_DRAW ) 
		--self.Aiming = false end)
	end
end
function SWEP:SecondaryAttack()
	if self.SettingMenu then return end
    self:SetNextPrimaryFire( CurTime() + 1.5 )
    self:SetNextSecondaryFire( CurTime() + 1.5 )
	if SERVER then
		net.Start("arcatmhack_gui")
		net.WriteTable( self.Settings )
		net.Send(self.Owner)
	end
	self.SettingMenu = true
end
function SWEP:Think()
	if self:GetNextPrimaryFire() < CurTime() && self:GetNextSecondaryFire() < CurTime() then
		local trace = self.Owner:GetEyeTrace()
		local side = trace.Entity:WorldToLocal(trace.HitPos):__index("y")
		if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 25 && trace.Entity.IsAFuckingATM && !trace.Entity.InUse && !trace.Entity.Hacked && trace.Entity.CommInit) && (side > 22 || side < -22) then
			if !self.Aiming then
				MsgN("WOO!")
				self.Aiming = true
				self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_TO_TRIPMINE_ND )
				--self:SetNextPrimaryFire( CurTime() + 1.5 )
				--self:SetNextSecondaryFire( CurTime() + 1.5 )
			end
		else
			if self.Aiming then
				MsgN("NAH!")
				self.Aiming = false
				self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_TO_THROW_ND )
				--self:SetNextPrimaryFire( CurTime() + 1.5 )
				--self:SetNextSecondaryFire( CurTime() + 1.5 )
			end
		end
	end	
end
function SWEP:Reload() 
	self:SecondaryAttack()
end
function SWEP:Deploy()
        self.m_WeaponDeploySpeed=1
        self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_ND_DRAW )
        self:SetNextPrimaryFire( CurTime() + 1 )
        self:SetNextSecondaryFire( CurTime() + 1 )	
		self.Aiming = false
		self.Idle = true
		self.IdleDelay = CurTime() + 1.3
		self.ReloadDelay = CurTime() + .2
		self.ReloadAnim = true
	return true
end
--[[
Yes, this thing does use SWEP Construction Kit.
--]]


/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/

function SWEP:Initialize()
	self:SetWeaponHoldType( "slam" )
	self.Aiming = false
	self.ReloadButtonDelay = CurTime() + 1
	// other initialize code goes here

	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	else
		self.Settings = {500,false}
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then
	net.Receive( "arcatmhack_gui", function(length)
		local weapon = LocalPlayer():GetActiveWeapon()
		if (!weapon.ARCBank_IsHacker) then return end
		local setting = net.ReadTable()
		local hacktime = math.Round((((setting[1]/200)^2+28)*(1+booltonumber(setting[2])*3)))
		local hacktimeoff = math.Round(hacktime^0.725)
		local DermaPanel = vgui.Create( "DFrame" )
		DermaPanel:SetPos( surface.ScreenWidth()/2-130,surface.ScreenHeight()/2-100 )
		DermaPanel:SetSize( 260, 200 )
		DermaPanel:SetTitle( "ATM Hacking Unit Settings" )
		DermaPanel:SetVisible( true )
		DermaPanel:SetDraggable( true )
		DermaPanel:ShowCloseButton( false )
		DermaPanel:MakePopup()
		local NumLabel2 = vgui.Create( "DLabel", DermaPanel )
		NumLabel2:SetPos( 10, 30 )
		NumLabel2:SetText( "Total Amount of money to steal:" )
		NumLabel2:SizeToContents()
		local HackTimeL = vgui.Create( "DLabel", DermaPanel )
		HackTimeL:SetPos( 10, 138 )
		HackTimeL:SetText( "Estimated Hack Time: "..arc_timesentence(hacktime).."\ngive or take about ... "..arc_timesentence(hacktimeoff) )
		HackTimeL:SizeToContents()

		local StealthCheckbox = vgui.Create( "DCheckBoxLabel", DermaPanel ) // Create the checkbox
		StealthCheckbox:SetPos( 10, 75 )                        // Set the position
		StealthCheckbox:SetText( "Stealth Mode" )                   // Set the text next to the box
		StealthCheckbox:SetValue( booltonumber(setting[2]) )             // Initial value ( will determine whether the box is ticked too )
		StealthCheckbox:SizeToContents()                      // Make its size the same as the contents

		local About = vgui.Create( "DLabel", DermaPanel )
		About:SetText( "Hacks multiple accounts and withdrawls smaller\nvalues from each account to avoid detection." )
		About:SetPos( 10, 96 )
		About:SizeToContents()   
		local NumSlider2 = vgui.Create( "Slider", DermaPanel )
		NumSlider2:SetPos( 10, 40 )
		NumSlider2:SetWide( 260 )
		NumSlider2:SetMin(25)
		NumSlider2:SetMax(5000)
		NumSlider2:SetDecimals(0)
		NumSlider2:SetValue( setting[1] )
		NumSlider2.OnValueChanged = function( panel, value )
			NumSlider2:SetValue( math.Round(value/25)*25 )
			hacktime = math.Round((((math.Round(value/25)*25)/200)^2+28)*(1+booltonumber(StealthCheckbox:GetChecked())*3))
			hacktimeoff = math.Round(hacktime^0.725)
			HackTimeL:SetText( "Estimated Hack Time: "..arc_timesentence(hacktime).."\ngive or take about ... "..arc_timesentence(hacktimeoff) )
			HackTimeL:SizeToContents()
		end
		StealthCheckbox.OnChange = function( panel, value )
			hacktime = math.Round((((math.Round(NumSlider2:GetValue()/25)*25)/200)^2+28)*(1+booltonumber(value)*3))
			hacktimeoff = math.Round(hacktime^0.725)
			HackTimeL:SetText( "Estimated Hack Time: "..arc_timesentence(hacktime).."\ngive or take about ... "..arc_timesentence(hacktimeoff) )
			HackTimeL:SizeToContents()
		end
		local OkButton = vgui.Create( "DButton", DermaPanel )
		OkButton:SetText( "OK" )
		OkButton:SetPos( 10, 170 )
		OkButton:SetSize( 240, 20 )
		OkButton.DoClick = function()
			DermaPanel:Remove()
			net.Start("arcatmhack_gui")
			net.WriteEntity(weapon)
			net.WriteTable({NumSlider2:GetValue(),StealthCheckbox:GetChecked()})
			net.SendToServer()
		end
	end)
SWEP.VElements = {
	["hacker"] = { type = "Model", model = "models/props_lab/reciever01d.mdl", bone = "Slam_base", rel = "", pos = Vector(-0.601, -63.5, 23.981), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["hacker"] = { type = "Model", model = "models/props_lab/reciever01d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 5.9, -2.274), angle = Angle(123.75, 33.75, -5.114), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
else
	net.Receive( "arcatmhack_gui", function(length)
		local weapon = net.ReadEntity()
		local settings = net.ReadTable()
		if (!weapon.ARCBank_IsHacker) then return end
		MsgN("HI!")
		weapon.Settings = settings
		weapon.SettingMenu = false
	end)
end

