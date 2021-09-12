class ItemControlWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle item1, item2, item3, item4, item5;
var TextureHandle tex2, tex3, tex4, tex5;


function OnRegisterEvent() 
{
	RegisterEvent( EV_Restart );
	RegisterEvent(EV_InventoryUpdateItem);
}

function OnLoad()
{
    InitHandle();
    OnRegisterEvent();	
	Me.SetWindowSize( 182 , 34 );
	Me.HideWindow();
	
}

function InitHandle() 
{
    Me = GetWindowHandle("ItemControlWnd");
    item1 = GetItemWindowHandle("ItemControlWnd.I_Item1");
    item2 = GetItemWindowHandle("ItemControlWnd.I_Item2");
    item3 = GetItemWindowHandle("ItemControlWnd.I_Item3");
    item4 = GetItemWindowHandle("ItemControlWnd.I_Item4");
    item5 = GetItemWindowHandle("ItemControlWnd.I_Item5");
	tex2 = GetTextureHandle("ItemControlWnd.over2");
	tex3 = GetTextureHandle("ItemControlWnd.over3");
	tex4 = GetTextureHandle("ItemControlWnd.over4");
    tex5 = GetTextureHandle("ItemControlWnd.over5");

}


function OnShow()
{
	SetPosition();
}

function SetPosition()
{
	local bool IsExpand1;
	local bool IsExpand2;
	local bool IsExpand3;
	local bool IsExpand4;
	local bool IsExpand5;
	local ItemInfo	info;
	local bool isVertical;
	
	isVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );
	
	IsExpand1 = GetOptionBool( "Game", "Is1ExpandShortcutWnd" );
	IsExpand2 = GetOptionBool( "Game", "Is2ExpandShortcutWnd" );
	IsExpand3 = GetOptionBool( "Game", "Is3ExpandShortcutWnd" );
	IsExpand4 = GetOptionBool( "Game", "Is4ExpandShortcutWnd" );
	IsExpand5 = GetOptionBool( "Game", "Is5ExpandShortcutWnd" );
	
	if (!isVertical)
	{	

		if (item5.GetItem(0, info)) Me.SetWindowSize( 182 , 34 );
		else  Me.SetWindowSize( 145 , 34 );
		
		item2.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 74, 0);
		item3.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 37, 0);
		item4.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 111, 0);
		item5.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 148, 0);
		tex2.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 37, 0);
		tex3.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 74, 0);
		tex4.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 111, 0);
		tex5.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 148, 0);

		if (IsExpand5)
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal_5", 148, -48);
		}	
		else if (IsExpand4)
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal_4", 148, -48);
		}
			
		else if (IsExpand3)
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal_3", 148, -48);
		}
		else if (IsExpand2)
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal_2", 148, -48);
		}
			
		else if (IsExpand1)
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal_1", 148, -48);
		}
			
		else
		{
			AnchorItems("ShortcutWnd.ShortcutWndHorizontal", 148, -48);
		}
	}
	else
	{	
		if (item5.GetItem(0, info)) Me.SetWindowSize( 34 , 182 );
		else  Me.SetWindowSize( 34 , 145 );
		
		item2.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 74);
		item3.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" ,0, 37);
		item4.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 111);
		item5.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 148);
		tex2.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 37);
		tex3.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" ,0, 74);
		tex4.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 111);
		tex5.SetAnchor("ItemControlWnd", "TopLeft", "TopLeft" , 0, 148);
		if (IsExpand5)
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical_5", -48, 148);
		}	
		else if (IsExpand4)
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical_4",  -48, 148);
		}
			
		else if (IsExpand3)
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical_3",  -48, 148);
		}
		else if (IsExpand2)
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical_2",  -48, 148);
		}
			
		else if (IsExpand1)
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical_1",  -48, 148);
		}
			
		else
		{
			AnchorItems("ShortcutWnd.ShortcutWndVertical",  -48, 148);
		}
	}
	
}

function AnchorItems(string window, int x, int y)
{
	local bool isVertical;	
	isVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );	
	if (!isVertical) Me.SetAnchor(window, "TopLeft", "TopLeft", x+36, y+10);
	else Me.SetAnchor(window, "TopLeft", "TopLeft", x+10, y+40);
}


function OnEvent(int Event_ID, String param) 
{
	if (Event_ID == EV_Restart)
		ClearAll();	
}

function ClearAll()
{
	item1.Clear();
	item2.Clear();
	item3.Clear();
	item4.Clear();
	item5.Clear();

}

static final function string ReplaceText(coerce string Text, coerce string Replace, coerce string With)
{
	local int i;
	local string Output;
 
	i = InStr(Text, Replace);
	while (i != -1) {	
		Output = Output $ Left(Text, i) $ With;
		Text = Mid(Text, i + Len(Replace));	
		i = InStr(Text, Replace);
	}
	Output = Output $ Text;
	return Output;
}


defaultproperties
{
}
