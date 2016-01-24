ARCBank_Draw = {}

surface.CreateFont( "ARCBankATMSmall", {
	font = "Lucida Console",
	size = 8,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
surface.CreateFont( "ARCBankATM", {
	font = "Lucida Console",
	size = 12,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
surface.CreateFont( "ARCBankATMBigger", {
	font = "Arial",
	size = 16,
	weight = 750,
	blursize = 0,
	scanlines = 5,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
surface.CreateFont( "ARCBankCard", {
	font = "OCR A Extended",
	size = 24,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true
} )
surface.CreateFont( "ARCBankHolo", {
	font = "Eras Demi ITC",
	size = 64,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
function ARCBank_Draw:Window(x,y,w,l,mat,title)
	surface.SetDrawColor( 225, 225, 225, 200 )
	surface.DrawRect(x, y, w+20, l+20 ) 
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( x, y, w+20, l+20) 
	surface.DrawOutlinedRect( x, y, w+20, 20) 
	surface.SetDrawColor( 235, 235, 235, 255 )
	surface.SetMaterial( mat )
	draw.SimpleText( title, "ARCBankATMBigger", x+20, y+10, Color(0,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  ) 
	surface.DrawTexturedRect( x+2, y+2, 16, 16 )
end