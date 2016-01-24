ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
include('shared.lua')
local icons_default = Material ("icon16/application.png", "nocull")
local icons_accept = Material ("icon16/information.png", "nocull")
local icons_error = Material ("icon16/error.png", "nocull")
local icons_question = Material ("icon16/help.png", "nocull")
local icons_log = Material ("icon16/page.png", "nocull")
local icons_wait = Material ("icon16/hourglass.png", "nocull")
local icons_input = Material ("icon16/textfield.png", "nocull")

local icons_welcome = Material ("icon16/emoticon_smile.png", "nocull")
local icons_mainmenu = Material ("icon16/application_home.png", "nocull")
local icons_cash = Material ("icon16/money.png", "nocull")
local icons_choose = Material ("icon16/folder_explore.png", "nocull")
local icons_rank = {}
icons_rank[0] = Material ("icon16/application_error.png", "nocull") --.. (p)
icons_rank[1] = Material ("icon16/user.png", "nocull")--Standard (p)
icons_rank[2] = Material ("icon16/medal_bronze_1.png", "nocull") --Bronze (p)
icons_rank[3] = Material ("icon16/medal_silver_3.png", "nocull") --Bronze (p)--Silver (p)
icons_rank[4] = Material ("icon16/medal_gold_2.png", "nocull") --Bronze (p)--Silver (p) --Gold(p)
icons_rank[5] = Material ("icon16/application_error.png", "nocull") --.. (g)
icons_rank[6] = Material ("icon16/group.png", "nocull") --Standard (g)
icons_rank[7] = Material ("icon16/group_add.png", "nocull") --Premium (g)
function ENT:Initialize()
	self.ShowHolo = true
	self.HoloReal = true
	self.AppIcon = icons_default
	self.WaitDelay = CurTime()
	self.WaitPercent = 0
	self.Resolutionx = 278
	self.Resolutiony = 306
	self.CommInit = false
	self.CommFailed = false
	self.CommInitDelay = CurTime() + math.random(5,10)
	self.CommRetries = 0
	self.UseDelay = CurTime() 
	self.NotifyDelay = CurTime()
	self.NotifyMsg = ARCBank.ATMMsgs.NetworkError
	self.ErrorLvl = 15
	self.Phase = 1
	self.InputMsg = "Input"
	self.InputNum = 0
	self.Yes = false
	self.Question = false
	self.InputtingNumber = false
	self.MoneyMsg = 0
	self.LogTable = {}
	self.NameTable = {}
	--Screen buttons start on 13
	self.buttonpos = {}
	self.ScreenOptions = {}
	self.LogPage = 0
	self.MaxLogPage = 1
	self.UpgradingGroup = false
	for i=1,8 do
		self.ScreenOptions[i] = "Option "..i..""
	end
	--Special thanks to swep construction kit
	local selectsprite = { sprite = "sprites/blueflare1", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
	local name = selectsprite.sprite.."-"
	local params = { ["$basetexture"] = selectsprite.sprite }
	local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
	for i, j in pairs( tocheck ) do
		if (selectsprite[j]) then
			params["$"..j] = 1
			name = name.."1"
		else
			name = name.."0"
		end
	end
	self.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
	

end

function ENT:Think()
	if self.CommInitDelay < CurTime() && !self.CommFailed && !self.CommInit then
		self.CommFailed = true
	end
	if LocalPlayer():Alive() && LocalPlayer().ARCBank_ATM == self.Entity && self.WaitDelay <= CurTime() && self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 25000 then
		self:PushCancel()
		notification.AddLegacy( ARCBank.ATMMsgs.PlayerTooFar, NOTIFY_ERROR, 2 )
		self.WaitDelay = CurTime() + 0.5
	end
end

function ENT:OnRestore()
end
local asdqwefwqaf = surface.GetTextureID( "arc/atm_base/screen/welcome_animated" ) 
function ENT:Screen_Welcome()
	ARCBank_Draw:Window(-129, -142, 238, 257,icons_welcome,ARCBank.ATMMsgs.Welcome)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( asdqwefwqaf )
	surface.DrawTexturedRect( -128, -122, 256, 256)
--draw.SimpleText( "ARitz Cracker Bank", "ARCBankATMBigger", 0, 140, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
end
function ENT:Screen_Options(doshiz)
	if self.ScreenMsg != "" then
		local bigwords = string.Explode( "\n", self.ScreenMsg )
		if #bigwords == 1 then
			ARCBank_Draw:Window(-135, -137, 250, 24,self.AppIcon,self.ScreenTitleMsg)	
			draw.SimpleText( bigwords[1], "ARCBankATMBigger", 0, -105, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		elseif #bigwords == 2 then
			ARCBank_Draw:Window(-135, -137-8, 250, 40,self.AppIcon,self.ScreenTitleMsg)	
			draw.SimpleText( bigwords[1], "ARCBankATMBigger", 0, -105-8, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
			draw.SimpleText( bigwords[2], "ARCBankATMBigger", 0, -105+8, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		elseif #bigwords == 3 then
			ARCBank_Draw:Window(-135, -137-16, 250, 56,self.AppIcon,self.ScreenTitleMsg)	
			draw.SimpleText( bigwords[1], "ARCBankATMBigger", 0, -105-16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
			draw.SimpleText( bigwords[2], "ARCBankATMBigger", 0, -105, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
			draw.SimpleText( bigwords[3], "ARCBankATMBigger", 0, -105+16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		end
	end
	for i=1,8 do
		if self.ScreenOptions[i] != "" && self.ScreenOptions[i] then
			local xpos
			local ypos = -58 + ((i-1)%4)*61
			local allign
			if i < 5 then
				xpos = self.Resolutionx/-2 + 5
				allign = TEXT_ALIGN_LEFT
			else
				xpos = self.Resolutionx/2 - 5
				allign = TEXT_ALIGN_RIGHT
			end
			local words = string.Explode( "\n", self.ScreenOptions[i] )
			if #words > 1 then
				draw.SimpleText( words[1], "ARCBankATM", xpos, ypos-6, Color(255,255,255,255), allign , TEXT_ALIGN_CENTER  ) 
				draw.SimpleText( words[2], "ARCBankATM", xpos, ypos+6, Color(255,255,255,255), allign , TEXT_ALIGN_CENTER  ) 
			else
				draw.SimpleText( words[1], "ARCBankATM", xpos, ypos, Color(255,255,255,255), allign , TEXT_ALIGN_CENTER  ) 
			end
		end
	end
	if !doshiz then return end
	--SHIT GOES HERE!
	if self.Phase == 2 && self.Yes && self.ActiveAccount[ARCBANK_RANK] > ARCBANK_GROUPACCOUNTS_ then
		self.Yes = false
		--MsgN("CLOSE ACCOUNT!!!!")
		net.Start( "ARCATM_COMM" )
		net.WriteEntity( self )
		net.WriteInt(ARCBANK_ATM_GROUPADMIN,ARCBANK_ATMBITRATE)
		net.WriteTable({false,false,self.ActiveAccount[ARCBANK_NAME],false,true})
		net.SendToServer()
	elseif self.Phase == 3 then -- DEPOSIT
		if self.InputNum > 0 then
			self.WaitPercent = 0
			self.WaitDelay = math.huge --Infinity
			--[[
			if GAMEMODE_NAME=="darkrp" && !LocalPlayer():CanAfford( self.InputNum ) then
			--if true then
				timer.Simple(1,function() self:ShowNotify("Check yer wallet!",ARCBANK_ERROR_NO_CASH_PLAYER,5) end)
				self:UpdatePhase(2) ;
				return
			end
			]]
			local accinfo = {} ;
			if self.ActiveAccount[ARCBANK_RANK] < ARCBANK_GROUPACCOUNTS_ then
				accinfo[ARCBANK_NAME] = ""
			else
				accinfo[ARCBANK_NAME] = self.ActiveAccount[ARCBANK_NAME]
			end
			accinfo[ARCBANK_RANK] = self.ActiveAccount[ARCBANK_RANK]
			accinfo[ARCBANK_MONEY] = self.InputNum
			timer.Simple(math.random(),function()
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_CASH,ARCBANK_ATMBITRATE)
				net.WriteTable(accinfo)
				net.SendToServer()
			end)
		end
	elseif self.Phase == 4 then -- WITHDRAWL
		if self.InputNum > 0 then
			self.WaitPercent = 0
			self.WaitDelay = math.huge
			local accinfo = {} ;
			if self.ActiveAccount[ARCBANK_RANK] < ARCBANK_GROUPACCOUNTS_ then
				accinfo[ARCBANK_NAME] = ""
			else
				accinfo[ARCBANK_NAME] = self.ActiveAccount[ARCBANK_NAME]
			end
			accinfo[ARCBANK_RANK] = self.ActiveAccount[ARCBANK_RANK]
			accinfo[ARCBANK_MONEY] = -self.InputNum
			timer.Simple(math.Rand(1,2),function()
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_CASH,ARCBANK_ATMBITRATE)
				net.WriteTable(accinfo)
				net.SendToServer()
			end)
		end
	elseif self.Phase == 5 && !self.SearchingGroup then
		if !self.GivingMoney && self.sidinput && self.sidinput != "" then
			if self.PlayerGroup then
				--MsgN(self.ActiveAccount[ARCBANK_NAME])
				--MsgN(self.sidinput)
				self.WaitPercent = 0
				self.WaitDelay = math.huge
				
				
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_GROUPADMIN,ARCBANK_ATMBITRATE)
				net.WriteTable({self.AddPlayerToGroup,self.sidinput,self.ActiveAccount[ARCBANK_NAME]})
				net.SendToServer()
			else
				self.InputNum = 0
				self.ScreenMsg = ARCBank.ATMMsgs.GiveMoneyAccount
				self.GivingMoney = true
				self.CurrentNameTable = 1
				self.IgnoreChunks = false
				self.WaitDelay = math.huge
				self.WaitPercent = 0
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
				net.WriteTable({true,self.sidinput,true})
				net.SendToServer()
			end
		elseif self.GivingMoney && self.InputNum > 0 then
			--MsgN("Transfered "..self.InputNum.." to "..self.sidinput)
			local accdata = {}
			accdata[ARCBANK_PLAYER] = self.giveplyname
			accdata[ARCBANK_NAMETO] = self.sidinput
			if self.ActiveAccount[ARCBANK_RANK] < ARCBANK_GROUPACCOUNTS_ then
				accdata[ARCBANK_NAME] = ""
			else
				accdata[ARCBANK_NAME] = self.ActiveAccount[ARCBANK_NAME]
			end
			accdata[ARCBANK_MONEY] = self.InputNum
			self.WaitDelay = math.huge
			self.WaitPercent = 0
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ATM_TRANSFER,ARCBANK_ATMBITRATE)
			net.WriteTable(accdata)
			net.SendToServer()
		end
	end
end
local ghgjhgshjghjsad = surface.GetTextureID( "arc/atm_base/screen/givemoneh" ) 
local sdhusai = surface.GetTextureID( "arc/atm_base/screen/takemoneh" ) 
function ENT:Screen_Loading()
	if self.MoneyMsg == 0 then
		ARCBank_Draw:Window(-125, -60, 230, 80,icons_wait,ARCBank.ATMMsgs.Loading)	
		--draw.SimpleText( self.NotifyMsg, "ARCBankATMBigger", 0, 8, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( -120, -7, 240, 14) 
		if self.WaitPercent == 0 then
			local xpox = (math.tan(CurTime()*1.25)*35)-20
			draw.SimpleText( ARCBank.ATMMsgs.LoadingMsg, "ARCBankATMBigger", 0, -16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
			surface.DrawRect( math.Clamp(xpox,-120,200), -7, math.Clamp(xpox+160,0,40)-math.Clamp(xpox-80,0,40), 14)
			draw.SimpleText("---%", "ARCBankATMBigger", 0, 16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		else
			draw.SimpleText(ARCBank.ATMMsgs.LoadingMsg, "ARCBankATMBigger", 0, -16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
			surface.DrawRect( -120, -7, 240*self.WaitPercent, 14)
			draw.SimpleText(math.floor(self.WaitPercent*100).."%", "ARCBankATMBigger", 0, 16, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		end
	elseif self.MoneyMsg == 1 then
		ARCBank_Draw:Window(-129, -78, 238, 129,icons_cash,ARCBank.ATMMsgs.Waiting)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( ghgjhgshjghjsad )
		surface.DrawTexturedRect( -128, -58, 256, 128)
		draw.SimpleText( ARCBank.ATMMsgs.GiveCash, "ARCBankATM",0, 140, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	elseif self.MoneyMsg == 2 then
		ARCBank_Draw:Window(-129, -78, 238, 129,icons_cash,ARCBank.ATMMsgs.Waiting)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( sdhusai )
		surface.DrawTexturedRect( -128, -58, 256, 128)
		draw.SimpleText( ARCBank.ATMMsgs.TakeCash, "ARCBankATM",0, 140, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	end
end
function ENT:Screen_Question()
	ARCBank_Draw:Window(-125, -75, 230, 130,icons_question,"Question")
	local qwords = string.Explode( "\n", self.QuestionMsg )	
	for i=1,table.maxn(qwords) do
		draw.SimpleText(qwords[i], "ARCBankATMBigger", 0, ((table.maxn(qwords)/-2)*16)+(i*16), Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	end
	draw.SimpleText( ARCBank.ATMMsgs.Yes, "ARCBankATM",self.Resolutionx/2 - 10, 125, Color(255,255,255,255), TEXT_ALIGN_RIGHT , TEXT_ALIGN_CENTER  ) 
	draw.SimpleText( ARCBank.ATMMsgs.No, "ARCBankATM",self.Resolutionx/-2 + 10, 125, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
	---302
end
function ENT:Screen_Number()
	ARCBank_Draw:Window(-125, -60, 230, 80,icons_input,"Input")
	draw.SimpleText(ARCBank.ATMMsgs.Keypad, "ARCBankATMBigger", 0, -8, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	if self.InputNum > 0 then
		draw.SimpleText(self.InputNum, "ARCBankATMBigger", 0, 8, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
		draw.SimpleText( ARCBank.ATMMsgs.Enter, "ARCBankATM",0, 140, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	end
	draw.SimpleText( self.InputMsg, "ARCBankATM",0, 125, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
end
function ENT:Screen_Notify()
	if self.ErrorLvl && self.ErrorLvl > 0 then
		ARCBank_Draw:Window(-125, -75, 230, 130,icons_error,"Error")
		draw.SimpleText( "Error", "ARCBankATMBigger", -105, -65, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
	else
		ARCBank_Draw:Window(-125, -75, 230, 130,icons_accept,"Message")
	end
	local nwords = string.Explode( "\n", self.NotifyMsg )	
	for i=1,table.maxn(nwords) do
		draw.SimpleText(nwords[i], "ARCBankATMBigger", 0, ((table.maxn(nwords)/-2)*16)+(i*16), Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	end
end
function ENT:Screen_Log()
	--draw.SimpleText( self.NotifyMsg, "ARCBankATMBigger", 0, 8, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	ARCBank_Draw:Window(-136, -150, 252, 230,icons_log,	string.Replace( ARCBank.ATMMsgs.File, "%PAGE%", tostring(self.LogPage+1).."/"..tostring(self.MaxLogPage+1) ) )
	for i=self.LogPage*28,((self.LogPage+1)*28)-1 do
		if self.LogTable[i+1] then
			draw.SimpleText( self.LogTable[i+1], "ARCBankATMSmall", -134, -122+((i-self.LogPage*28)*8), Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
		--else
			--draw.SimpleText( "--END OF FILE--", "ARCBankATMSmall", -134, -122+(i*8), Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
		end
		--draw.SimpleText( "LOG ENTRY", "ARCBankATMSmall", -134, -122+(i*8), Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
		--
	end
	draw.SimpleText( ARCBank.ATMMsgs.FileNext, "ARCBankATM",self.Resolutionx/2 - 10, 125, Color(255,255,255,255), TEXT_ALIGN_RIGHT , TEXT_ALIGN_CENTER  ) 
	draw.SimpleText( ARCBank.ATMMsgs.FileClose, "ARCBankATM",0, 140, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	draw.SimpleText( ARCBank.ATMMsgs.FilePrev, "ARCBankATM",self.Resolutionx/-2 + 10, 125, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
	---302 self.LogPage
end
function ENT:Screen_HAX()
	local hackmsg = ""
	if self.WaitPercent < math.Rand(0.50,0.75) then
		hackmsg = "Decoding Security Syetem"
		for i=-12,13 do
			if (self.WaitPercent) > 0.005 then
				draw.SimpleText( math.random(10000000000000,99999999999999), "ARCBankATM",self.Resolutionx/-2, i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
			end
			if (self.WaitPercent) > 0.0195 then
				draw.SimpleText( math.random(10000000000000,99999999999999), "ARCBankATM",-41, i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  ) 	
			end
			if (self.WaitPercent) > 0.030 then
				draw.SimpleText( math.random(100000000000,999999999999), "ARCBankATM",57, i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  ) 	
			end
		end
	else
		hackmsg = "Accesing Network..."
		draw.SimpleText( "Using username \"admin\"", "ARCBankATM",self.Resolutionx/-2, -140, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
		draw.SimpleText( "Authenticating...", "ARCBankATM",self.Resolutionx/-2, -124, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
		draw.SimpleText( "Login Successful!", "ARCBankATM",self.Resolutionx/-2, -108, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
		draw.SimpleText( "**ARCBank ATM**", "ARCBankATM",self.Resolutionx/-2, -92, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
		draw.SimpleText( "admin@atm_"..tostring(self:EntIndex()).."~$", "ARCBankATM",self.Resolutionx/-2, -76, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
	end
	ARCBank_Draw:Window(-136, -150, 252, 20,icons_default,"ATM_CRACKER")
	draw.SimpleText( hackmsg, "ARCBankATMBigger",0, -120, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
	
end
function ENT:Screen_Main()
	--if LocalPlayer():GetEyeTrace().Entity == self then
		--end
		if self.Hacked && self.HackDelay < CurTime() then
			surface.SetDrawColor( 10, 10, 10, 255 )
			surface.DrawOutlinedRect( (self.Resolutionx+2)/-2, (self.Resolutiony+2)/-2, self.Resolutionx+2, self.Resolutiony+2 ) 
			surface.SetDrawColor( 0, 0, 0, 255 )
		else
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.DrawOutlinedRect( (self.Resolutionx+2)/-2, (self.Resolutiony+2)/-2, self.Resolutionx+2, self.Resolutiony+2 ) 
			surface.SetDrawColor( 25, 100, 255, 200 )
		end
		surface.DrawRect( self.Resolutionx/-2, self.Resolutiony/-2, self.Resolutionx, self.Resolutiony ) 
		if self.CommInit then
			if self.Hacked  then
				if self.HackDelay > CurTime() then
					self:Screen_HAX()
					self.WaitPercent = (((self.HackDelay-CurTime())/self.HackTime)*-1)+1
					if self.WaitPercent < 0.001 then
					elseif self.WaitPercent < 0.03125 then
						self:Screen_Notify()
					elseif self.WaitPercent < 0.0575 then
						self:Screen_Notify()
					elseif self.WaitPercent < 0.34 then
						if tobool(math.Round(math.random())) then
							self.NotifyMsg = table.Random({"WARNING!\nBREACH CRITICAL!","BDSM GAY BUTTSEKS","SYSTEM\nOVERRIDE\nWARNING","%DH@#$H434FF#!$##H%@\n#H#@#//343SDds21#@\n$#$#3tg23#$%#&*","ERROR: P3N15","UNKNOWN ERROR UNKNOWN ERROR\nUNKNOWN ERROR UNKNOWN ERROR\nUNKNOWN ERROR UNKNOWN ERROR\nUNKNOWN ERROR UNKNOWN ERROR\nUNKNOWN ERROR UNKNOWN ERROR\nUNKNOWN ERROR UNKNOWN ERROR",""})
						end
						self:Screen_Notify()
					elseif self.WaitPercent < math.Rand(0.30,0.46) then
						self.NotifyMsg = "SECURITY BREACH\nSYSTEM\nOVERRIDE"
						self:Screen_Notify()
					else
						self:Screen_Loading()
					end
				end
			elseif self.InUse then
				if self.NotifyDelay > CurTime() then
					if !self.InputtingNumber && !self.ViewingLogs then
						self:Screen_Options(false)
					end
					self:Screen_Notify()
				elseif self.WaitDelay > CurTime() then
					self:Screen_Loading()
				elseif self.Question then
					self:Screen_Question()
				elseif self.InputtingNumber then
					self:Screen_Number()
				elseif self.ViewingLogs then
					self:Screen_Log()
				else
					self:Screen_Options(true)
				end
			else
				self:Screen_Welcome()
			end
		else
			if self.CommInitDelay <= CurTime() then
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self.Entity )
				net.WriteInt(ARCBANK_ATM_PING,ARCBANK_ATMBITRATE)
				net.WriteTable( {LocalPlayer()} )
				net.SendToServer()
				self.CommRetries = self.CommRetries + 1
				self.CommInitDelay = CurTime() + math.Rand(3.5,3.8)
			end
			if self.CommRetries > 5 then
				local str = "------------------------------------"
				local time = math.Round(math.tan(CurTime()*1)*5) + 18
				if time > 0 && time < 37 then
					str = string.SetChar( str,time,"#")
				end
				--[[
				draw.SimpleText( "-I'm temporarily out of service. :(-", "ARCBankATM", 0, -12, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( str, "ARCBankATM", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
				draw.SimpleText( "Failiure to communicate with server.", "ARCBankATM", 0, 12, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				]]
				self:Screen_Notify()
			else
				draw.SimpleText( "**ARCBank ATM**", "ARCBankATM",self.Resolutionx/-2, -140, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
				draw.SimpleText( "Connecting to server...", "ARCBankATM",self.Resolutionx/-2, -124, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
				if self.CommRetries > 0 then
					for i=1,self.CommRetries do
						draw.SimpleText( "Retrying...", "ARCBankATM",self.Resolutionx/-2, -124+(i*16), Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP  )
					end
				end
				local strs = "------ System startup.... ------"
				local str = "--------------------------------"
				local time = math.Round(math.tan(CurTime()*1)*5) + 16
				if time > 0 && time < 33 then
					str = string.SetChar( str,time,"#")
				end
				if time > 0 && time < 7 then
					strs = string.SetChar( strs,time,"#")
				elseif time > 26 && time < 33 then
					strs = string.SetChar( strs,time,"#")
				end
				draw.SimpleText( strs, "ARCBankATM", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( str, "ARCBankATM", 0, 12, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
				draw.SimpleText( str, "ARCBankATM", 0, -12, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
			end
		end
		if self.Hacked then
			if self.WaitPercent < 0.999 then
				for i=1,math.random(self.WaitPercent*100,self.WaitPercent*200) do
					surface.SetDrawColor( 0, 0, 0, 255 )
					surface.DrawRect( math.random((self.Resolutionx/-2)-20,10), math.random(self.Resolutiony/-2,self.Resolutiony/2), math.random(0,self.Resolutionx), math.random(0,40)*self.WaitPercent ) 
				end
			else	
				--MsgN("DONE!")
				--surface.SetDrawColor( 255, 255, 255, 200 )
				--surface.DrawOutlinedRect( (self.Resolutionx+2)/-2, (self.Resolutiony+2)/-2, self.Resolutionx+2, self.Resolutiony+2 ) 
			end
		end
end
function ENT:DrawHolo()
	if self.HoloReal then
		draw.SimpleText( "$$ ATM $$", "ARCBankHolo",math.Rand(-0.5,0.5), math.Rand(0,0.25), Color(255,255,255,math.random(150,200)), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	else
		draw.SimpleText( "$$ ATM $$", "ARCBankHolo",0,0, Color(255,255,255,175), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  ) 
	end
	--[[
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( asdqwefwqaf )
	surface.DrawTexturedRect( -128, -128, 256, 256)
	]]
end



hook.Add( "CalcView", "MyCalcView",function( ply, pos, angles, fov )
	if LocalPlayer().ARCBank_UsingATM && IsValid(LocalPlayer().ARCBank_ATM) && LocalPlayer().ARCBank_ATM.WaitDelay < math.huge && LocalPlayer().ARCBank_ATM.MoneyMsg == 0 && LocalPlayer().ARCBank_FullScreen && IsValid(LocalPlayer().ARCBank_ATM) then
		local view = {}
--    view.origin = pos-( angles:Forward()*100 )
--    view.angles = angles
--    view.fov = fov
		view.origin = LocalPlayer().ARCBank_ATM:GetPos() + (LocalPlayer().ARCBank_ATM:GetAngles():Up() * 22) + (LocalPlayer().ARCBank_ATM:GetAngles():Forward() * 25) + (LocalPlayer().ARCBank_ATM:GetAngles():Right() * 3)
		local aim = view.origin + (LocalPlayer().ARCBank_ATM:GetAngles():Up() * -1 ) + (LocalPlayer().ARCBank_ATM:GetAngles():Forward() * -3.2)
		view.angles = (aim - view.origin):Angle()
		ply:SetEyeAngles( ( LocalPlayer().ARCBank_ATM.DisplayPos - ply:GetShootPos() ):Angle() )
		view.fov = fov
		return view
	end
end
)


function ENT:Draw()
	local Rand1 = 0
	local Rand2 = 0
	if self.Hacked && self.HackDelay > CurTime() && self.WaitPercent > math.Rand(0.111,0.325) then
		Rand1 = math.Rand(-0.2,0.2)
		Rand2 = math.Rand(-0.00001,0.0005)
	end
	self.DisplayPos = self:GetPos() + ((self:GetAngles():Up() * 20) + (self:GetAngles():Forward() * 3.2) + (self:GetAngles():Right() * (3 + Rand1) ))
	self.displayangle1 = self:GetAngles()+Angle( 0, 0, 90 )
	self.displayangle1:RotateAroundAxis( self.displayangle1:Right(), -90 )
	self.displayangle1:RotateAroundAxis( self.displayangle1:Forward(), -13 )
	--self.screenpos = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
	local dlight
	local lbright
	if !self.Hacked || self.WaitPercent <= 1-1e-3 then
		dlight = DynamicLight( self:EntIndex() )
		if self.Hacked then
			lbright = 24 + ((self.WaitPercent - 1) * -40)
		else
			lbright = 64
		end
	end
	if ( dlight ) then
		dlight.Pos = self.DisplayPos + (self:GetAngles():Forward() * 1)
		dlight.r = 25
		dlight.g = 100
		dlight.b = 255
		dlight.Brightness = 1.5
		dlight.Size = lbright
		dlight.Decay = 256
		dlight.DieTime = CurTime() + 1
        dlight.Style = 0
	end	
	self:DrawModel()
	self:DrawShadow( true )
	if self.ShowHolo then
		self.HoloPos = self:GetPos() + (self:GetAngles():Up() * (45+math.sin(CurTime()*1)*3))
		self.HoloAng1 = self:GetAngles()+Angle( 0, 0, 90 )
		self.HoloAng1:RotateAroundAxis( self.HoloAng1:Right(), (CurTime()*36)%360 )
		cam.Start3D2D(self.HoloPos, self.HoloAng1, 0.15)
		
			self:DrawHolo()
		cam.End3D2D()
		self.HoloAng1:RotateAroundAxis( self.HoloAng1:Right(), 180 )
		cam.Start3D2D(self.HoloPos, self.HoloAng1, 0.15)
			self:DrawHolo()
		cam.End3D2D()
	end
	
	
	cam.Start3D2D(self.DisplayPos, self.displayangle1, 0.05+Rand2)
		self:Screen_Main()
	cam.End3D2D()
	--[[
	cam.Start3D2D(self.DisplayPos+Vector(0,0,24), self.displayangle1, 0.05+Rand2)
		self:Screen_Main()
	cam.End3D2D()
	]]	
	--render.DrawSprite( self:NearestPoint( LocalPlayer():GetPos() ), 100, 100, Color( 255, 255, 255, 255 ) )
	------KEYPAD------
	--1  2  3   10(ENTER)
	--4  5  6   11(BACKSPACE)
	--7  8  9   12(CANCEL)
	--21 0  22  23(BLANK)
	
	--SCREEN--
	--13  17--
	--14  18--
	--15  19--
	--16  20--
	if !self.InUse then return end
	local Ply = LocalPlayer()
	self.buttonpos[1] = self:GetPos() + ((self:GetAngles():Up() * 11.4) + (self:GetAngles():Forward() * 7.3) + (self:GetAngles():Right() * 7.6))
	self.buttonpos[2] = self:GetPos() + ((self:GetAngles():Up() * 11.4) + (self:GetAngles():Forward() * 7.3) + (self:GetAngles():Right() * 5.25))
	self.buttonpos[3] = self:GetPos() + ((self:GetAngles():Up() * 11.4) + (self:GetAngles():Forward() * 7.3) + (self:GetAngles():Right() * 3))
	self.buttonpos[10] = self:GetPos() + ((self:GetAngles():Up() * 11.4) + (self:GetAngles():Forward() * 7.3) + (self:GetAngles():Right() * -0.7))
	self.buttonpos[4] = self:GetPos() + ((self:GetAngles():Up() * 10.6) + (self:GetAngles():Forward() * 8.9) + (self:GetAngles():Right() * 7.6))
	self.buttonpos[5] = self:GetPos() + ((self:GetAngles():Up() * 10.6) + (self:GetAngles():Forward() * 8.9) + (self:GetAngles():Right() * 5.25))
	self.buttonpos[6] = self:GetPos() + ((self:GetAngles():Up() * 10.6) + (self:GetAngles():Forward() * 8.9) + (self:GetAngles():Right() * 3))
	self.buttonpos[11] = self:GetPos() + ((self:GetAngles():Up() * 10.6) + (self:GetAngles():Forward() * 8.9) + (self:GetAngles():Right() * -0.7))
	self.buttonpos[7] = self:GetPos() + ((self:GetAngles():Up() * 9.8) + (self:GetAngles():Forward() * 10.5) + (self:GetAngles():Right() * 7.6))
	self.buttonpos[8] = self:GetPos() + ((self:GetAngles():Up() * 9.8) + (self:GetAngles():Forward() * 10.5) + (self:GetAngles():Right() * 5.25))
	self.buttonpos[9] = self:GetPos() + ((self:GetAngles():Up() * 9.8) + (self:GetAngles():Forward() * 10.5) + (self:GetAngles():Right() * 3))
	self.buttonpos[12] = self:GetPos() + ((self:GetAngles():Up() * 9.8) + (self:GetAngles():Forward() * 10.5) + (self:GetAngles():Right() * -0.7))
	
	self.buttonpos[21] = self:GetPos() + ((self:GetAngles():Up() * 9) + (self:GetAngles():Forward() * 12.1) + (self:GetAngles():Right() * 7.6))
	self.buttonpos[0] = self:GetPos() + ((self:GetAngles():Up() * 9) + (self:GetAngles():Forward() * 12.1) + (self:GetAngles():Right() * 5.25))
	self.buttonpos[22] = self:GetPos() + ((self:GetAngles():Up() * 9) + (self:GetAngles():Forward() * 12.1) + (self:GetAngles():Right() * 3))
	self.buttonpos[23] = self:GetPos() + ((self:GetAngles():Up() * 9) + (self:GetAngles():Forward() * 12.1) + (self:GetAngles():Right() * -0.7))
	
	self.buttonpos[13] = self:GetPos() + ((self:GetAngles():Up() * 23) + (self:GetAngles():Forward() * 3.5) + (self:GetAngles():Right() * 12.05))
	self.buttonpos[17] = self:GetPos() + ((self:GetAngles():Up() * 23) + (self:GetAngles():Forward() * 3.5) + (self:GetAngles():Right() * -6.05))
	self.buttonpos[14] = self:GetPos() + ((self:GetAngles():Up() * 20) + (self:GetAngles():Forward() * 4.2) + (self:GetAngles():Right() * 12.05))
	self.buttonpos[18] = self:GetPos() + ((self:GetAngles():Up() * 20) + (self:GetAngles():Forward() * 4.2) + (self:GetAngles():Right() * -6.05))
	self.buttonpos[15] = self:GetPos() + ((self:GetAngles():Up() * 17) + (self:GetAngles():Forward() * 4.9) + (self:GetAngles():Right() * 12.05))
	self.buttonpos[19] = self:GetPos() + ((self:GetAngles():Up() * 17) + (self:GetAngles():Forward() * 4.9) + (self:GetAngles():Right() * -6.05))
	self.buttonpos[16] = self:GetPos() + ((self:GetAngles():Up() * 14) + (self:GetAngles():Forward() * 5.6) + (self:GetAngles():Right() * 12.05))
	self.buttonpos[20] = self:GetPos() + ((self:GetAngles():Up() * 14) + (self:GetAngles():Forward() * 5.6) + (self:GetAngles():Right() * -6.05))
	
	render.SetMaterial(self.spriteMaterial)
	render.DrawSprite(gui.ScreenToVector( gui.MousePos() ), 2, 2, Color(255,255,255,200))
	self.Dist = math.huge
	self.Highlightbutton = -1
	self.CurPos = LocalPlayer():GetEyeTrace().HitPos
	for i=0,23 do
		if self.buttonpos[i] then
			if LocalPlayer().ARCBank_FullScreen then
				local butscrpos = self.buttonpos[i]:ToScreen()
				if Vector(butscrpos.x,butscrpos.y,0):IsEqualTol( Vector(gui.MouseX(),gui.MouseY(),0), surface.ScreenHeight()/20  ) then
					if Vector(butscrpos.x,butscrpos.y,0):DistToSqr(Vector(gui.MouseX(),gui.MouseY(),0)) < self.Dist then
						self.Dist = Vector(butscrpos.x,butscrpos.y,0):DistToSqr(Vector(gui.MouseX(),gui.MouseY(),0))
						self.Highlightbutton = i
					end
				end
			else
				if self.buttonpos[i]:IsEqualTol(self.CurPos,1.6) then
					if self.buttonpos[i]:DistToSqr(self.CurPos) < self.Dist then
						self.Dist = self.buttonpos[i]:DistToSqr(self.CurPos)
						self.Highlightbutton = i
					end
				--else
					--render.DrawSprite(self.buttonpos[i], 6.5, 6.5, Color(255,0,0,255))
				end
			end
		end
	end
	--self.UseButton = self.Highlightbutton
	if self.Highlightbutton >= 0 && Ply:GetShootPos():Distance(self.CurPos) < 70 then
		render.DrawSprite(self.buttonpos[self.Highlightbutton], 6.5, 6.5, Color(255,255,255,255))
		local pushedbutton
		if LocalPlayer().ARCBank_FullScreen then
			pushedbutton = input.IsMouseDown(MOUSE_LEFT)
		else
			pushedbutton = --[[Ply:KeyDown(IN_USE)||]]Ply:KeyReleased(IN_USE)||Ply:KeyDownLast(IN_USE)
		end
		if self.UseDelay <= CurTime() && pushedbutton && self.WaitDelay <= CurTime() && self.NotifyDelay <= CurTime() then
			--ARCBankMsgToServer("PLAYER USED ATM - "..tostring(self.Highlightbutton))
			self.UseDelay = CurTime() + 0.3
			if self.Highlightbutton <= 9 || self.Highlightbutton == 11 then
				self:PushNumber(self.Highlightbutton)
			elseif self.Highlightbutton == 10 then
				self:PushEnter()
			elseif self.Highlightbutton == 12 then
				self:PushCancel()
			elseif self.Highlightbutton <= 20 then
				self:PushScreen(self.Highlightbutton-12)
			else
				self:PushDev(self.Highlightbutton-20)
			end
		end
	end
end
--2781
function ENT:UpdatePhase(num)
	self.GivingMoney = false
	self.Yes = false
	self.sidinput = nil
	self.InputNum = 0
	if num == 1 then
		self.AppIcon = icons_mainmenu
		for i=5,8 do
			self.ScreenOptions[i] = ""
		end
		
		self.ScreenTitleMsg = "ARitz Cracker Banking"
		self.ScreenMsg = string.Replace( ARCBank.ATMMsgs.MainMenu, "%PLAYERNAME%", LocalPlayer():Nick() ) 
		self.ScreenOptions[1] = ARCBank.ATMMsgs.PersonalInformation
		self.ScreenOptions[2] = ARCBank.ATMMsgs.PersonalUpgrade
		self.ScreenOptions[3] = ""
		self.ScreenOptions[5] = ARCBank.ATMMsgs.GroupInformation
		self.ScreenOptions[6] = ARCBank.ATMMsgs.GroupUpgrade
		self.ScreenOptions[7] = ""
		self.ScreenOptions[8] = ARCBank.ATMMsgs.Fullscreen
		self.ScreenOptions[4] = ARCBank.ATMMsgs.Exit
	elseif num == 2 then
		if self.GroupAccount then
			local accdata = {}
			accdata[ARCBANK_NAME] = self.ActiveAccount[ARCBANK_NAME]
			self.WaitDelay = math.huge
			self.WaitPercent = 0
			--timer.Simple(1,function()
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_ACCOUNTINFO,ARCBANK_ATMBITRATE)
				net.WriteTable(accdata)
				net.SendToServer()
			--end)
		else
			self.WaitDelay = math.huge
			self.WaitPercent = 0
			--timer.Simple(1,function()
				net.Start( "ARCATM_COMM" )
				net.WriteEntity( self )
				net.WriteInt(ARCBANK_ATM_ACCOUNTINFO,ARCBANK_ATMBITRATE)
				net.WriteTable({})
				net.SendToServer()
			--end)
		end
		self.ScreenMsg = ARCBank.ATMMsgs.Balance.."\n---"
		self.ScreenOptions[1] = ARCBank.ATMMsgs.Deposit
		self.ScreenOptions[2] = ARCBank.ATMMsgs.ViewLog
		self.ScreenOptions[3] = ""
		self.ScreenOptions[4] = ARCBank.ATMMsgs.Back
		self.ScreenOptions[5] = ARCBank.ATMMsgs.Withdrawal
		self.ScreenOptions[6] = ARCBank.ATMMsgs.Transfer
		self.ScreenOptions[7] = ""
		self.ScreenOptions[8] = ""
	elseif num == 3 || num == 4 then
		self.ScreenOptions[1] = "20"
		self.ScreenOptions[2] = "40"
		self.ScreenOptions[3] = "60"
		self.ScreenOptions[4] = "80"
		self.ScreenOptions[5] = "100"
		self.ScreenOptions[6] = "200"
		self.ScreenOptions[7] = "400"
		self.ScreenOptions[8] = ARCBank.ATMMsgs.OtherNumber
		if num == 3 then
			self.InputMsg = ARCBank.ATMMsgs.DepositAsk
		elseif num == 4 then
			self.InputMsg = ARCBank.ATMMsgs.WithdrawalAsk
		end
	elseif num == 5 then
		self.ScreenTitleMsg = "Search"
		self.AppIcon = icons_choose
		if self.PlayerGroup && !self.AddPlayerToGroup then
			self.NameTable = {}
			self.CurrentNameTable = 1
			self.IgnoreChunks = false
			self.WaitPercent = 0
			self.WaitDelay = CurTime() + 2
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ATM_GROUPADMIN,ARCBANK_ATMBITRATE)
			net.WriteTable({false,false,self.ActiveAccount[ARCBANK_NAME],true})
			net.SendToServer()
			
		else
			self.NameTable = {}
			self.CurrentNameTable = 1
			self.IgnoreChunks = false
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ATM_GETGROUPS,ARCBANK_ATMBITRATE)
			if self.SearchingGroup then
				self.ScreenMsg = ARCBank.ATMMsgs.ChooseAccount
				net.WriteTable({true,LocalPlayer():SteamID(),false,self.UpgradingGroup})
			else
				self.ScreenMsg = ARCBank.ATMMsgs.ChoosePlayer
				net.WriteTable({false})
			end
			net.SendToServer()
			self.WaitPercent = 0
			self.WaitDelay = math.huge
		end
	end
	self.Phase = num
end
function ENT:ShowNotify(msg,err,time)
	self.ErrorLvl = err
	self.NotifyMsg = msg
	self.NotifyDelay = CurTime() + time
	if err > 0 then
		self:EmitSound("arcbank/atm/beep.wav")
		timer.Simple(1,function()self:EmitSound("arcbank/atm/beep.wav")end)
		timer.Simple(2,function()self:EmitSound("arcbank/atm/beep.wav")end)

		timer.Simple(0.1,function()arcbank_plysound("arcbank/atm/beep.wav",self:GetPos())end)
		timer.Simple(1.1,function()arcbank_plysound("arcbank/atm/beep.wav",self:GetPos())end)
		timer.Simple(2.1,function()arcbank_plysound("arcbank/atm/beep.wav",self:GetPos())end)
	end
	--self:EmitSound(ARCBANK_ERROR_VOICE[err])
end
function ENT:AskQuestion(msg)
	self.Yes = false
	self.Question = true
	self.QuestionMsg = msg
end
function ENT:PushNumber(num)
	--Gets all shitty at 2^14
	if !self.InputtingNumber then
		self:EmitSound("arcbank/atm/press.wav")
		return
	end
	self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
	arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
	if num == 11 then
		self.InputNum = math.floor(self.InputNum/10)
	else
		self.InputNum = (self.InputNum*10) + num
		if self.InputNum > 2^24 && !(self.Phase == 5 && !self.SearchingGroup && !(!self.sidinput || self.sidinput == "")) then
			self:ShowNotify(string.Replace( ARCBank.ATMMsgs.NumberTooHigh, "%NUM%", string.Comma(2^24)) ,15,3) 
			self.InputNum = math.floor(self.InputNum/10)
		elseif self.InputNum >= 100000000000000 then
		self:ShowNotify(string.Replace( ARCBank.ATMMsgs.NumberTooHigh, "%NUM%", string.Comma(100000000000000-1)),15,3)
			self.InputNum = math.floor(self.InputNum/10)
		end
	end
	if self.Phase == 5 && !self.SearchingGroup && !self.GivingMoney then
		if self.InputNum > 0 then
			self.sidinput = "STEAM_0:"..booltonumber(self.Yes)..":"..self.InputNum
			self.InputMsg = ARCBank.ATMMsgs.Entered.." "..self.sidinput
		else
			self.InputMsg = string.Replace( ARCBank.ATMMsgs.SIDPrompt, "%TEXT%", "STEAM_0:"..booltonumber(self.Yes)..":" ) 
		end
	end
end
function ENT:PushEnter()
	if self.Question then
		self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
		arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
		self.Yes = true
		self.Question = false
		if self.Phase == 5 then
			self.InputMsg = string.Replace( ARCBank.ATMMsgs.SIDPrompt, "%TEXT%", "STEAM_0:"..booltonumber(self.Yes)..":" ) 
		end
		if self.Phase == 1 then
			local accinfo = {}
			accinfo[ARCBANK_NAME] = ""
			accinfo[ARCBANK_RANK] = ARCBANK_PERSONALACCOUNTS_STANDARD
			accinfo[ARCBANK_UPGRADE] = false
			--timer.Simple(1,function()
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
			net.WriteTable(accinfo)
			net.SendToServer()
			--end)
			self.WaitDelay = math.huge
			self.WaitPercent = 0
		end
	elseif self.InputtingNumber then
		self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
		arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
		self.InputtingNumber = false
	else
		self:EmitSound("arcbank/atm/press.wav")
	end
end
function ENT:PushCancel()
	self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
	arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
	if self.Question then
		self.Yes = false
		self.Question = false
		if self.Phase == 5 then
			self.InputMsg = string.Replace( ARCBank.ATMMsgs.SIDPrompt, "%TEXT%", "STEAM_0:"..booltonumber(self.Yes)..":" ) 
		end
	elseif self.InputtingNumber then
		self.InputNum = 0
		self.InputtingNumber = false
		if self.Phase == 5 then
			self.sidinput = nil
	end
	elseif self.ViewingLogs then
		self.ViewingLogs = false
		self.LogTable = {}
	else
		self.GivingMoney = false
		if self.Phase > 2 && self.Phase < 5 then
			self:UpdatePhase(2)
		elseif self.Phase > 1 then
			self:UpdatePhase(1)
		else
			net.Start( "ARCATM_USE" )
			net.WriteEntity( self )
			net.SendToServer()
		end
	end
end
function ENT:PushScreen(butt)
	if self.Question then
		if butt == 8 then
			self:PushEnter()
		elseif butt == 4 then
			self:PushCancel()
		end
	elseif self.InputtingNumber then
		--lolé

		self:EmitSound("arcbank/atm/press.wav")
	elseif self.ViewingLogs then
		if butt == 8 && self.LogPage < self.MaxLogPage then
			self.LogPage = self.LogPage + 1
			self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
			arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
		elseif butt == 4 && self.LogPage > 0 then
			self.LogPage = self.LogPage - 1
			self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
			arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
		else
			self:EmitSound("arcbank/atm/press.wav")
		end
	else
		if self.Phase == 1 then
		--[[
		self.ScreenOptions[1] = "Personal Account\nInformation"
		self.ScreenOptions[2] = "Upgrade/Create\nPersonal Account"
		self.ScreenOptions[5] = "Group Account\nInformation"
		self.ScreenOptions[6] = "Upgrade/Create\nGroup Account"
		self.ScreenOptions[8] = "About this ATM"
		self.ScreenOptions[4] = "Exit"
		]]
		
			if butt == 1 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.GroupAccount = false
				self:UpdatePhase(2)
			elseif butt == 5 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.UpgradingGroup = false
				self.PlayerGroup = false
				self.SearchingGroup = true
				self.GroupAccount = true
				self:UpdatePhase(5)
			elseif butt == 4 then
				self:PushCancel()
			elseif butt == 2 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				--timer.Simple(1,function()
					local shit = {}
					shit[ARCBANK_UPGRADE] = true
					shit[ARCBANK_NAME] = ""
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( self )
					net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
					net.WriteTable(shit)
					net.SendToServer()
				--end)
				self.WaitDelay = math.huge
				self.WaitPercent = 0
			elseif butt == 6 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.PlayerGroup = false
				self.UpgradingGroup = true
				self.SearchingGroup = true
				self.GroupAccount = true
				self:UpdatePhase(5)
			elseif butt == 8 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				LocalPlayer().ARCBank_FullScreen = !LocalPlayer().ARCBank_FullScreen
				if LocalPlayer().ARCBank_FullScreen then
					gui.EnableScreenClicker(true) 
				else
					gui.EnableScreenClicker(false) 
				end
			else
				self:EmitSound("arcbank/atm/press.wav")
			end
			return
		elseif self.Phase == 2 then
			if butt == 1 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self:UpdatePhase(3)
				self.ScreenMsg = ARCBank.ATMMsgs.DepositAsk
			elseif butt == 2 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				local accinfo = {}
				if self.ActiveAccount[ARCBANK_RANK] < ARCBANK_GROUPACCOUNTS_ then
					accinfo[ARCBANK_NAME] = LocalPlayer():SteamID()
				else
					accinfo[ARCBANK_NAME] = self.ActiveAccount[ARCBANK_NAME]
				end
				accinfo[ARCBANK_RANK] = self.ActiveAccount[ARCBANK_RANK]
				self.LogTable = {}
				self.CurrentLogTable = 1
				self.IgnoreChunks = false
				--timer.Simple(1,function()
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( self )
					net.WriteInt(ARCBANK_ATM_LOG,ARCBANK_ATMBITRATE)
					net.WriteTable(accinfo)
					net.SendToServer()
				--end)
				self.WaitPercent = 0
				self.WaitDelay = math.huge
			elseif butt == 3 && self.ScreenOptions[butt] != "" then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.PlayerGroup = true
				self.AddPlayerToGroup = true
				self.UpgradingGroup = false
				self.SearchingGroup = false
				self.sidinput = nil
				self.giveplyname = nil
				self:UpdatePhase(5)
			elseif butt == 4 then
				self:PushCancel()
			elseif butt == 5 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.ScreenMsg = ARCBank.ATMMsgs.WithdrawalAsk
				self:UpdatePhase(4)
			elseif butt == 6 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.PlayerGroup = false
				self.UpgradingGroup = false
				self.SearchingGroup = false
				self.sidinput = nil
				self.giveplyname = nil
				self:UpdatePhase(5)
			elseif butt == 7 && self.ScreenOptions[butt] != "" then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				self.PlayerGroup = true
				self.AddPlayerToGroup = false
				self.UpgradingGroup = false
				self.SearchingGroup = false
				self.sidinput = nil
				self.giveplyname = nil
				self:UpdatePhase(5)
			elseif butt == 8 && self.ScreenOptions[butt] != "" then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				self:AskQuestion(ARCBank.ATMMsgs.CloseNotice)
			end
			return
		elseif self.Phase == 3 || self.Phase == 4 then
			self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
			arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
			if butt < 5 then
				self.InputNum = butt*20
			elseif butt == 5 then
				self.InputNum = 100
			elseif butt == 6 then
				self.InputNum = 200
			elseif butt == 7 then
				self.InputNum = 400
			elseif butt == 8 then
				self.InputtingNumber = true
			end
		elseif self.Phase == 5 then
			if self.ScreenOptions[butt] == "" then 
				self:EmitSound("arcbank/atm/press.wav")
				return 
			end
			
			if butt == 8 then
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				if self.NamePage < self.MaxNamePage then
					self.NamePage = self.NamePage + 1
				end
			elseif butt == 4 then
				if self.NamePage > 1 then
					self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
					arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
					self.NamePage = self.NamePage - 1
				else
					self:PushCancel()
					return
				end
			else 
				self:EmitSound("arcbank/atm/press"..math.random(1,3)..".wav")
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				if self.UpgradingGroup then
					if self.ScreenOptions[butt] == ARCBank.ATMMsgs.CreateGroupAccount then
						
						Derma_StringRequest("Enter Name", "Enter a name for your group", "", function(text)
							if #text > 18 then
								self:ShowNotify("Name's too long. It has to be less\nthan 19 letters long.",9,3)
							else
								local accinfo = {}
								accinfo[ARCBANK_NAME] = text
								accinfo[ARCBANK_RANK] = ARCBANK_GROUPACCOUNTS_STANDARD
								accinfo[ARCBANK_UPGRADE] = false
								self:EmitSound("arcbank/atm/beep_short.wav")
							--timer.Simple(1,function()
								net.Start( "ARCATM_COMM" )
								net.WriteEntity( self )
								net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
								net.WriteTable(accinfo)
								net.SendToServer()
							--end)
								self.WaitDelay = CurTime() + 2
								self.WaitPercent = 0
							end
						end)
					else
						local shit = {}
						shit[ARCBANK_UPGRADE] = true
						shit[ARCBANK_NAME] = self.ScreenOptions[butt]
						net.Start( "ARCATM_COMM" )
						net.WriteEntity( self )
						net.WriteInt(ARCBANK_ATM_CREATE,ARCBANK_ATMBITRATE)
						net.WriteTable(shit)
						net.SendToServer()
					end
				else
					if self.SearchingGroup then
						self.ActiveAccount = {}
						self.ActiveAccount[ARCBANK_NAME] = self.ScreenOptions[butt]
						self.WaitDelay = math.huge
						self.WaitPercent = 0
						self:UpdatePhase(2)
					else
						if !self.GivingMoney then
							--MsgN("hi!")
							self.NameTable = {}
							self.sidinput = string.Explode("\n", self.ScreenOptions[butt])[2]
							if !self.sidinput then
								--MsgN("Offline Player")
								self:AskQuestion(ARCBank.ATMMsgs.SIDAsk.."\n\n("..ARCBank.ATMMsgs.Yes.."  = STEAM_0:0:XXXX)\n("..ARCBank.ATMMsgs.No.." = STEAM_0:1:XXXX)")
								--atm:AskQuestion("Would you like to\ncreate one?")
								self.InputNum = 0
								self.InputtingNumber = true
							end
						else
							self.giveplyname = self.sidinput
							if self.ScreenOptions[butt] == ARCBank.ATMMsgs.PersonalAccount then
								self.sidinput = ""
							else
								self.sidinput = self.ScreenOptions[butt]
							end
							--MsgN("Account "..self.sidinput.." has Been selected!")
							self.InputMsg = ARCBank.ATMMsgs.AskMoney
							self.InputtingNumber = true
						end
					end
				end
				return
			end
			self.ScreenTitleMsg = "Search Page "..self.NamePage.."/"..self.MaxNamePage
			self.ScreenOptions[1] = self.NameTable[1+((self.NamePage-1)*6)]
			self.ScreenOptions[2] = self.NameTable[2+((self.NamePage-1)*6)]
			self.ScreenOptions[3] = self.NameTable[3+((self.NamePage-1)*6)]
			if self.NamePage == self.MaxNamePage then
				self.ScreenOptions[8] = ""
			else
				self.ScreenOptions[8] = ARCBank.ATMMsgs.More
			end
			self.ScreenOptions[5] = self.NameTable[4+((self.NamePage-1)*6)]
			self.ScreenOptions[6] = self.NameTable[5+((self.NamePage-1)*6)]
			self.ScreenOptions[7] = self.NameTable[6+((self.NamePage-1)*6)]
		end
	end
end
function ENT:PushDev(num)
				self:UpdatePhase(1)
				arcbank_plysound("arcbank/atm/beep_short.wav",self:GetPos())
				--MsgN("Info")
				local accinfo = {}
				accinfo[ARCBANK_NAME] = ""
				accinfo[ARCBANK_RANK] = 0
				self.LogTable = {}
				self.CurrentLogTable = 1
				self.IgnoreChunks = false
					net.Start( "ARCATM_COMM" )
					net.WriteEntity( self )
					net.WriteInt(ARCBANK_ATM_LOG,ARCBANK_ATMBITRATE)
					net.WriteTable(accinfo)
					net.SendToServer()
				self.WaitPercent = 0
				self.WaitDelay = math.huge
end
net.Receive( "ARCATM_USE", function(length)
	local atm = net.ReadEntity() 
	local using = tobool(net.ReadBit())
	atm.InUse = using
	LocalPlayer().ARCBank_UsingATM = using
	atm.WaitDelay = CurTime() + 6
	atm.WaitPercent = 0
	if using then
		atm:UpdatePhase(1)
		atm.ActiveAccount = nil
		atm.GroupAccounts = nil
		LocalPlayer().ARCBank_ATM = atm
		if LocalPlayer().ARCBank_FullScreen then
			gui.EnableScreenClicker( true ) 
		end
	else
		gui.EnableScreenClicker( false ) 
		LocalPlayer().ARCBank_ATM = NULL
		atm.ErrorLvl = 15
		atm.NotifyMsg = ARCBank.ATMMsgs.NetworkError
	end
end)
net.Receive( "ARCATM_COMM", function(length)
	local atm = net.ReadEntity() 
	if !atm.CommInit then atm.CommInit = true end
	local errorcode = net.ReadInt(ARCBANK_ERRORBITRATE)
	local operation = net.ReadInt(ARCBANK_ATMBITRATE)
	local args = net.ReadTable()
	if operation == ARCBANK_ATM_PING then
		if args[2] then
			atm.MoneyMsg = args[2]
			if atm.MoneyMsg == 0 then
				if LocalPlayer().ARCBank_FullScreen then
					gui.EnableScreenClicker( true ) 
				end
			else
				if LocalPlayer().ARCBank_FullScreen then
					gui.EnableScreenClicker( false ) 
				end
			end
		else
			atm.CommInit = args[1]
			if !args[1] then
				atm.ErrorLvl = 15
			end
		end
	elseif operation == ARCBANK_ATM_ACCOUNTINFO then
		if errorcode == 0 then
			atm.ActiveAccount = args
			atm.ScreenTitleMsg = args[ARCBANK_NAME]
			atm.AppIcon = icons_rank[args[ARCBANK_RANK]]
			atm.ScreenMsg = ARCBank.ATMMsgs.Balance.."\n"..args[ARCBANK_BALANCE]..""
			atm.WaitDelay = CurTime() + math.random()
			atm.WaitPercent = 0
			if args[ARCBANK_GROUP_OWNER] && args[ARCBANK_GROUP_OWNER] == LocalPlayer():SteamID() then
				atm.ScreenOptions[3] = ARCBank.ATMMsgs.AddPlayerGroup
				atm.ScreenOptions[7] = ARCBank.ATMMsgs.RemovePlayerGroup
				atm.ScreenOptions[8] = ARCBank.ATMMsgs.CloseAccount
			end
		else
			atm:UpdatePhase(1)
			atm.WaitDelay = CurTime() + 0.1
			atm.WaitPercent = 0
			atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,5)
		end
	elseif operation == ARCBANK_ATM_CASH then
		atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
		atm.WaitDelay = CurTime() + 0.1
		atm.WaitPercent = 0
		atm:UpdatePhase(2)
	elseif operation == ARCBANK_ATM_TRANSFER then
		atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
		atm.WaitDelay = CurTime() + 0.1
		atm.WaitPercent = 0
		atm:UpdatePhase(2)
	elseif operation == ARCBANK_ATM_CREATE then
		atm.WaitDelay = CurTime() + 0.1
		atm.WaitPercent = 0
		if errorcode == 0 then
			atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
			atm.GroupAccount = false
			--[[
			self.WaitDelay = math.huge
			self.WaitPercent = 0
			timer.Simple(1,function()
			net.Start( "ARCATM_COMM" )
			net.WriteEntity( self )
			net.WriteInt(ARCBANK_ATM_ACCOUNTINFO,ARCBANK_ATMBITRATE)
			net.WriteTable({})
			net.SendToServer()
			end)
			]]
			atm:UpdatePhase(1)
		elseif errorcode == ARCBANK_ERROR_NIL_ACCOUNT then
			atm:AskQuestion(ARCBank.ATMMsgs.OpenAccount)
			atm:UpdatePhase(1)
		else
			atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
			atm:UpdatePhase(1)
		end
	elseif operation == ARCBANK_ATM_GROUPADMIN then
		atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
		atm.WaitDelay = CurTime() + 0.1
		atm.WaitPercent = 0
		atm:UpdatePhase(2)
	elseif operation == ARCBANK_ATM_GETGROUPS then
	
	----------------------------------------------------- self.NameTable = {}
		if atm.IgnoreChunks then return end
		if errorcode != 0 then
			atm.WaitDelay = CurTime() + 1
			atm.IgnoreChunks = true
			atm:ShowNotify(tostring(ARCBANK_ERRORSTRINGS[errorcode]),errorcode,3)
			atm:UpdatePhase(1)
		return end
		atm.NameTable[args[ARCBANK_CHUNK]] = args[1]
		atm.WaitDelay = math.huge
		atm.WaitPercent = atm.CurrentNameTable/args[ARCBANK_CHUNK_TOTAL]
		--MsgN("Got Chunk "..args[ARCBANK_CHUNK].."/"..args[ARCBANK_CHUNK_TOTAL])
		if atm.CurrentNameTable == args[ARCBANK_CHUNK_TOTAL] && args[ARCBANK_CHUNK] == args[ARCBANK_CHUNK_TOTAL] then
			timer.Simple(0.25,function() atm:ShowNotify("Search Completed.",ARCBANK_ERROR_NONE,1) end)
			--if atm.GivingMoney then
				--table.insert( atm.NameTable, 1, "Personal Account" )
			--end
			atm.WaitDelay = CurTime() + 1
			atm.MaxNamePage = math.ceil(table.maxn(atm.NameTable)/6)
			atm.NamePage = 1
			
			atm.ScreenTitleMsg = "Search Page 1/"..atm.MaxNamePage
			atm.ScreenOptions[1] = atm.NameTable[1]	or ""
			atm.ScreenOptions[2] = atm.NameTable[2] or ""
			atm.ScreenOptions[3] = atm.NameTable[3]	or ""
			atm.ScreenOptions[4] = ARCBank.ATMMsgs.Back
			atm.ScreenOptions[5] = atm.NameTable[4]	or ""
			atm.ScreenOptions[6] = atm.NameTable[5]	or ""
			atm.ScreenOptions[7] = atm.NameTable[6]	or ""
			atm.ScreenOptions[8] = ARCBank.ATMMsgs.More
		elseif atm.CurrentNameTable != args[ARCBANK_CHUNK] then
			atm.WaitDelay = CurTime() + .5
			atm.IgnoreChunks = true
			atm:ShowNotify("Error Downloading.\nChunk Mismatch ("..tostring(atm.CurrentNameTable).."=/="..tostring(args[ARCBANK_CHUNK])..")",ARCBANK_ERROR_UNKNOWN,3)
			atm:UpdatePhase(1)
		end
		atm.CurrentNameTable = atm.CurrentNameTable + 1
		
		-------------------------------------------------------------
	elseif operation == ARCBANK_ATM_LOG then
		if atm.IgnoreChunks then return end
		atm.LogTable[args[ARCBANK_CHUNK]] = args[1]
		atm.WaitDelay = math.huge
		atm.WaitPercent = atm.CurrentLogTable/args[ARCBANK_CHUNK_TOTAL]
		--MsgN("Got Chunk "..args[ARCBANK_CHUNK].."/"..args[ARCBANK_CHUNK_TOTAL])
		if atm.CurrentLogTable == args[ARCBANK_CHUNK_TOTAL] && args[ARCBANK_CHUNK] == args[ARCBANK_CHUNK_TOTAL] then
			timer.Simple(0.25,function() atm:ShowNotify("File Downloaded!",ARCBANK_ERROR_NONE,1) end)
			
			local i = table.maxn(atm.LogTable)
			while i > 1 do
				if string.len(atm.LogTable[i]) > 53 then
					local strings = arc_fitstring(atm.LogTable[i],53)
					local strn = table.maxn(strings)
					local ii = strn
					table.remove( atm.LogTable, i )
					while ii > 0 do
						--MsgN(strings[ii])
						table.insert( atm.LogTable, i, strings[ii] )
						ii = ii - 1
					end
				end
				i = i - 1
			end
			atm.WaitDelay = CurTime() + .5
			atm.MaxLogPage = math.floor(table.maxn(atm.LogTable)/27)
			atm.LogPage = atm.MaxLogPage
			atm.ViewingLogs = true
		elseif atm.CurrentLogTable != args[ARCBANK_CHUNK] then
			atm.WaitDelay = CurTime() + 1
			atm.IgnoreChunks = true
			atm:ShowNotify("Error Downloading Log.\nChunk Mismatch ("..tostring(atm.CurrentNameTable).."=/="..tostring(args[ARCBANK_CHUNK])..")",ARCBANK_ERROR_UNKNOWN,3)
		end
		atm.CurrentLogTable = atm.CurrentLogTable + 1
	end
	--MsgN("ATM: "..operation)
end)
--ViewingLogs