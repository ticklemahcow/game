include('shared.lua')
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ScreenMsg = {}
function ENT:Initialize()
	self.SScreenScroll = 1
	self.SScreenScrollDelay = CurTime() + 0.1
	self.ScreenScroll = 1
	self.ScreenScrollDelay = CurTime() + 0.1
	self.TopScreenText = "**ARCBank**"
	self.BottomScreenText = ARCBank.CardMsgs.NoOwner
	net.Start( "ARCCHIPMACHINE_STRINGS" )
	net.WriteEntity(self.Entity)
	net.SendToServer()
	self.FromAccount = ARCBank.ATMMsgs.PersonalAccount
	self.ToAccount = ARCBank.ATMMsgs.PersonalAccount
	self.InputNum = 0
	self.Reason = "Card Machine"
end

function ENT:Think()

end


function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
	self.DisplayPos = self:GetPos() + ((self:GetAngles():Up() * 1.005) + (self:GetAngles():Forward() * -4.01) + (self:GetAngles():Right()*2.55))
	self.displayangle1 = self:GetAngles()
	self.displayangle1:RotateAroundAxis( self.displayangle1:Up(), 90 )
	--self.displayangle1:RotateAroundAxis( self.displayangle1:Forward(), -13 )
	if self.ScreenScrollDelay < CurTime() && string.len(self.BottomScreenText) > 11 then
		self.ScreenScrollDelay = CurTime() + 0.1
		self.ScreenScroll = self.ScreenScroll + 1
		if (self.ScreenScroll) > string.len("             "..self.BottomScreenText.."             ") then
			self.ScreenScroll = 1
		end
	end
	if self.SScreenScrollDelay < CurTime() && string.len(self.TopScreenText) > 11 then
		self.SScreenScrollDelay = CurTime() + 0.1
		self.SScreenScroll = self.SScreenScroll + 1
		if (self.SScreenScroll) > string.len("             "..self.TopScreenText.."             ") then
			self.SScreenScroll = 1
		end
	end
	cam.Start3D2D(self.DisplayPos, self.displayangle1, 0.055)
			surface.SetDrawColor( 0, 255, 0, 200 )
			surface.DrawRect( 0, 0, 77, 24 ) 
			if string.len(self.TopScreenText) > 11 then
				draw.SimpleText( string.Right(string.Left( "             "..self.TopScreenText.."             ", self.SScreenScroll ),11), "ARCBankATM",0,0, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			else
				draw.SimpleText( self.TopScreenText, "ARCBankATM",0,0, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			end
			if string.len(self.BottomScreenText) > 11 then
				draw.SimpleText( string.Right(string.Left( "             "..self.BottomScreenText.."             ", self.ScreenScroll ),11), "ARCBankATM",0,12, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			else
				draw.SimpleText( self.BottomScreenText, "ARCBankATM",0,12, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			end
	cam.End3D2D()
end
--lollolol
net.Receive( "ARCCHIPMACHINE_STRINGS", function(length)
	local ent = net.ReadEntity()
	local topstring = net.ReadString()
	local bottomstring = net.ReadString()
	ent.TopScreenText = topstring
	ent.BottomScreenText = bottomstring
	ent.ScreenScroll = 11
	ent.SScreenScroll = 11
end)
net.Receive( "ARCCHIPMACHINE_MENU_CUSTOMER", function(length)
	local ent = net.ReadEntity()
	local accounts = net.ReadTable()
	if ent.FromAccount == "" then
		ent.FromAccount = ARCBank.ATMMsgs.PersonalAccount
	end
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( surface.ScreenWidth()/2-130,surface.ScreenHeight()/2-100 )
	DermaPanel:SetSize( 260, 104 )
	DermaPanel:SetTitle( "Remote funds transfering device." )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	local NumLabel2 = vgui.Create( "DLabel", DermaPanel )
	NumLabel2:SetPos( 10, 26 )
	NumLabel2:SetText( ARCBank.CardMsgs.AccountPay )
	NumLabel2:SizeToContents()
	local AccountSelect = vgui.Create( "DComboBox", DermaPanel )
	AccountSelect:SetPos( 10,44 )
	AccountSelect:SetSize( 240, 20 )
	function AccountSelect:OnSelect(index,value,data)
		ent:EmitSound("buttons/button18.wav",75,255)
		ent.FromAccount = value
	end--$é
	AccountSelect:SetText(ent.FromAccount)
	for i=1,#accounts do
		AccountSelect:AddChoice(accounts[i])
	end
	local OkButton = vgui.Create( "DButton", DermaPanel )
	OkButton:SetText( "OK" )
	OkButton:SetPos( 10, 74 )
	OkButton:SetSize( 115, 20 )
	OkButton.DoClick = function()
		ent:EmitSound("buttons/button18.wav",75,255)
		DermaPanel:Remove()
		if ent.FromAccount == ARCBank.ATMMsgs.PersonalAccount then
			ent.FromAccount = ""
		end
		MsgN("Selected account: "..ent.FromAccount)
		net.Start( "ARCCHIPMACHINE_MENU_CUSTOMER" )
		net.WriteEntity(ent)
		net.WriteString(ent.FromAccount)
		net.SendToServer()
	end
	local CancelButton = vgui.Create( "DButton", DermaPanel )
	CancelButton:SetText( "Cancel" )
	CancelButton:SetPos( 135, 74 )
	CancelButton:SetSize( 115, 20 )
	CancelButton.DoClick = function()
		DermaPanel:Remove()
	end
end)
net.Receive( "ARCCHIPMACHINE_MENU_OWNER", function(length)
	local ent = net.ReadEntity()
	local accounts = net.ReadTable()
	if ent.ToAccount == "" then
		ent.ToAccount = ARCBank.ATMMsgs.PersonalAccount
	end
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( surface.ScreenWidth()/2-130,surface.ScreenHeight()/2-120 )
	DermaPanel:SetSize( 260, 240 )
	DermaPanel:SetTitle( "Remote funds transfering device." )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	local NumLabel1 = vgui.Create( "DLabel", DermaPanel )
	NumLabel1:SetPos( 10, 25 )
	NumLabel1:SetText( "How much do you want to charge?" )
	NumLabel1:SizeToContents()
	local EnterLabel = vgui.Create( "DLabel", DermaPanel )
	EnterLabel:SetPos( 76, 42 )
	EnterLabel:SetText( ">: "..tostring(ent.InputNum) )
	EnterLabel:SizeToContents()
	local ErrorLabel = vgui.Create( "DLabel", DermaPanel )
	ErrorLabel:SetPos( 76, 54 )
	ErrorLabel:SetText( "" )
	ErrorLabel:SizeToContents()
	local button = {}
	for i=1,12 do
		button[i] = vgui.Create( "DButton", DermaPanel )
		if i == 10 then
			button[i]:SetText( "<--" )
			button[i].DoClick = function()
				ent:EmitSound("buttons/button18.wav",75,255)
				ent.InputNum = math.floor(ent.InputNum/10)
				EnterLabel:SetText( ">: "..tostring(ent.InputNum) )
				EnterLabel:SizeToContents()
			end
		elseif i == 11 then
			button[i]:SetText( "0" )
			button[i].DoClick = function()
				ent:EmitSound("buttons/button18.wav",75,255)
				if (ent.InputNum*10) > 2^24 then
					ErrorLabel:SetText( string.Replace( ARCBank.ATMMsgs.NumberTooHigh, "%NUM%", string.Comma(2^24)) )
					ErrorLabel:SizeToContents()
					return
				end
				ent.InputNum = (ent.InputNum*10)
				EnterLabel:SetText( ">: "..tostring(ent.InputNum) )
				EnterLabel:SizeToContents()
			end
		elseif i== 12 then
			button[i]:SetText( "X" )
			button[i].DoClick = function()
				ent:EmitSound("buttons/button18.wav",75,255)
				ent.InputNum = 0
				EnterLabel:SetText( ">: "..tostring(ent.InputNum) )
				EnterLabel:SizeToContents()
			end
		else
			button[i]:SetText( tostring(i) )
			button[i].DoClick = function()
				ent:EmitSound("buttons/button18.wav",75,255)
				if ((ent.InputNum*10) + i) > 2^24 then
					ErrorLabel:SetText( string.Replace( ARCBank.ATMMsgs.NumberTooHigh, "%NUM%", string.Comma(2^24)) )
					ErrorLabel:SizeToContents()
					return
				end
				ent.InputNum = (ent.InputNum*10) + i
				EnterLabel:SetText( ">: "..tostring(ent.InputNum) )
				EnterLabel:SizeToContents()
			end
		end
		button[i]:SetSize( 20, 20 )
		button[i]:SetPos( 10+(20*((i-1)%3)), 40+(20*math.floor((i-1)/3)) )
	end
	local NumLabel2 = vgui.Create( "DLabel", DermaPanel )
	NumLabel2:SetPos( 10, 122 )
	NumLabel2:SetText( ARCBank.CardMsgs.Account )
	NumLabel2:SizeToContents()
	local AccountSelect = vgui.Create( "DComboBox", DermaPanel )
	AccountSelect:SetPos( 10,140 )
	AccountSelect:SetSize( 240, 20 )
	function AccountSelect:OnSelect(index,value,data)
		ent:EmitSound("buttons/button18.wav",75,255)
		ent.ToAccount = value
	end
	AccountSelect:SetText(ent.ToAccount)
	for i=1,#accounts do
		AccountSelect:AddChoice(accounts[i])
	end
	local NumLabel3 = vgui.Create( "DLabel", DermaPanel )
	NumLabel3:SetPos( 10, 162 )
	NumLabel3:SetText( ARCBank.CardMsgs.Label )
	NumLabel3:SizeToContents()
	local ReasonSelect = vgui.Create( "DTextEntry", DermaPanel )
	ReasonSelect:SetPos( 10,180 )
	ReasonSelect:SetTall( 20 )
	ReasonSelect:SetWide( 240 )
	ReasonSelect:SetEnterAllowed( true )
	ReasonSelect:SetValue(ent.Reason)
	local OkButton = vgui.Create( "DButton", DermaPanel )
	OkButton:SetText( "OK" )
	OkButton:SetPos( 10, 210 )
	OkButton:SetSize( 115, 20 )
	OkButton.DoClick = function()
		ent:EmitSound("buttons/button18.wav",75,255)
		DermaPanel:Remove()
		if ent.ToAccount == ARCBank.ATMMsgs.PersonalAccount then
			ent.ToAccount = ""
		end
		net.Start( "ARCCHIPMACHINE_MENU_OWNER" )
		net.WriteEntity(ent)
		net.WriteString(ent.ToAccount)
		net.WriteInt(ent.InputNum,32)
		net.WriteString(ent.Reason)
		net.SendToServer()
	end
	local CancelButton = vgui.Create( "DButton", DermaPanel )
	CancelButton:SetText( "Cancel" )
	CancelButton:SetPos( 135, 210 )
	CancelButton:SetSize( 115, 20 )
	CancelButton.DoClick = function()
		DermaPanel:Remove()
	end
end)