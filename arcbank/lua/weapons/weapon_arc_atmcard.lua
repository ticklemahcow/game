AddCSLuaFile("weapon_arc_atmcard.lua")

SWEP.Author = "ARitz Cracker"
SWEP.Contact = "aritz-rocks@hotmail.com"
SWEP.Purpose = "ARitz Cracker Bank. The choice for the most privileged.™"
SWEP.Category = "ARitz Cracker Bank"
SWEP.Instructions = "Click to insert your card in something."
SWEP.Spawnable = true;
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/v_hands.mdl";
SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.ViewModelFOV = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.PrintName = "ARitz Cracker Bank Keycard"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID( "arc/atm_base/screen/card" )
	function SWEP:DrawHUD() 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( self.WepSelectIcon ) 
		--surface.DrawOutlinedRect( surface.ScreenWidth() - 512, surface.ScreenHeight() - 256, 512, 256 )
		surface.DrawTexturedRect( surface.ScreenWidth() - 512, surface.ScreenHeight() - 256, 512, 256 )
		draw.SimpleText(self.Owner:SteamID(), "ARCBankCard", surface.ScreenWidth() - 430, surface.ScreenHeight() - 94, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.Owner:Nick(), "ARCBankCard", surface.ScreenWidth() - 430, surface.ScreenHeight() - 55, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end
end
function SWEP:DrawViewModel()
end
function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	if !SERVER then return end
	local trace = self.Owner:GetEyeTrace()
	if trace.HitPos:Distance(self:GetPos()) < 75 then
		if trace.Entity.IsAFuckingATM then
			trace.Entity:ATM_USE(self.Owner)
		else
			self.Owner:SendLua("notification.AddLegacy(\"This \"..language.GetPhrase(\""..trace.Entity:GetClass().."\")..\" doesn't have an ATM slot.\", NOTIFY_HINT, 5)")
			--self.Owner:SendLua("notification.AddLegacy(\""..thing.."\", NOTIFY_HINT, 5)")
			
			
			self.Owner:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
		end
	else
		self.Owner:SendLua("notification.AddLegacy(\"The air doesn't have an ATM slot.\", NOTIFY_HINT, 5)")
		self.Owner:SendLua("LocalPlayer():EmitSound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )")
	end
end
function SWEP:SecondaryAttack() return end
function SWEP:Think()
end
function SWEP:Reload() return end