-->>Install Both folders in your addon folder.<<--

-> Do not ask me a question that is already answered here <-

****DO NOT EDIT THE LUA FILES TO CHANGE YOUR CONFIG!!! READ THIS!!
****This thing is made so it will work with each update! Editing the lua files will break the config file backwards compatibility!

** Type "arcbank help" in console to get a list of all the commands.

* Type "arcbank settings_help" to get a list of all the settings.

* Type "arcbank settings_help (setting name)" To get a description of what the setting does.

* Type "arcbank settings (setting name) (value)" To change the setting to the specified value.

** Type "arcbank admin_gui" in the ingame console to open the admin menu. It makes changing settings a lot easier.

** After changing ANY settings, type "arcbank settings_save" in console!!!

* If the ATMs can't connect, try "arcbank reset" in console.

* You can now change the language!
	type "arcbank settings atm_language (lang)" in console
	(lang) can be the following:
	en -- English
	fr -- French
	ger -- German
	pt_br -- Brazilian Portuguese

	Spanish Coming soon!

* Want your own server logo on the ATMs? Here's How! 

	1. Create a 512 x 384 image with your server logo on it.
	2. Import it in a program called VTFEdit using the "Biggest Power Of 2" Resize method. (Yes, it will look stretched in the program, but ingame it will be fine)
	3. Save it in ..\addons\ARCBank_content\materials\arc\atm_base\logo2.vtf
	4. You're good to go!

* Want this thing to work with your custom gamemode? Here's how! (ADVANCED LUA CODERS ONLY!)

	1. Create a lua file with a 5 character long name. in ..\addons\ARCBank\lua\arcbank\server\
	2. Do something like this:


------------------------------------------------------------------
function ARCBank:PlayerAddMoney(ply,amount)
	if GAMEMODE.Name=="MySuperAwesomeGamemode" then
		ply:MyAddMoneyFunction(amount)
	end
end
function ARCBank:PlayerCanAfford(ply,amount) -- This must return true or false
	if GAMEMODE.Name=="MySuperAwesomeGamemode" then
		return ply:MyCanAffordFunction(amount) 
	end
end
------------------------------------------------------------------
Note: The default code looks like this:
------------------------------------------------------------------
function ARCBank:PlayerCanAfford(ply,amount)
	if GAMEMODE.Name=="DarkRP" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) then
			return ply:canAfford(amount)
		else
			return ply:CanAfford(amount)
		end
	else
		return true
	end
end
function ARCBank:PlayerAddMoney(ply,amount)
	if GAMEMODE.Name=="DarkRP" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) then
			ply:addMoney(amount)
		else
			ply:AddMoney(amount)
		end
	else
		ply:SendLua("notification.AddLegacy( \"I'm going to pretend that your wallet is unlimited because this is an unsupported gamemode.\", 0, 5 )")
	end
end
------------------------------------------------------------------

Changelog:
0.9.5
* Fixed a bug where Cleanup map caused a server crashed.
+ Added "arcbank atm_unsave" command. It detaches the ATMs from the map so you can move them and resave them.
+ (Dark RP only) You can make it so that cops (Or whatever job) can get a notification when an ATM is being hacked by using the atm_hack_notify setting. example: (arcbank settings atm_hack_notify mayor,civil protection,cop)
* Minor Bugfixes I can't remember right now.
* Fixed a bug where the Group owner options wouldn't show up on the ATM.

0.9.4
* This was mostly a bugfix update...
* Added the ability to change languages.
* Fixed Support with Linux.

0.9.3
* Fixed the model of the Hacker when using the /drop command in DarkRP (Card Model isn't fixed yet... sorry!)
* Fixed a bug where the Admin menu didn't work properly
* Players only now teleport to the ATM when it's requesting the player to take or give money.
+ If a player walks far away from the atm, it will auto-return their card.
+ Any player can now pick up "hacked" money.
+ Added fullscreen mode.

0.9.2
* Minor bug fixes

0.9.1
* Fixed some bugs with dark RP 2.5
* Fixed a glitch where you couldn't change settings via server console.

0.9.0 
* BETA started