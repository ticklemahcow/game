--GUI for ARitz Cracker Bank (Clientside)
if ARCBank then
	local ARCBankGUI = ARCBankGUI or {}
	ARCBankGUI.SelectedAccountRank = 0
	ARCBankGUI.SelectedAccount = ""
	ARCBankGUI.Log = ""
	ARCBankGUI.LogDownloaded = false
	ARCBankGUI.AccountListTab = {}
	function ARCBankGUI:Open(settings,descriptions,logs)
		ARCBankGUI.DermaPanel = vgui.Create( "DFrame" )
		ARCBankGUI.DermaPanel:SetPos( 50, 50 )
		ARCBankGUI.DermaPanel:SetSize( 310, 373 )
		ARCBankGUI.DermaPanel:SetTitle( "ARitz Cracker Bank - Admin menu" )
		ARCBankGUI.DermaPanel:SetVisible( true )
		ARCBankGUI.DermaPanel:SetDraggable( true )
		ARCBankGUI.DermaPanel:ShowCloseButton( true )
		ARCBankGUI.DermaPanel:MakePopup()
 
		local PropertySheet = vgui.Create( "DPropertySheet", ARCBankGUI.DermaPanel )
		PropertySheet:SetPos( 5, 30 )
		PropertySheet:SetSize( 300, 278 )
	
		local SettingsContainer = vgui.Create( "DPanel")
		local AList1= vgui.Create( "DComboBox",SettingsContainer)
		AList1:SetPos(10,10)
		AList1:SetSize( 265, 20 )
		AList1:SetText( "Choose a setting:" )
		for k,v in SortedPairs(settings) do
			AList1:AddChoice(k)
		end
	
		local SettingSave = vgui.Create( "DButton", SettingsContainer )
		SettingSave:SetText( "Save settings" )
		SettingSave:SetPos( 10, 152 )
		SettingSave:SetSize( 265, 20 )
		SettingSave.DoClick = function()
			RunConsoleCommand( "arcbank","settings_save")
		end
		local AtmSave = vgui.Create( "DButton", SettingsContainer )
		AtmSave:SetText( "Save all active ATMs onto map" )
		AtmSave:SetPos( 10, 182 )
		AtmSave:SetSize( 265, 20 )
		AtmSave.DoClick = function()
			RunConsoleCommand( "arcbank","atm_save")
		end
		local AtmRespawn = vgui.Create( "DButton", SettingsContainer )
		AtmRespawn:SetText( "Respawn map-based ATMs" )
		AtmRespawn:SetPos( 10, 212 )
		AtmRespawn:SetSize( 265, 20 )
		AtmRespawn.DoClick = function()
			RunConsoleCommand( "arcbank","atm_respawn")
		end
		local SettingDesc = vgui.Create( "DLabel", SettingsContainer )
		SettingDesc:SetPos( 12, 35 ) -- Set the position of the label
		SettingDesc:SetText( "Choose a setting" ) --  Set the text of the label
		SettingDesc:SetWrap(true)
		SettingDesc:SetSize( 265, 50 )
--		SettingDesc:SizeToContents() -- Size the label to fit the text in it
		SettingDesc:SetDark( 1 ) -- Set the colour of the text inside the label to a darker one
		local SettingBool = vgui.Create( "DCheckBoxLabel", SettingsContainer )
		SettingBool:SetPos( 12, 92 )
		SettingBool:SetText( "Enable" )
		SettingBool:SetValue( 1 )
		SettingBool:SizeToContents()
		SettingBool:SetVisible(false)
		SettingBool:SetDark( 1 )
		local SettingNum = vgui.Create( "DNumberWang", SettingsContainer )
		SettingNum:SetPos( 10, 92 )
		SettingNum:SetSize( 265, 20 )
		SettingNum:SetValue( 1 )
		SettingNum:SetVisible(false)
		SettingNum:SetMinMax( 0 , 1000000 )
		SettingNum:SetDecimals(4)
		local SettingStr = vgui.Create( "DTextEntry", SettingsContainer )
		SettingStr:SetPos( 12,92 )
		SettingStr:SetTall( 20 )
		SettingStr:SetWide( 265 )
		SettingStr:SetVisible(false)
		SettingStr:SetEnterAllowed( true )
		local SettingsTabContainer = vgui.Create( "DPanel",SettingsContainer)
		SettingsTabContainer:SetPos(10,92)
		SettingsTabContainer:SetSize( 265, 50 )
		SettingsTabContainer:SetVisible(false)
		local SettingTab = vgui.Create( "DComboBox", SettingsTabContainer )
		SettingTab:SetPos( 0,0 )
		SettingTab:SetSize( 210, 20 )
		function SettingTab:OnSelect(index,value,data)
			SettingTab.Selection = value
		end
		local SettingTaba = vgui.Create( "DTextEntry", SettingsTabContainer )
		SettingTaba:SetPos( 0,30 )
		SettingTaba:SetTall( 20 )
		SettingTaba:SetWide( 210 )
		--SettingTaba:SetVisible(false)
		SettingTaba:SetEnterAllowed( true )
	
		local SettingRemove = vgui.Create( "DButton", SettingsTabContainer )
		SettingRemove:SetText( "Remove" )
		SettingRemove:SetPos( 210, 0 )
		SettingRemove:SetSize( 55, 20 )
		local SettingAdd = vgui.Create( "DButton", SettingsTabContainer )
		SettingAdd:SetText( "Add" )
		SettingAdd:SetPos( 210, 30)
		SettingAdd:SetSize( 55, 20 )
	
		function AList1:OnSelect(index,value,data)
			SettingDesc:SetText("Description:\n"..tostring(descriptions[value]));
			--SettingDesc:SizeToContents();
				SettingBool.OnChange = function( pan, val ) end
				SettingStr.OnValueChanged = function( pan, val ) end
				SettingStr.OnEnter = function() end
				SettingNum.OnValueChanged = function( pan, val ) end
			if isnumber(settings[value]) then
				SettingBool:SetVisible(false)
				SettingNum:SetVisible(true)
				SettingStr:SetVisible(false)
				SettingsTabContainer:SetVisible(false)
				SettingNum:SetValue( settings[value] )
				SettingNum.OnValueChanged = function( pan, val )
					RunConsoleCommand( "arcbank","settings",value,tostring(val))
				end
			elseif istable(settings[value]) then
				SettingNum:SetVisible(false)
				SettingBool:SetVisible(false)
				SettingStr:SetVisible(false)
				SettingsTabContainer:SetVisible(true)
				SettingTab:Clear()
				SettingTab.Selection = ""
				for k,v in pairs(settings[value]) do
					SettingTab:AddChoice(v)
				end
				SettingAdd.DoClick = function()
					
					table.insert( settings[value], SettingTaba:GetValue() )
					string.Replace(SettingTaba:GetValue(), ",", "_")
					local s = ""
					for o,p in pairs(settings[value]) do
						if o > 1 then
							s = s..","..p
						else
							s = p
						end
					end
					RunConsoleCommand( "arcbank","settings",value,s)
					SettingTab:AddChoice(SettingTaba:GetValue())
					SettingTaba:SetValue("")
				end	
				SettingRemove.DoClick = function()
					table.RemoveByValue( settings[value], SettingTab.Selection )
					local s = ""
					for o,p in pairs(settings[value]) do
						if o > 1 then
							s = s..","..p
						else
							s = p
						end
					end
					SettingTab:Clear()
					for k,v in pairs(settings[value]) do
						SettingTab:AddChoice(v)
					end
					RunConsoleCommand( "arcbank","settings",value,s)
				end
			elseif isstring(settings[value]) then
				SettingNum:SetVisible(false)
				SettingBool:SetVisible(false)
				SettingStr:SetVisible(true)
				SettingsTabContainer:SetVisible(false)
				SettingStr:SetValue( settings[value] )
				SettingStr.OnValueChanged = function( pan, val )
					SettingStr:SetValue(tostring(val))
					RunConsoleCommand( "arcbank","settings",value,tostring(val))
				end
				SettingStr.OnEnter = function()
					SettingStr:SetValue(SettingStr:GetValue())
					RunConsoleCommand( "arcbank","settings",value,SettingStr:GetValue())
				end
			elseif isbool(settings[value]) then
				SettingNum:SetVisible(false)
				SettingBool:SetVisible(true)
				SettingStr:SetVisible(false)
				SettingsTabContainer:SetVisible(false)
				SettingBool:SetValue( booltonumber(settings[value]) )
				SettingBool.OnChange = function( pan, val )
					RunConsoleCommand( "arcbank","settings",value,tostring(val))
				end
			end
		end
		
		local LogContainer = vgui.Create( "DPanel")
		local DummyLogList= vgui.Create( "DComboBox",LogContainer)
		DummyLogList:SetPos(10,10)
		DummyLogList:SetSize( 265, 20 )
		DummyLogList:SetText( "Loading..." )
		
		
		ARCBankGUI.LogList= vgui.Create( "DComboBox",LogContainer)
		ARCBankGUI.LogList:SetPos(10,10)
		ARCBankGUI.LogList:SetSize( 265, 20 )
		ARCBankGUI.LogList:SetText( "Choose a log:" )
		for k,v in SortedPairs(logs) do
			ARCBankGUI.LogList:AddChoice(v)
		end
		function ARCBankGUI.LogList:OnSelect(index,value,data)
			ARCBankGUI.Ignore = false
			ARCBankGUI.CurrentChunk = 1
			ARCBankGUI.LogDownloaded = false
			ARCBankGUI.LogList:SetVisible(false)
			ARCBankGUI.Log = ""
			DummyLogList:SetText(value)
			net.Start( "ARCBank_Admin_Send" )
			net.WriteInt(0,ARCBANK_ACCOUNTBITRATE)
			net.WriteString(tostring(value))
			net.SendToServer()
			ARCBankGUI.LogOpen:SetText("Loading... (0%)")
		end
		ARCBankGUI.LogProgress = vgui.Create( "DProgress",ARCBankGUI.DermaPanel )
		ARCBankGUI.LogProgress:SetPos( 5, 312 )
		ARCBankGUI.LogProgress:SetSize( 300, 25 )
		ARCBankGUI.LogProgress:SetFraction( 1 )
		
		ARCBankGUI.LogOpen = vgui.Create( "DButton", ARCBankGUI.DermaPanel )
		ARCBankGUI.LogOpen:SetText( "" )
		ARCBankGUI.LogOpen:SetPos( 5, 342 )
		ARCBankGUI.LogOpen:SetSize( 300, 25 )
		ARCBankGUI.LogOpen.DoClick = function()
			if !ARCBankGUI.LogDownloaded then return end
			--RunConsoleCommand( "arcbank","atm_save")
			local DermaPanel = vgui.Create( "DFrame" )
			DermaPanel:SetSize( 600,550 )
			DermaPanel:Center()
			DermaPanel:SetTitle( "Text File" )
			DermaPanel:MakePopup()
			
			
			Text = vgui.Create("DTextEntry", DermaPanel) // The info text.
			Text:SetPos( 5, 30 ) -- Set the position of the label
			Text:SetSize( 590, 515 )
			Text:SetText( ARCBankGUI.Log ) --  Set the text of the label
			Text:SetMultiline(true)
			Text:SetEnterAllowed(false)
			Text:SetVerticalScrollbarEnabled(true)
		end
		
		local AccountsContainer = vgui.Create( "DPanel")

		RankList= vgui.Create( "DComboBox",AccountsContainer)
		RankList:SetPos(10,10)
		RankList:SetSize( 265, 20 )
		RankList:SetText( "Choose a rank" )
		RankList:AddChoice("Personal - Basic")
		RankList:AddChoice("Personal - Bronze")
		RankList:AddChoice("Personal - Silver")
		RankList:AddChoice("Personal - Gold")
		RankList:AddChoice("Group - Standard")
		RankList:AddChoice("Group - Premium")
		local accountinfomation = vgui.Create( "DLabel", AccountsContainer )
		accountinfomation:SetPos( 12, 100 ) -- Set the position of the label
		accountinfomation:SetText("")
		accountinfomation:SizeToContents() -- Size the label to fit the text in it
		accountinfomation:SetDark( 1 ) -- Set the colour of the text inside the label to a darker one
		function RankList:OnSelect(index,value,data)
			if index > 4 then 
				index = index + 1
			end
			ARCBankGUI.AccountListDummy:SetText( "No Accounts!" )
			ARCBankGUI.AccountList:SetVisible(false)
			ARCBankGUI.AccountList:Clear()
			ARCBankGUI.AccountListTab = {}
			ARCBankGUI.CurrentChunk = 1
			ARCBankGUI.Ignore = false
			MsgN("Rank "..tostring(index))
			net.Start( "ARCBank_Admin_SendAccounts" )
			net.WriteInt(index,ARCBANK_ACCOUNTBITRATE)
			net.SendToServer()
			accountinfomation:SetText("")
			ARCBankGUI.SelectedAccountRank = index
		end
		ARCBankGUI.AccountListDummy = vgui.Create( "DComboBox",AccountsContainer)
		ARCBankGUI.AccountListDummy:SetPos(10,40)
		ARCBankGUI.AccountListDummy:SetSize( 265, 20 )
		ARCBankGUI.AccountListDummy:SetText( "No Accounts!" )
		ARCBankGUI.AccountList= vgui.Create( "DComboBox",AccountsContainer)
		ARCBankGUI.AccountList:SetPos(10,40)
		ARCBankGUI.AccountList:SetSize( 265, 20 )
		ARCBankGUI.AccountList:SetText( "" )
		function ARCBankGUI.AccountList:OnSelect(index,value,data)
			ARCBankGUI.Ignore = false
			ARCBankGUI.CurrentChunk = 1
			ARCBankGUI.LogDownloaded = false
			ARCBankGUI.LogList:SetVisible(false)
			ARCBankGUI.Log = ""
			ARCBankGUI.LogOpen:SetText("Loading... (0%)")
			ARCBankGUI.SelectedAccount = ARCBankGUI.AccountListTab[index][ARCBANK_ID]
			accountinfomation:SetText("Filename: "..tostring(ARCBankGUI.AccountListTab[index][ARCBANK_ID]).."\nName: "..tostring(ARCBankGUI.AccountListTab[index][ARCBANK_NAME]).."\nBalance: "..tostring(ARCBankGUI.AccountListTab[index][ARCBANK_BALANCE]))
			accountinfomation:SizeToContents() -- Size the label to fit the text in it
			net.Start( "ARCBank_Admin_Send" )
			net.WriteInt(ARCBankGUI.SelectedAccountRank,ARCBANK_ACCOUNTBITRATE)
			net.WriteString(tostring(ARCBankGUI.AccountListTab[index][ARCBANK_ID]))
			net.SendToServer()
		end
		ARCBankGUI.AccountProgress = vgui.Create( "DProgress",AccountsContainer )
		ARCBankGUI.AccountProgress:SetPos( 10, 70 )
		ARCBankGUI.AccountProgress:SetSize( 265, 20 )
		ARCBankGUI.AccountProgress:SetFraction( 1 )
		
		local AccountAddMoney = vgui.Create( "DNumberWang", AccountsContainer )
		AccountAddMoney:SetPos( 10, 150 )
		AccountAddMoney:SetSize( 160, 20 )
		AccountAddMoney:SetValue( 0 )
		AccountAddMoney:SetMinMax( -1000000 , 1000000 )
		AccountAddMoney:SetDecimals(0)
		
		GiveTakeMoney = vgui.Create( "DButton", AccountsContainer )
		GiveTakeMoney:SetText( "Give/Take Money" )
		GiveTakeMoney:SetPos( 180, 150 )
		GiveTakeMoney:SetSize( 95, 20 )
		GiveTakeMoney.DoClick = function()
			RunConsoleCommand("arcbank","give_money",tostring(ARCBankGUI.SelectedAccountRank),tostring(ARCBankGUI.SelectedAccount),tostring(AccountAddMoney:GetValue()))
		end
		PropertySheet:AddSheet( "Server Log", LogContainer, "icon16/page_gear.png", false, false, "View the server log" )
		PropertySheet:AddSheet( "User Accounts", AccountsContainer, "icon16/folder_user.png", false, false, "Manage user accounts" )
		PropertySheet:AddSheet( "System Settings", SettingsContainer, "icon16/cog.png", false, false, "Change system settings" )
	end
	net.Receive( "ARCBank_Admin_SendAccounts", function(length)
		if ARCBankGUI.Ignore then return end
		MsgN("HI!")
		local chunk = net.ReadString()
		local total = net.ReadString()
		local tab = net.ReadTable()
		if ARCBankGUI.CurrentChunk != tonumber(chunk) then 
			ARCBankGUI.AccountList:SetText("Error. Got table #"..tostring(chunk).." while expecting for table #"..tostring(ARCBankGUI.CurrentChunk))
			ARCBankGUI.AccountList:SetVisible(true)
			ARCBankGUI.Ignore = true
			return
		end
		ARCBankGUI.AccountList:AddChoice(tab[ARCBANK_NAME])
		table.insert(ARCBankGUI.AccountListTab,tab)
		
		
		
		--ARCBankGUI.Log = ARCBankGUI.Log.."\n"..line
		ARCBankGUI.AccountProgress:SetFraction( tonumber(chunk)/tonumber(total) )
		ARCBankGUI.AccountListDummy:SetText("Loading... ("..tostring(math.Round((tonumber(chunk)/tonumber(total))*100)).."%)")
		if (tonumber(chunk)/tonumber(total)) == 1 then
			--ARCBankGUI.LogOpen:SetText("Open selected log")
			--ARCBankGUI.LogDownloaded = true
			ARCBankGUI.AccountList:SetVisible(true)
			ARCBankGUI.AccountList:SetText("Select an account:")
		end
		ARCBankGUI.CurrentChunk = ARCBankGUI.CurrentChunk + 1
	end)
	net.Receive( "ARCBank_Admin_Send", function(length)
		if ARCBankGUI.Ignore then return end
		local chunk = net.ReadString()
		local total = net.ReadString()
		local line = net.ReadString()
		if !ARCBankGUI.DermaPanel || !ARCBankGUI.DermaPanel:IsValid() then return end
		if ARCBankGUI.CurrentChunk != tonumber(chunk) then 
			ARCBankGUI.LogOpen:SetText("Error. Got line #"..tostring(chunk).." while expecting for line #"..tostring(ARCBankGUI.CurrentChunk))
			ARCBankGUI.LogList:SetVisible(true)
			ARCBankGUI.Ignore = true
			return
		end
		ARCBankGUI.Log = ARCBankGUI.Log.."\n"..line
		ARCBankGUI.LogProgress:SetFraction( tonumber(chunk)/tonumber(total) )
		ARCBankGUI.LogOpen:SetText("Loading... ("..tostring(math.Round((tonumber(chunk)/tonumber(total))*100)).."%)")
		if (tonumber(chunk)/tonumber(total)) == 1 then
			ARCBankGUI.LogOpen:SetText("Open selected log")
			ARCBankGUI.LogDownloaded = true
			ARCBankGUI.LogList:SetVisible(true)
		end
		ARCBankGUI.CurrentChunk = ARCBankGUI.CurrentChunk + 1
	end)
	net.Receive( "ARCBank_Admin_GUI", function(length)
		local lol = net.ReadTable()
		local wat = net.ReadTable()
		local words = net.ReadTable()
		ARCBankGUI:Open(lol,wat,words)
	end)
end