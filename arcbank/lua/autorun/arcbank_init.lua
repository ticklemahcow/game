--ENUMS FOR ARC BANKING SYSTEM!
--137164355
--[[
Note: add SQL support

?DatGuy: http://dev.mysql.com/downloads/installer/5.6.html
4:55 PM - Vladimir: thats the database engine
4:56 PM - Vladimir: probs needs MySQL workbench too
4:56 PM - Vladimir: http://dev.mysql.com/downloads/file.php?id=415341
4:56 PM - Vladimir: http://dev.mysql.com/downloads/tools/workbench/
?DatGuy: 4:56 PM - Vladimir: dl both programs then you have the core DBMS we use
4:56 PM - Vladimir: Just standard MySQL running locally


]]
function ARCBankMsg(msg)
	Msg("ARCBank. "..tostring(msg).."\n")
	if !ARCBank then return end
	if ARCBank.LogFileWritten then
		file.Append(ARCBank.LogFile, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\n")
	end
end
ARCBankMsg("Running...\n ____ ____ _ ___ ___     ____ ____ ____ ____ _  _ ____ ____    ___  ____ _  _ _  _ _ _  _ ____ \n |__| |__/ |  |    /     |    |__/ |__| |    |_/  |___ |__/    |__] |__| |\\ | |_/  | |\\ | | __ \n |  | |  \\ |  |   /__    |___ |  \\ |  | |___ | \\_ |___ |  \\    |__] |  | | \\| | \\_ | | \\| |__] \n")
ARCBankMsg(table.Random({"Super fukin' Sexy edition!","The most realistic ATM system you'll ever see!","I love you.","Isn't this amazing?","That's one fiiiine addon you got there!","Just in time for the holidays!"}))
ARCBankMsg("By Aritz Beobide-Cardinal (ARitz Cracker)")

ARCBank = ARCBank or {}
ARCBank.Update = "December 31st 2013"
ARCBank.Version = "0.9.5b"

--TRANSACTION ERRORS
ARCBANK_ERRORSTRINGS = {}
ARCBANK_ERROR_VOICE = {}
ARCBANK_ERROR_NONE = 0
ARCBANK_ERROR_VOICE[0] = "vo/heavy_goodjob02.wav"
ARCBANK_ERRORSTRINGS[0] = "Completed Successfully"
ARCBANK_ERROR_NO_CASH_PLAYER = 1
ARCBANK_ERROR_VOICE[1] = "vo/heavy_domination03.wav"
ARCBANK_ERRORSTRINGS[1] = "Your wallet doesn't have enough cash!"
ARCBANK_ERROR_NO_CASH = 2
ARCBANK_ERROR_VOICE[2] = "vo/heavy_laughlong01.wav"
ARCBANK_ERRORSTRINGS[2] = "The account doesn't have enough\nmoney!"
ARCBANK_ERROR_NO_ACCES = 3
ARCBANK_ERROR_VOICE[3] = "vo/heavy_domination02.wav"
ARCBANK_ERRORSTRINGS[3] = "You do not have acces to this\noperation!"
ARCBANK_ERROR_NIL_ACCOUNT = 4
ARCBANK_ERROR_VOICE[4] = "vo/heavy_jeers03.wav"
ARCBANK_ERRORSTRINGS[4] = "Account Doesn't Exist"
ARCBANK_ERROR_PLAYER_FOREVER_ALONE = 5
ARCBANK_ERROR_VOICE[5] = "vo/heavy_fairyprincess10.wav"
ARCBANK_ERRORSTRINGS[5] = "You do not have acces to any group\naccounts. :("
ARCBANK_ERROR_NIL_PLAYER = 6
ARCBANK_ERROR_VOICE[6] = "vo/heavy_jeers03.wav"
ARCBANK_ERRORSTRINGS[6] = "The player you tried to select doesn't\nexist or is invalid."
ARCBANK_ERROR_DUPE_PLAYER = 7
ARCBANK_ERROR_VOICE[7] = "vo/heavy_jeers03.wav"
ARCBANK_ERRORSTRINGS[7] = "The player you tried to add to the\ngroup is already a member!"

ARCBANK_ERROR_TOO_MUCH_CASH = 8
ARCBANK_ERROR_VOICE[8] = "vo/heavy_jeers03.wav"
ARCBANK_ERRORSTRINGS[8] = "An account cannot have more than\n100 Trillion Credits"

--CREATION ERRORS
ARCBANK_ERROR_NAME_DUPE = 9
ARCBANK_ERROR_VOICE[9] = "vo/heavy_jeers03.wav"
ARCBANK_ERRORSTRINGS[9] = "Account with the same or a similar\nname already exists."
ARCBANK_ERROR_UNDERLING = 10
ARCBANK_ERROR_VOICE[10] = "vo/heavy_domination01.wav"
ARCBANK_ERRORSTRINGS[10] = "You don't have a high enough player\nrank."
ARCBANK_ERROR_INVALID_RANK = 11
ARCBANK_ERROR_VOICE[11] = "vo/heavy_no03.wav"
--ARCBANK_ERRORSTRINGS[11] = "Cannot upgrade account. Already at\nhighest rank."
ARCBANK_ERRORSTRINGS[11] = "The rank you tried to assign this\naccount to was TOO DAMN HIGH!"

ARCBANK_ERROR_TOO_MANY_ACCOUNTS = 12
ARCBANK_ERROR_VOICE[12] = "vo/heavy_no03.wav"
ARCBANK_ERRORSTRINGS[12] = "You've reached the limit of accounts\nyou can have."

ARCBANK_ERROR_DEBT = 13
ARCBANK_ERROR_VOICE[13] = "vo/heavy_laughlong01.wav"
ARCBANK_ERRORSTRINGS[13] = "You can't do this while you're in debt."
--OTHER ERRORS
ARCBANK_ERROR_NOT_LOADED = 14
ARCBANK_ERROR_VOICE[14] = "vo/heavy_negativevocalization06.wav"
ARCBANK_ERRORSTRINGS[14] = "The ARCBank system failed to load."
ARCBANK_ERROR_UNKNOWN = 15
ARCBANK_ERROR_VOICE[15] = "vo/heavy_jeers09.wav"
ARCBANK_ERRORSTRINGS[15] = "Unknown Error. Try again."

ARCBANK_ERRORBITRATE = 8

ARCBANK_NAME = 1
ARCBANK_NAMETO = 2
ARCBANK_RANK = 2
ARCBANK_PLAYER = 3
ARCBANK_GROUP_OWNER = 3
ARCBANK_BALANCE = 4
ARCBANK_MONEY = 4
ARCBANK_GROUP_ACCES = 5
ARCBANK_UPGRADE = 6
ARCBANK_CHUNK = 6
ARCBANK_ID = 6
ARCBANK_CHUNK_TOTAL = 7
--OPERATIONS
ARCBANK_DEPOSIT = 0
ARCBANK_WITHDRAWL = 1
--ACCOUNTS
ARCBANK_ACCOUNTSTRINGS = {}
ARCBANK_PERSONALACCOUNTS_ = 0
ARCBANK_ACCOUNTSTRINGS[0] = "invalid"
ARCBANK_PERSONALACCOUNTS_STANDARD = 1
ARCBANK_ACCOUNTSTRINGS[1] = "standard"
ARCBANK_PERSONALACCOUNTS_BRONZE = 2
ARCBANK_ACCOUNTSTRINGS[2] = "bronze"
ARCBANK_PERSONALACCOUNTS_SILVER = 3
ARCBANK_ACCOUNTSTRINGS[3] = "silver"
ARCBANK_PERSONALACCOUNTS_GOLD = 4
ARCBANK_ACCOUNTSTRINGS[4] = "gold"
ARCBANK_GROUPACCOUNTS_ = 5
ARCBANK_ACCOUNTSTRINGS[5] = "group_invalid"
ARCBANK_GROUPACCOUNTS_STANDARD = 6
ARCBANK_ACCOUNTSTRINGS[6] = "group_standard"
ARCBANK_GROUPACCOUNTS_PREMIUM = 7
ARCBANK_ACCOUNTSTRINGS[7] = "group_premium"
ARCBANK_ACCOUNTBITRATE = 4


--ATM OPERATORS
ARCBANK_ATM_SERVERMSG = -1
ARCBANK_ATM_PING = 0
ARCBANK_ATM_ACCOUNTINFO = 1
ARCBANK_ATM_CASH = 2
ARCBANK_ATM_TRANSFER = 3
ARCBANK_ATM_CREATE = 4
ARCBANK_ATM_GROUPADMIN = 5
ARCBANK_ATM_GETGROUPS = 6
ARCBANK_ATM_LOG = 7
ARCBANK_ATMBITRATE = 4
ARCBank.ATMMsgs = ARCBank.ATMMsgs or {}
ARCBank.CardMsgs = ARCBank.CardMsgs or {}
ARCBank.UserMsgs = ARCBank.UserMsgs or {}
function ARCBank.UpdateLang(lang)
	if lang == "en" then
		MsgN("ARCBank. English selected.")
		ARCBANK_ERRORSTRINGS[0] = "Completed Successfully"
		ARCBANK_ERRORSTRINGS[1] = "Your wallet doesn't have enough cash!"
		ARCBANK_ERRORSTRINGS[2] = "The account doesn't have enough\nmoney!"
		ARCBANK_ERRORSTRINGS[3] = "You do not have access to this\noperation!"
		ARCBANK_ERRORSTRINGS[4] = "Account doesn't exist!"
		ARCBANK_ERRORSTRINGS[5] = "You do not have access to any group\naccounts. :("
		ARCBANK_ERRORSTRINGS[6] = "The player you tried to select doesn't\nexist or is invalid."
		ARCBANK_ERRORSTRINGS[7] = "The player you tried to add to the\ngroup is already a member!"
		ARCBANK_ERRORSTRINGS[8] = "An account cannot have more than\n100 Trillion Credits"
		ARCBANK_ERRORSTRINGS[9] = "Account with the same or a similar\nname already exists."
		ARCBANK_ERRORSTRINGS[10] = "You don't have a high enough player\nrank."
		ARCBANK_ERRORSTRINGS[11] = "Cannot upgrade account. Already at\nhighest rank."
		ARCBANK_ERRORSTRINGS[12] = "You've reached the limit of accounts\nyou can have."
		ARCBANK_ERRORSTRINGS[13] = "You can't do this while you're in debt."
		ARCBANK_ERRORSTRINGS[14] = "The ARCBank system failed to load."
		ARCBANK_ERRORSTRINGS[15] = "Unknown Error. Try again."
		ARCBank.ATMMsgs.NetworkError = "I'm out-of-service :(\n(ERROR: 0x045)\n\nPlease contact a\nsystem administrator."
		ARCBank.ATMMsgs.HackingError = "I'm out-of-service :(\n(ERROR: 0x539)\n\nPlease visit a\ndifferent terminal."
		ARCBank.ATMMsgs.HackBegin = "WARNING!\nEMP DEVICE DETECTED!"
		ARCBank.ATMMsgs.Welcome = "Welcome"
		ARCBank.ATMMsgs.Loading = "Loading..."
		ARCBank.ATMMsgs.Waiting = "Waiting..."
		ARCBank.ATMMsgs.LoadingMsg = "Please Wait..."
		ARCBank.ATMMsgs.TakeCash = "Please take your cash."
		ARCBank.ATMMsgs.GiveCash = "Please insert your cash."
		ARCBank.ATMMsgs.Yes = "Yes"
		ARCBank.ATMMsgs.No = "No"
		ARCBank.ATMMsgs.Keypad = "Enter using the keypad:"
		ARCBank.ATMMsgs.Enter = "Press \"ENTER\" to Continue"
		ARCBank.ATMMsgs.File = "Text File - Page %PAGE%"
		ARCBank.ATMMsgs.FileNext = "Next Page"
		ARCBank.ATMMsgs.FilePrev = "Previous Page"
		ARCBank.ATMMsgs.FileClose = "Press \"CANCEL\" to Close"
		ARCBank.ATMMsgs.PersonalInformation = "Personal Account\nInformation"
		ARCBank.ATMMsgs.PersonalUpgrade = "Upgrade/Create\nPersonal Account"
		ARCBank.ATMMsgs.GroupInformation = "Group Account\nInformation"
		ARCBank.ATMMsgs.GroupUpgrade = "Upgrade/Create\nGroup Account"
		ARCBank.ATMMsgs.Fullscreen = "Toggle\nFullscreen Mode"
		ARCBank.ATMMsgs.Exit = "Exit"
		ARCBank.ATMMsgs.Back = "Back"
		ARCBank.ATMMsgs.More = "More"
		ARCBank.ATMMsgs.Deposit = "Cash Deposit"
		ARCBank.ATMMsgs.Withdrawal = "Cash Withdrawal"
		ARCBank.ATMMsgs.DepositAsk = "How much would you like to deposit?"
		ARCBank.ATMMsgs.WithdrawalAsk = "How much would you like to withdraw?"
		ARCBank.ATMMsgs.Transfer = "Transfer Funds"
		ARCBank.ATMMsgs.ViewLog = "View Log"
		ARCBank.ATMMsgs.OtherNumber = "Other Amount"
		ARCBank.ATMMsgs.MainMenu = "Welcome, %PLAYERNAME%.\nHow may I help you?"
		ARCBank.ATMMsgs.Balance = "Balance:"
		ARCBank.ATMMsgs.MaximumCash = "A wasted life"
		ARCBank.ATMMsgs.ChooseAccount = "Please choose an account"
		ARCBank.ATMMsgs.ChoosePlayer = "Please choose a player"
		ARCBank.ATMMsgs.SIDPrompt = "Enter after %TEXT%"
		ARCBank.ATMMsgs.SIDAsk = "Does the Steam ID start with STEAM_0:1?"
		ARCBank.ATMMsgs.Entered = "Entered:"
		ARCBank.ATMMsgs.GiveMoneyAccount = "Choose the account to\ngive the money to."
		ARCBank.ATMMsgs.PlayerTooFar = "You're too far away from the ATM."
		ARCBank.ATMMsgs.NumberTooHigh = "You can't use a number higher than\n%NUM%!"
		ARCBank.ATMMsgs.CloseAccount = "Close Account"
		ARCBank.ATMMsgs.AddPlayerGroup = "Add Player\nto group"
		ARCBank.ATMMsgs.RemovePlayerGroup = "Remove Player\nfrom group"
		ARCBank.ATMMsgs.CloseNotice = "You're about to close this account.\nAll money in here will be considered\nas a \"donation\" to ARCBank.\n\nAre you sure?"
		ARCBank.ATMMsgs.OpenAccount = "Would you like to open\na personal account?"
		ARCBank.ATMMsgs.CreateGroupAccount = "*Create Group\nAccount"
		ARCBank.ATMMsgs.PersonalAccount = "*Personal Account      "
		ARCBank.ATMMsgs.AskMoney = "How much money do you want to give?"
		ARCBank.ATMMsgs.OfflinePlayer = "Offline Player"
		ARCBank.CardMsgs.NoOwner = "No owner is set!"
		ARCBank.CardMsgs.Owner = "This is owned by %PLAYER%"
		ARCBank.CardMsgs.InvalidOwner = "You don't own this device!"
		ARCBank.CardMsgs.NoCard = "This device isn't requesting a card!"
		ARCBank.CardMsgs.InsertCard = "Customer, please insert your card."
		ARCBank.CardMsgs.Account = "Which account do you want to use?" 
		ARCBank.CardMsgs.AccountPay = "Which account do you want to pay with?"
		ARCBank.CardMsgs.Label = "What's the label of this transaction?"
		
		ARCBank.UserMsgs.Hack = "An ATM is being hacked!"
	elseif lang == "ger" then
		MsgN("ARCBank. German selected. - Translated by MindEyes")
		ARCBANK_ERRORSTRINGS[0] = "Vollständig abgeschlossen"
		ARCBANK_ERRORSTRINGS[1] = "Sie haben nicht genug Bargeld!"
		ARCBANK_ERRORSTRINGS[2] = "Ihr Konto besitzt nicht genug Geld!"
		ARCBANK_ERRORSTRINGS[3] = "Sie haben kein Recht dies auszuführen!"
		ARCBANK_ERRORSTRINGS[4] = "Konto existiert nicht!"
		ARCBANK_ERRORSTRINGS[5] = "Sie besitzen keine Rechte\nfür ein Gruppenkonto. :("
		ARCBANK_ERRORSTRINGS[6] = "Den Spieler den Sie auswählen\nwollten existiert nicht oder ist\nungültig."
		ARCBANK_ERRORSTRINGS[7] = "Den Spieler den du versucht hast\nhinzuzufügen ist bereits Mitglied!"
		ARCBANK_ERRORSTRINGS[8] = "Ein Konto kann nicht mehr als\n100 Trillionen Credits fassen!"
		ARCBANK_ERRORSTRINGS[9] = "Konto mit dem selben oder ähnlichen\nNamen existiert bereits."	
		ARCBANK_ERRORSTRINGS[10] = "Ihr Playerrang ist zu niedrig."
		ARCBANK_ERRORSTRINGS[11] = "Konto upgrade fehlgeschlagen.\nKonto ist bereits auf dem höchsten\nLevel."
		ARCBANK_ERRORSTRINGS[12] = "Sie haben das Limit der maximalen\nKonten erreicht."
		ARCBANK_ERRORSTRINGS[13] = "Sie können das nicht machen wenn\nSie Schulden haben."
		ARCBANK_ERRORSTRINGS[14] = "Das ARCBank System konnte nicht\ngeladen werden."
		ARCBANK_ERRORSTRINGS[15] = "Unspezifischer Error.\nProbiere es erneut."
		ARCBank.ATMMsgs.NetworkError = "Ich bin außer Betrieb :(\n(ERROR: 0x045)\n\nBitte kontaktier einen System-Administatoren."
		ARCBank.ATMMsgs.HackingError = "Ich bin außer Betrieb :(\n(ERROR: 0x539)\n\nBitte gehe zu einem anderen Terminal."
		ARCBank.ATMMsgs.HackBegin = "WARNUNG!\nEMP GERÄT ERKANNT!"
		ARCBank.ATMMsgs.Welcome = "Willkommen"
		ARCBank.ATMMsgs.Loading = "Lädt..."
		ARCBank.ATMMsgs.Waiting = "Wartet..." -- This shows in the title bar when the player has to take or put money in the ATM
		ARCBank.ATMMsgs.LoadingMsg = "Bitte Warten..."
		ARCBank.ATMMsgs.TakeCash = "Bitte nehm dein Geld."
		ARCBank.ATMMsgs.GiveCash = "Bitte geben Sie das Geld nun hinein."
		ARCBank.ATMMsgs.Yes = "Ja"
		ARCBank.ATMMsgs.No = "Nein"
		ARCBank.ATMMsgs.Keypad = "Über das Keypad eingeben bitte:"
		ARCBank.ATMMsgs.Enter = "Drück \"ENTER\" zum fortfahren"
		ARCBank.ATMMsgs.File = "Text Dokument - Seite %PAGE%"
		ARCBank.ATMMsgs.FileNext = "Nächste Seite"
		ARCBank.ATMMsgs.FilePrev = "Vorherige Seite"
		ARCBank.ATMMsgs.FileClose = "Drück \"CANCEL\" zum schließen"
		ARCBank.ATMMsgs.PersonalInformation = "Persönliche Konto\nOptionen"
		ARCBank.ATMMsgs.PersonalUpgrade = "Upgrade/Erstell ein\nPersönliches Konto"
		ARCBank.ATMMsgs.GroupInformation = "Gruppen-Konto\nOptionen"
		ARCBank.ATMMsgs.GroupUpgrade = "Upgrade/Erstell\nein Gruppen Konto"
		ARCBank.ATMMsgs.Fullscreen = "Umschalten zum\nFullscreen Modus"
		ARCBank.ATMMsgs.Exit = "Exit"
		ARCBank.ATMMsgs.Back = "Zurück"
		ARCBank.ATMMsgs.More = "Mehr"
		ARCBank.ATMMsgs.Deposit = "Geld einzahlen"
		ARCBank.ATMMsgs.Withdrawal = "Geld auszahlen"
		ARCBank.ATMMsgs.DepositAsk = "Wie viel möchtest du einzahlen?"
		ARCBank.ATMMsgs.WithdrawalAsk = "Wie viel möchtest du abheben?"
		ARCBank.ATMMsgs.Transfer = "Geld\nÜberweisung"
		ARCBank.ATMMsgs.ViewLog = "Log ansehen"
		ARCBank.ATMMsgs.OtherNumber = "Anderer Wert"
		ARCBank.ATMMsgs.MainMenu = "Willkommen, %PLAYERNAME%.\nWie kann ich dir helfen?"
		ARCBank.ATMMsgs.Balance = "Kontostand:"
		ARCBank.ATMMsgs.MaximumCash = "Ein verlorenes Leben"
		ARCBank.ATMMsgs.ChooseAccount = "Bitte wählen Sie ein Konto\naus"
		ARCBank.ATMMsgs.ChoosePlayer = "Bitte wählen Sie einen Spieler\naus"
		ARCBank.ATMMsgs.SIDPrompt = "Eingeben nach: %TEXT%" -- This is used when the player is entering a steam ID (Enter after STEAM_0:0:)
		ARCBank.ATMMsgs.SIDAsk = "Fängt die SteamID mit STEAM_0:1 an?"
		ARCBank.ATMMsgs.Entered = "Eingegeben:"
		ARCBank.ATMMsgs.GiveMoneyAccount = "Wählen Sie ein Konto zum\nÜbeweisen aus"
		ARCBank.ATMMsgs.PlayerTooFar = "Sie sind zu weit entfernt vom ATM."
		ARCBank.ATMMsgs.NumberTooHigh = "Du kannst keine Nummer höher als\n%NUM% eintragen!" -- This is used when the player tries to enter a number too high.
		ARCBank.ATMMsgs.CloseAccount = "Konto schließen"
		ARCBank.ATMMsgs.AddPlayerGroup = "Spieler zur\nGruppe hinzufügen"
		ARCBank.ATMMsgs.RemovePlayerGroup = "Entferne Spieler\nvon Gruppe"
		ARCBank.ATMMsgs.CloseNotice = "Sie sind dabei dieses Konto zu löschen.\nDas ganze Geld wird als \"Spende\"\nan ARCBank genommen.\n\nSind sie sich sicher?"
		ARCBank.ATMMsgs.OpenAccount = "Möchtest du ein Persönliches\nKonto eröffnen?"
		ARCBank.ATMMsgs.CreateGroupAccount = "*Erstelle ein\nGruppen Konto"
		ARCBank.ATMMsgs.PersonalAccount = "*Persönliches Konto    "
		ARCBank.ATMMsgs.AskMoney = "Wieviel Geld möchten Sie geben?"
		ARCBank.ATMMsgs.OfflinePlayer = "Spieler Offline" -- When you want to select a player that's currently offline.
		ARCBank.CardMsgs.NoOwner = "Kein Owner ist gesetzt!"
		ARCBank.CardMsgs.Owner = "Das hier gehört %PLAYER%"
		ARCBank.CardMsgs.InvalidOwner = "Dir gehört dieses Gerät nicht!"
		ARCBank.CardMsgs.NoCard = "Das Gerät fordert keine Karte!"
		ARCBank.CardMsgs.InsertCard = "Kunde, Bitte fügen sie ihre Karte ein."
		ARCBank.CardMsgs.Account = "Welches Konto möchtest du benutzen?"
		ARCBank.CardMsgs.AccountPay = "Mit welchem Konto möchtest du bezahlen?"
		ARCBank.CardMsgs.Label = "Welchen Titel hat diese Transaktion?"

		
		ARCBank.UserMsgs.Hack = "An ATM is being hacked!"
	elseif lang == "huehuehue" || lang == "pt_br" then
		MsgN("ARCBank. Brazilian Portuguese selected. - Translated by Gm Matsilagi.")
		ARCBANK_ERRORSTRINGS[0] = "Completo com sucesso"
		ARCBANK_ERRORSTRINGS[1] = "Sua carteira não tem dinheiro\nsuficiente!"
		ARCBANK_ERRORSTRINGS[2] = "Essa conta não tem dinheiro\nsuficiente!"
		ARCBANK_ERRORSTRINGS[3] = "Voce não tem acesso a essa operação!"
		ARCBANK_ERRORSTRINGS[4] = "A conta não existe!"
		ARCBANK_ERRORSTRINGS[5] = "Você não tem acesso a nenhuma\nconta em grupo. :("
		ARCBANK_ERRORSTRINGS[6] = "O jogador que você escolheu não\nexiste ou é invalido!"
		ARCBANK_ERRORSTRINGS[7] = "O jogador que você tentou\nadicionar no grupo ja é membro!"
		ARCBANK_ERRORSTRINGS[8] = "Uma conta não pode ter mais que\n100 Trilões de créditos."
		ARCBANK_ERRORSTRINGS[9] = "Conta com o mesmo nome ou similar\njá existe."
		ARCBANK_ERRORSTRINGS[10] = "Você não tem um nível de jogador\nalto suficiente."
		ARCBANK_ERRORSTRINGS[11] = "Não pode atualizar a conta. Já esta\nno nível máximo."
		ARCBANK_ERRORSTRINGS[12] = "Você atingiu o limite de contas que\npode ter."
		ARCBANK_ERRORSTRINGS[13] = "Você não pode fazer isso enquanto\nesta em débito."
		ARCBANK_ERRORSTRINGS[14] = "O sistema da ACRBank falhou pra\ncarregar."
		ARCBANK_ERRORSTRINGS[15] = "Erro desconhecido.\nPor favor, tente de novo."
		ARCBank.ATMMsgs.NetworkError = "Estou fora de serviço :(\n(ERROR: 0x045)\n\nFavor contatar um admnistrador de sistema."
		ARCBank.ATMMsgs.HackingError = "Estou fora de serviço :(\n(ERROR: 0x539)\n\nPor favor, visite outro terminal."
		ARCBank.ATMMsgs.HackBegin = "PERIGO!\nDISPOSITIVO EMP DETECTADO!"
		ARCBank.ATMMsgs.Welcome = "Bem Vindo!"
		ARCBank.ATMMsgs.Loading = "Carregando..."
		ARCBank.ATMMsgs.Waiting = "Esperando..." -- This shows in the title bar when the player has to take or put money in the ATM
		ARCBank.ATMMsgs.LoadingMsg = "Por Favor Aguarde..."
		ARCBank.ATMMsgs.TakeCash = "Por Favor, pegue o dinheiro."
		ARCBank.ATMMsgs.GiveCash = "Por favor, insira a quantia."
		ARCBank.ATMMsgs.Yes = "Sim"
		ARCBank.ATMMsgs.No = "Não"
		ARCBank.ATMMsgs.Keypad = "Entre usando o teclado numérico:"
		ARCBank.ATMMsgs.Enter = "Pressione \"ENTER\" para Continuar"
		ARCBank.ATMMsgs.File = "Arquivo de texto - Página %PAGE%"
		ARCBank.ATMMsgs.FileNext = "Próxima Página"
		ARCBank.ATMMsgs.FilePrev = "Página Anterior"
		ARCBank.ATMMsgs.FileClose = "Pressione \"CANCEL\" para Fechar"
		ARCBank.ATMMsgs.PersonalInformation = "Informação\nda conta Pessoal"
		ARCBank.ATMMsgs.PersonalUpgrade = "Atualizar/Criar uma\nConta Pessoal"
		ARCBank.ATMMsgs.GroupInformation = "Informação da\nconta em Grupo"
		ARCBank.ATMMsgs.GroupUpgrade = "Atualizar/Criar\nConta em Grupo"
		ARCBank.ATMMsgs.Fullscreen = "Ativar modo\nTela-Cheia"
		ARCBank.ATMMsgs.Exit = "Sair"
		ARCBank.ATMMsgs.Back = "Voltar"
		ARCBank.ATMMsgs.More = "Mais"
		ARCBank.ATMMsgs.Deposit = "Depósito de\ndinheiro"
		ARCBank.ATMMsgs.Withdrawal = "Saque"
		ARCBank.ATMMsgs.DepositAsk = "Quanto você deseja depositar?"
		ARCBank.ATMMsgs.WithdrawalAsk = "Quanto você deseja sacar?"
		ARCBank.ATMMsgs.Transfer = "Transferir Fundos"
		ARCBank.ATMMsgs.ViewLog = "Ver Registro" --I dont know if this is the exact Log translation
		ARCBank.ATMMsgs.OtherNumber = "Outro valor"
		ARCBank.ATMMsgs.MainMenu = "Bem vindo, %PLAYERNAME%.\nComo posso ajudar?"
		ARCBank.ATMMsgs.Balance = "Balanço:"
		ARCBank.ATMMsgs.MaximumCash = "Uma vida perdida"
		ARCBank.ATMMsgs.ChooseAccount = "Por favor escolha uma conta"
		ARCBank.ATMMsgs.ChoosePlayer = "Por favor escolha um jogador"
		ARCBank.ATMMsgs.SIDPrompt = "Digite após o %TEXT%" -- This is used when the player is entering a steam ID (Enter after STEAM_0:0:)
		ARCBank.ATMMsgs.SIDAsk = "O SteamID começa com STEAM_0:1?"
		ARCBank.ATMMsgs.Entered = "Entrou:"
		ARCBank.ATMMsgs.GiveMoneyAccount = "Escolha a conta para fazer o depósito."
		ARCBank.ATMMsgs.PlayerTooFar = "Você está muito longe da ATM."
		ARCBank.ATMMsgs.NumberTooHigh = "Você não pode usar um número\nmais alto que %NUM%!" -- This is used when the player tries to enter a number too high.
		ARCBank.ATMMsgs.CloseAccount = "Fechar conta"
		ARCBank.ATMMsgs.AddPlayerGroup = "Adicionar jogador\nao grupo"
		ARCBank.ATMMsgs.RemovePlayerGroup = "Remover jogador\ndo grupo"
		ARCBank.ATMMsgs.CloseNotice = "Você esta prestes a fechar a conta.\nTodo o dinheiro dela será considerado\numa \"doação\" a ACRBank.\n\nDeseja mesmo fechar?"
		ARCBank.ATMMsgs.OpenAccount = "Gostaria de abrir uma conta pessoal?"
		ARCBank.ATMMsgs.CreateGroupAccount = "*Criar conta de Grupo"
		ARCBank.ATMMsgs.PersonalAccount = "*Conta pessoal         "
		ARCBank.ATMMsgs.AskMoney = "Quanto dinheiro você quer depositar?"
		ARCBank.ATMMsgs.OfflinePlayer = "Jogador Offline" -- When you want to select a player that's currently offline.
		ARCBank.CardMsgs.NoOwner = "Nenhum dono foi definido!"
		ARCBank.CardMsgs.Owner = "Esse cartão é do %PLAYER%"
		ARCBank.CardMsgs.InvalidOwner = "You don't own this device!"
		ARCBank.CardMsgs.NoCard = "This device isn't requesting a card!"
		ARCBank.CardMsgs.InsertCard = "Customer, please insert your card."
		ARCBank.CardMsgs.Account = "Which account do you want to use?" 
		ARCBank.CardMsgs.AccountPay = "Which account do you want to pay with?"
		ARCBank.CardMsgs.Label = "What's the label of this transaction?"
		
		ARCBank.UserMsgs.Hack = "An ATM is being hacked!"
	elseif lang == "fr" then
		MsgN("ARCBank. French selected. - Translated by Theo312.")
		ARCBANK_ERRORSTRINGS[0] = "Succès"
		ARCBANK_ERRORSTRINGS[1] = "Vous n'avez pas assez d'argent sur\nvous!"
		ARCBANK_ERRORSTRINGS[2] = "Le compte n'a pas assez d'argent!"
		ARCBANK_ERRORSTRINGS[3] = "Vous n'avez pas accès à cette\noperation!"
		ARCBANK_ERRORSTRINGS[4] = "Le compte n'existe pas!"
		ARCBANK_ERRORSTRINGS[5] = "Vous n'avez accès à aucun compte de\ngroupe. :("
		ARCBANK_ERRORSTRINGS[6] = "Le joueur que vous essayer de choisir\nn'existe pas ou est invalide"
		ARCBANK_ERRORSTRINGS[7] = "Le joueur que vous essayer d'ajouter\nest déjà dans le groupe!"
		ARCBANK_ERRORSTRINGS[8] = "Un compte ne peut pas avoir plus de\n100 Trillion."
		ARCBANK_ERRORSTRINGS[9] = "Un autre compte utilise déjà ce nom."
		ARCBANK_ERRORSTRINGS[10] = "Vous n'avez pas un rang de joueur\nsuffisant."
		ARCBANK_ERRORSTRINGS[11] = "Impossible d'ameliorer le compte.\nCompte déjà au maximum."
		ARCBANK_ERRORSTRINGS[12] = "Vous possèdez trop de comptes pour\nen créez un nouveau."
		ARCBANK_ERRORSTRINGS[13] = "Vous ne pouvez pas faire ça car vous\nêtes dans le rouge."
		ARCBANK_ERRORSTRINGS[14] = "Le systeme ARCBank ne c'est pas\ninitialiser correctement."
		ARCBANK_ERRORSTRINGS[15] = "Erreur inconnu.\nEssayez à nouveau."
		ARCBank.ATMMsgs.NetworkError = "Je suis hors-service :(\n(ERREUR: 0x045)\n\nS'il vous plaît, contactez un administrateur système."
		ARCBank.ATMMsgs.HackingError = "Je suis hors-service :(\n(ERREUR: 0x539)\n\nS'il vous plaît, visitez un autre distributeur."
		ARCBank.ATMMsgs.HackBegin = "ATTENTION! SYSTEME EMP DETECTE!"
		ARCBank.ATMMsgs.Welcome = "Bienvenue"
		ARCBank.ATMMsgs.Loading = "Chargement..."
		ARCBank.ATMMsgs.Waiting = "En attente..." -- This shows in the title bar when the player has to take or put money in the ATM
		ARCBank.ATMMsgs.LoadingMsg = "Patientez..."
		ARCBank.ATMMsgs.TakeCash = "Prenez votre argent."
		ARCBank.ATMMsgs.GiveCash = "Inserez l'argent."
		ARCBank.ATMMsgs.Yes = "Oui"
		ARCBank.ATMMsgs.No = "Non"
		ARCBank.ATMMsgs.Keypad = "Entrer en utilisant le clavier:"
		ARCBank.ATMMsgs.Enter = "Appuyer sur \"ENTRER\" pour continuer"
		ARCBank.ATMMsgs.File = "Dossier texte - Page %PAGE%"
		ARCBank.ATMMsgs.FileNext = "Page suivante"
		ARCBank.ATMMsgs.FilePrev = "Page precedente"
		ARCBank.ATMMsgs.FileClose = "Appuyer sur \"ANNULER\" pour fermer"
		ARCBank.ATMMsgs.PersonalInformation = "Information\nCompte Personnel"
		ARCBank.ATMMsgs.PersonalUpgrade = "Ameliorer/Creer\nCompte Personnel"
		ARCBank.ATMMsgs.GroupInformation = "Information\nCompte de Groupe"
		ARCBank.ATMMsgs.GroupUpgrade = "Ameliorer/Creer\nCompte de Groupe"
		ARCBank.ATMMsgs.Fullscreen = "Utiliser le\nplein écran"
		ARCBank.ATMMsgs.Exit = "Sortir"
		ARCBank.ATMMsgs.Back = "Revenir"
		ARCBank.ATMMsgs.More = "Plus"
		ARCBank.ATMMsgs.Deposit = "Deposer de\nl'argent"
		ARCBank.ATMMsgs.Withdrawal = "Retirer de\nl'argent"
		ARCBank.ATMMsgs.DepositAsk = "Combien voulez vous déposer?"
		ARCBank.ATMMsgs.WithdrawalAsk = "Combien voulez vous retirer?"
		ARCBank.ATMMsgs.Transfer = "Transferer des\nfonds"
		ARCBank.ATMMsgs.ViewLog = "Voir les logs"
		ARCBank.ATMMsgs.OtherNumber = "Autre montant"
		ARCBank.ATMMsgs.MainMenu = "Bienvenue, %PLAYERNAME%.\nComment puis-je vous aidez?"
		ARCBank.ATMMsgs.Balance = "Argent:"
		ARCBank.ATMMsgs.MaximumCash = "Une vie gachée"
		ARCBank.ATMMsgs.ChooseAccount = "S'il vous plaît, choisissez un compte"
		ARCBank.ATMMsgs.ChoosePlayer = "S'il vous plaît, choisissez un joueur"
		ARCBank.ATMMsgs.SIDPrompt = "Entrer après %TEXT%" -- This is used when the player is entering a steam ID (Enter after STEAM_0:0:)
		ARCBank.ATMMsgs.SIDAsk = "Est ce que le Steam ID commence avec STEAM_0:1?"
		ARCBank.ATMMsgs.Entered = "Entrer:"
		ARCBank.ATMMsgs.GiveMoneyAccount = "Choisissez le compte ou vous souhaitez donnez l'argent."
		ARCBank.ATMMsgs.PlayerTooFar = "Vous êtes trop loin de l'ATM."
		ARCBank.ATMMsgs.NumberTooHigh = "Vous ne pouvez pas utiliser un\nnombre plus grand que\n%NUM%!" -- This is used when the player tries to enter a number too high.
		ARCBank.ATMMsgs.CloseAccount = "Fermer le compte"
		ARCBank.ATMMsgs.AddPlayerGroup = "Ajouter un joueur\nau groupe"
		ARCBank.ATMMsgs.RemovePlayerGroup = "Enlever un joueur\nau groupe"
		ARCBank.ATMMsgs.CloseNotice = "Vous êtes sur le point de fermer ce\ncompte. Tous l'argent dedans sera\nconsiderer comme une \"donation\" au\ngroupe ARCBank.\n\nEtes vous sûr?"
		ARCBank.ATMMsgs.OpenAccount = "Voulez vous ouvrir un compte Personnel?"
		ARCBank.ATMMsgs.CreateGroupAccount = "*Creer un compte de Groupe"
		ARCBank.ATMMsgs.PersonalAccount = "*Compte Personnel      "
		ARCBank.ATMMsgs.AskMoney = "Combien d'argent voulez vous donner?"
		ARCBank.ATMMsgs.OfflinePlayer = "Joueur deconnecté" -- When you want to select a player that's currently offline.
		ARCBank.CardMsgs.NoOwner = "Aucun proprietaire n'est attribué"
		ARCBank.CardMsgs.Owner = "Le proprietaire est %PLAYER%"
		ARCBank.CardMsgs.InvalidOwner = "Vous ne possédez pas ce dispositif!"
		ARCBank.CardMsgs.NoCard = "Ce dispositif ne demande pas une carte!"
		ARCBank.CardMsgs.InsertCard = "Client, s'il vous plaît insérer votre carte."
		ARCBank.CardMsgs.Account = "Quel compte voulez-vous utiliser?" 
		ARCBank.CardMsgs.AccountPay = "Avec quel compte voulez-vous payer?"
		ARCBank.CardMsgs.Label = "Quelle est la marque de cette transaction?"

		ARCBank.UserMsgs.Hack = "An ATM is being hacked!"
	else
		ARCBankMsg("INVALID LANGUAGE - "..lang)
		ARCBank.UpdateLang("en")
	end
end

   function gibemoniplos(num) --Adapted from my Heads-up display
			if !num || !isnumber(num) then return "Fuck you." end
			--[[
            if num < 1e6 then
                    return string.Comma(num)
            elseif num < 1e9 then
                    return floordec( num/1e6, 2 ).." Million Credits"
            elseif num < 1e12 then
                    return floordec( num/1e9, 2 ).." Billion Credits"
					]]
            --[[else]]if num < 1e14 then
                    --return floordec( num/1e12, 2 ).." Trillion Credits"
					return string.Comma(num)
            else
				return "A wasted life"
            end
    end
function booltonumber(bool)
	if bool then
		return 1
	else
		return 0
	end
end
function player.GetBySteamID(steamid)
	local ply = nil
	if !isstring(steamid) then return nil end
	for _, v in pairs( player.GetHumans() ) do
		if v:SteamID() == steamid then
			ply = v
		end
	end
	if !IsValid(ply) then
		ply = {}
		function ply:SteamID() return steamid end
		function ply:Nick() return "[Player Offline]" end
		function ply:IsPlayer() return false end
	end
	return ply
end
function player.GetNearest(pos)
	local dist = math.huge
	local ply = NULL
	for _, v in pairs( player.GetAll() ) do
		local newdist = pos:DistToSqr( v:GetPos() )
		if newdist < dist then
			ply = v
			dist = newdist
		end
	end
	return ply
end
function arc_fitstring(str,num)
	local length = string.len(str)
	if length <= num then return {str} end
	local tn = 2
	local strings = {string.Left( str, num )}
	local rs = string.Right( str, string.len(str)-num )
	local rl = string.len(rs)
	while string.len(rs) > num do
		strings[tn] = string.Left( rs, num )
		tn = tn + 1
		rs = string.Right( rs, string.len(rs)-num )
	end
	if strings[2] then
		strings[tn+1] = rs
	else
		strings[tn] = rs
	end
	return strings
end
function arc_randomround(number)
	if tobool(math.Round(math.random())) then
		return math.Round(number)
	else
		if tobool(math.Round(math.random())) then
			return math.floor(number)
		else
			return math.ceil(number)
		end
	end
end
function arc_randomexp(min,max)
	min = min - 1
	local relativemax = max - min
	local result = arc_randomround(2^(math.Rand(1,relativemax)/(relativemax*0.30102999566398119521373889472449))*(relativemax/10))
	if result < 1 then
		result = 1
	end
	return result + min
end
function arc_timesentence(sec)
	sec = math.Round(sec)
	local min = math.floor(sec/60)
	if sec <= 0 then
		return "Now"
	end
	if sec == 1 then
		return "1 second"
	end
	if sec < 60 then
		return ""..sec.." seconds"
	else
		if min == 1 then
			return "1 minute and "..(sec%60).." seconds"
		else
			return ""..min.." minutes and "..(sec%60).." seconds"
		end
	end
end


ARCBankMsg("Version: "..ARCBank.Version)
ARCBankMsg("Updated on: "..ARCBank.Update)
ARCBank.UpdateLang("en")
if SERVER then
	--[[
	function ARC_AddDir(dir) // recursively adds everything in a directory to be downloaded by client
		local files, directories = file.Find( dir.."/*", "GAME" )
		if !files then return end
		for _,v in pairs(files) do
			resource.AddSingleFile(dir.."/"..v)
		end
		for _, fdir in pairs(directories) do
			if fdir != ".svn" && fdir != "_svn" then // Don't spam people with useless .svn folders
				ARC_AddDir(dir.."/"..fdir)
			end
		end
	end
	ARC_AddDir("models/arc")
	ARC_AddDir("materials/arc")
	ARC_AddDir("sound/arcbank")
	resource.AddFile("materials/VGUI/entities/sent_arc_atm.vmt")
	resource.AddFile("materials/VGUI/entities/sent_arc_pinmachine.vmt")
	resource.AddFile("materials/VGUI/entities/weapon_arc_atmcard.vmt")
	resource.AddFile("materials/VGUI/entities/weapon_arc_atmhack.vmt")
	]]
	if file.Exists( "materials/arc/atm_base/logo2.vtf", "GAME" ) then
		resource.AddSingleFile( "materials/arc/atm_base/logo2.vtf" ) 
	else
		ARCBankMsg("WARNING! ATM LOGO FILE NOT FOUND! READ THE README!!!!")
	end
	if CreateConVar("arcbank_force_workshop", 1, {FCVAR_ARCHIVE}, "Should ARCBank force all clients to download the Workshop content? (RECOMMENDED!)"):GetBool() then
		resource.AddWorkshop("249141351")
	end
	AddCSLuaFile()
	ARCBankMsg("####     Loading Serverside Files..     ####")
	local serverfiles, _ = file.Find( "arcbank/server/*.lua", "LUA" )
	for i, v in ipairs( serverfiles ) do
		ARCBankMsg("#### Loading: /arcbank/server/"..v.." ####")
		include( "arcbank/server/"..v )
	end
	ARCBankMsg("####     Sending Clientside Files..     ####")
	local clientfiles, _ = file.Find( "arcbank/client/*.lua", "LUA" )
	for i, v in ipairs( clientfiles ) do
		ARCBankMsg("#### Sending: /arcbank/client/"..v.." ####")
		AddCSLuaFile( "arcbank/client/"..v )
		--include( "arcbank/client/"..v )
	end
	util.AddNetworkString( "ARCBank_Msg" )
	util.AddNetworkString( "ARC_Sound" )
	function ARCBankMsgCL(ply,msg)
		--net.Start( "ARCBank_Msg" )
		--net.WriteString( msg )
		if !ply || !ply:IsPlayer() then
			ARCBankMsg(msg)
		else
			ply:PrintMessage( HUD_PRINTTALK, msg)
			--net.Send(ply)
		end
	end
	net.Receive( "ARCBank_Msg", function(length,ply)
		local msg = net.ReadString() 
		MsgN("ARCBank - "..ply:Nick().." ("..ply:SteamID().."): "..msg)
	end)
	net.Receive( "ARC_Sound", function(length,ply)
		local pos = net.ReadVector() 
		local sound = net.ReadString() 
		for k,v in pairs(player.GetAll()) do
			if v != ply then
				v:SendLua("sound.Play( \""..sound.."\", Vector("..tostring(pos:__index("x"))..","..tostring(pos:__index("y"))..","..tostring(pos:__index("z")).."),65,100 )")
			end
		end
	end)
	ARCBankMsg("####  Serverside Lua Loading Complete.  ####")
	ARCBank.Load()
else
	ARCBankMsg("####     Loading Clientside Files..     ####")
	function arcbank_plysound(sound,pos)
		net.Start("ARC_Sound")
		net.WriteVector(pos)
		net.WriteString(sound)
		net.SendToServer()
	end
	local clientfiles, _ = file.Find( "arcbank/client/*.lua", "LUA" )
	for i, v in pairs( clientfiles ) do
		ARCBankMsg("#### Loading: /arcbank/client/"..v.." ####")
		include( "arcbank/client/"..v )
	end

	net.Receive( "ARCBank_Msg", function(length)
		local msg = net.ReadString() 
		MsgC(Color(255,255,255,255),"ARCBank Server: "..tostring(msg).."\n")
	end)
	function ARCBankMsgToServer(msg)
		net.Start( "ARCBank_Msg" )
		net.WriteString( msg )
		net.SendToServer()
	end
	
	ARCBankMsg("####  Clientside Lua Loading Complete.  ####")
end
