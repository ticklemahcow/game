include('shared.lua')
language.Add("sent_arc_atm","ARCBank ATM")
function ENT:Initialize()
end

function ENT:Think()

end

function ENT:OnRestore()
end
--[[fadsadad
function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
end
--]]
net.Receive( "ARCATMHACK_BEGIN", function(length)
	MsgN("WOO!")
	local time = net.ReadFloat()
	local atm = net.ReadEntity()
	local hack = tobool(net.ReadBit())
	if hack then
		atm.hackstart = CurTime()
		atm.HackTime = time
		atm.HackDelay = CurTime() + time
		atm.Hacked = true
		atm.NotifyMsg = ARCBank.ATMMsgs.HackBegin
		atm.ErrorLvl = 15
	else
		atm.hackstart = CurTime()
		atm.NotifyMsg = ARCBank.ATMMsgs.HackingError
		atm.ErrorLvl = 15
		atm.HackTime = 0
		atm.HackDelay = 0
		atm.Hacked = false
		atm.CommFailed = false
		atm.CommInitDelay = CurTime()
		atm.CommRetries = 5
		atm.CommInit = false
	end
end)