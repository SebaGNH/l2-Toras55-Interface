class AttributeEnchantWnd extends UICommonAPI;

//Handle List
var WindowHandle Me;
var ItemWindowHandle ItemWnd;
var ItemWindowHandle ihandle;
var TextBoxHandle TextBox;
var TextBoxHandle aValue;
var ButtonHandle OkButton;
var ButtonHandle StoneButton;
var ButtonHandle CrystalButton;

// 변수 목록
var ItemInfo AttInfo;
var ItemInfo SelectItemInfo, TargetInfo;		// 선택한 아이템
var int ScrollCID;			// 스크롤의 종류를 저장한다. 
var ItemID ScrollID;
var bool isAutomatic;
var int ItemIndex;
var int curAttValue;
var int confExit;

function OnRegisterEvent()
{
	RegisterEvent( EV_InventoryUpdateItem );
	RegisterEvent( EV_AttributeEnchantItemShow );
	RegisterEvent( EV_EnchantHide );
	RegisterEvent( EV_AttributeEnchantItemList );
	RegisterEvent( EV_AttributeEnchantResult );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	// IsShowWindow


	//Init Handle
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AttributeEnchantWnd" );
		ItemWnd = ItemWindowHandle( GetHandle( "AttributeEnchantWnd.ItemWnd" ) );
		TextBox = TextBoxHandle( GetHandle( "AttributeEnchantWnd.txtScrollName" ) );
		aValue = TextBoxHandle( GetHandle( "AttributeEnchantWnd.attValue" ) );
		OkButton = ButtonHandle( GetHandle( "AttributeEnchantWnd.btnOK" ) );	
		StoneButton = ButtonHandle( GetHandle( "AttributeEnchantWnd.btnStone" ) );	
		CrystalButton = ButtonHandle( GetHandle( "AttributeEnchantWnd.btnCrystal" ) );	
	}
	else
	{
		Me = GetWindowHandle( "AttributeEnchantWnd" );
		ItemWnd = GetItemWindowHandle( "AttributeEnchantWnd.ItemWnd" );
		TextBox = GetTextBoxHandle( "AttributeEnchantWnd.txtScrollName" );
		aValue = GetTextBoxHandle( "AttributeEnchantWnd.attValue" );
		OkButton = GetButtonHandle( "AttributeEnchantWnd.btnOK" );	
		StoneButton = GetButtonHandle( "AttributeEnchantWnd.btnStone" );	
		CrystalButton = GetButtonHandle( "AttributeEnchantWnd.btnCrystal" );			
	}
	ihandle = GetItemWindowHandle("InventoryWnd.InventoryItem");
	ItemIndex = 0;
}

function OnEvent(int Event_ID, string param)
{	
	if (Event_ID == EV_AttributeEnchantItemShow)
	{
		// 속성 해제 창이 열렸을때는 속성 인첸트를 못하게 막는다.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd") )	
		{	
			// 왜 속성 인첸트를 창을 못여는지 안내
			AddSystemMessage(3161);	
			OnCancelClick();
		}
		else
		{
			HandleAttributeEnchantShow(param);	
		}
	}
	else if (Event_ID == EV_EnchantHide)
	{
		HandleAttributeEnchantHide();
	}
	else if (Event_ID == EV_AttributeEnchantItemList)
	{
		HandleAttributeEnchantItemList(param);
	}
	else if (Event_ID == EV_AttributeEnchantResult)
	{
		HandleAttributeEnchantResult(param);
	}
	else if (Event_ID == EV_InventoryUpdateItem)
	{
	//	AddSystemMessageString("EV_InventoryUpdateItem");
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeEnchantWnd") )	
		{
			UpdateAttInfo();	
			if (Int64ToInt(AttInfo.ItemNum) >=1) 
			{
				RequestUseItem(ScrollID);
	//			AddSystemMessageString("RequestUseItem");	
			}
			else
			{
	//			AddSystemMessageString("OnCancelClick");
				OnCancelClick();	
			}
		}
	}
}

function UpdateAttInfo()
{
	if (ihandle.GetItem(ihandle.FindItem(ScrollID), AttInfo)) 
	{
	//	AddSystemMessageString("GetItem");
		TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(ScrollID) @ "[" $ string(Int64ToInt(AttInfo.ItemNum)) $ "]");
		OnClickItem("ItemWnd", ItemIndex );
		ItemWnd.SetSelectedNum(ItemIndex);
	}
	if (!ihandle.GetItem(ihandle.FindItem(ScrollID), AttInfo))  OnCancelClick();	
}

function string UpdateTargetInfo()
{
//	if (ihandle.GetItem(ihandle.FindItem(SelectItemInfo.ID), TargetInfo)) 
//	{
	//	AddSystemMessageString("UpdateTargetInfo");
		if (SelectItemInfo.ItemType == 0)
			return  string(SelectItemInfo.AttackAttributeValue+5);
		else if (SelectItemInfo.ItemType == 1)
			return string(GetReverseAttValue( GetAttType(TextBox.GetText()))+6);	
//	}
}


//액션의 클릭
function OnClickItem( string strID, int index )
{	
	if (strID == "ItemWnd")
	{		
		OkButton.EnableWindow();
		//Button control (c) Merc
		if (isStone(TextBox.GetText()))
		{
			CrystalButton.DisableWindow();
			StoneButton.EnableWindow();
		}
		else
		{
			StoneButton.DisableWindow();
			CrystalButton.EnableWindow();
		}
		ItemWnd.GetItem(index, SelectItemInfo);
		ItemIndex = index;
		if (SelectItemInfo.ItemType == 0)
		{
			aValue.SetText("Att:" @ string(SelectItemInfo.AttackAttributeValue));	
		}
		else if (SelectItemInfo.ItemType == 1)
		{		
			aValue.SetText("Att:" @ string(GetReverseAttValue( GetAttType(TextBox.GetText()))));
		}	
	}
}

/*function OnSelectItemWithHandle( ItemWindowHandle a_hItemWindow, int a_Index )
{
	if (a_hItemWindow == ItemWnd)
	{
		ItemWnd.GetItem(index, SelectItemInfo);
		ItemIndex = index;
		sysDebug("GOOD");
	}
}*/



function int CalcAtt()
{
	local ItemWindowHandle ihandle;
	local int indexScroll;
	local ItemID itemIDScroll;
	local ItemInfo scrollInfo;
	
	ihandle = GetItemWindowHandle("InventoryWnd.InventoryItem");
	if (ScrollCID != 0)
		itemIDScroll = ScrollID;	
	else
		return 0;
	
	indexScroll = ihandle.Finditem(itemIDScroll);
	
	if (ihandle.GetItem(indexScroll, scrollInfo))
	{
		ScrollID.ClassID = scrollInfo.ID.ClassID;
		ScrollID.ServerID = scrollInfo.ID.ServerID;
		return Int64ToInt(scrollInfo.ItemNum);
	}
	else
		return 0;
	
}

function bool isStone(string attDescription)
{
	if (InStr( Caps(attDescription), Caps("Stone") ) > -1 )
		return true;
	else
		return false;
}

function string GetAttType(string attDescription)
{
	if (InStr( Caps(attDescription), Caps("Fire") ) > -1 )
		return "Fire";
	else if (InStr( Caps(attDescription), Caps("Water") ) > -1 )
		return "Water";
	else if (InStr( Caps(attDescription), Caps("Wind") ) > -1 )
		return "Wind";
	else if (InStr( Caps(attDescription), Caps("Earth") ) > -1 )
		return "Earth";
	else if (InStr( Caps(attDescription), Caps("Holy") ) > -1 )
		return "Holy";
	else if (InStr( Caps(attDescription), Caps("Dark") ) > -1 )
		return "Dark";
}

function int GetReverseAttValue(string attType)
{
	switch(attType)
	{
		case "Fire":
			return SelectItemInfo.DefenseAttributeValueWater;
		break;
		case "Water":
			return SelectItemInfo.DefenseAttributeValueFire;
		break;
		case "Wind":
			return SelectItemInfo.DefenseAttributeValueEarth;
		break;
		case "Earth":
			return SelectItemInfo.DefenseAttributeValueWind;
		break;
		case "Holy":
			return SelectItemInfo.DefenseAttributeValueUnholy;
		break;
		case "Dark":
			return SelectItemInfo.DefenseAttributeValueHoly;
		break;
	}
}

function string GetWeaponAttTypeByID(int attType)
{
	switch(attType)
	{
		case 0:
			return "Fire";
		break;
		case 1:
			return "Water";
		break;
		case 2:
			return "Wind";
		break;
		case 3:
			return "Earth";
		break;
		case 4:
			return "Holy";
		break;
		case 5:
			return "Dark";
		break;
	}
}

function StopAttInsert()
{
	Me.KillTimer(7778);
	StoneButton.EnableWindow();
	CrystalButton.EnableWindow();
	isAutomatic = false;
}

function InsertAttStone(int Value, int ValueOfWeapArmor, string nName)
{
	if (CalcAtt() >= 1 && Value < ValueOfWeapArmor)
	{
		RequestUseItem(ScrollID);
		ItemWnd.SetSelectedNum(ItemIndex);
		ItemWnd.GetItem(ItemIndex, SelectItemInfo);
		class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);
		Me.KillTimer(7778);
		Me.SetTimer(7778, 500);
	}
	else if (CalcAtt() < 1)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough " $ nName $ "!" );
		//HandleAttributeEnchantHide();
		return;
	}	
	else if (Value == ValueOfWeapArmor)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Maximum attribute with " $ nName $ "!" );
		//HandleAttributeEnchantHide();
		return;
	}
	else if (Value > ValueOfWeapArmor)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Use Crystals!" );
		//HandleAttributeEnchantHide();
		return;
	}
}

function InsertAttCrystal(int Value, int ValueOneOfWeapArmor, int ValueTwoOfWeapArmor, string nName)
{
	if (CalcAtt() >= 1 && Value >= ValueOneOfWeapArmor && Value < ValueTwoOfWeapArmor)
	{
		RequestUseItem(ScrollID);
		ItemWnd.SetSelectedNum(ItemIndex);
		ItemWnd.GetItem(ItemIndex, SelectItemInfo);
		class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);
		Me.KillTimer(7778);
		Me.SetTimer(7778, 500);
	}
	else if (CalcAtt() < 1)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough " $ nName $ "!" );
		//HandleAttributeEnchantHide();
		return;
	}	
	else if (Value == ValueTwoOfWeapArmor)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Maximum attribute with " $ nName $ "!" );
		//HandleAttributeEnchantHide();
		return;
	}
	else if (Value == 0)
	{
		StopAttInsert();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Use Stones first!" );
		//HandleAttributeEnchantHide();
		return;
	}
}

function StartAttInsert(string itemName)
{
	
	if (SelectItemInfo.ItemType == 0)
	{
		curAttValue = SelectItemInfo.AttackAttributeValue;
		
		aValue.SetText("Att:" @ string(SelectItemInfo.AttackAttributeValue));	
		
		if (isStone(TextBox.GetText()))
			InsertAttStone(curAttValue, 150, itemName);
		else
			InsertAttCrystal(curAttValue, 150, 300, itemName);
	}
	else if (SelectItemInfo.ItemType == 1)
	{
		curAttValue = GetReverseAttValue( GetAttType(TextBox.GetText()));
		
		aValue.SetText("Att:" @ string(GetReverseAttValue( GetAttType(TextBox.GetText()))));
		
		if (isStone(TextBox.GetText()))
			InsertAttStone(curAttValue, 60, itemName);
		else
			InsertAttCrystal(curAttValue, 60, 120, itemName);
	}
	else
		sysDebug("Not a weapon or armor!");
	
	
	isAutomatic = true;
}

function OnStone()
{
	if (IsStone(TextBox.GetText()))
	{
		StoneButton.DisableWindow();
		StartAttInsert("Stones");
	}
	else
		sysDebug("ERROR: NOT A STONE!");
	
}

function OnCrystal()
{
	if (!IsStone(TextBox.GetText()))
	{
		CrystalButton.DisableWindow();
		StartAttInsert("Crystals");
	}
	else
		sysDebug("ERROR: NOT A CRYSTAL!");
	
}

function OnTimer(int TimerID)
{
	if (TimerID == 7778)
	{
		Me.KillTimer(7778);
		if (IsStone(TextBox.GetText()))
			StartAttInsert("Stones");
		else
			StartAttInsert("Crystals");
	}
}

function OnClickButton( string strID )
{
	//debug("strID : " $ strID);
	switch( strID )
	{
	case "btnOK":
		OnOkClickProgress();
		break;
	case "btnCancel":
		OnCancelClick();
		break;
	case "btnStone":
		OnStone();
		break;
	case "btnCrystal":
		OnCrystal();
		break;
	}
}


function OnOkClickProgress()
{	
	//local ProgressBox script;
	
	// 선택한 아이템의 정보를 받아온다. 
	ItemWnd.GetSelectedItem(SelectItemInfo);	
	
	if(SelectItemInfo.ID.ClassID != 0)	// 선택된 아이템이 있을 경우만 진행
	{
		if(IsShowWindow("ItemEnchantWnd"))	//아이템 인첸트가 먼저 떠있다면 인챈트를 진행시키지 않는다. 
		{
			AddSystemMessage(2188);
		}
		// 밑의 이유 c++ 코드부분
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3속성이 다찼다
// };
		else if(SelectItemInfo.Reserved != 0) //인챈할수 없는 아이템이라면
		{
			if(SelectItemInfo.Reserved == 1)
				AddSystemMessage(3117);			
			if(SelectItemInfo.Reserved == 2)
				AddSystemMessage(3154);			
			if(SelectItemInfo.Reserved == 4)
				AddSystemMessage(3153);			
			if(SelectItemInfo.Reserved == 6)
				AddSystemMessage(3155);			
		}
		else
		{
			// 프로그레스 바를 띄워준다. 
			//Me.HideWindow();
			//script = ProgressBox( GetScript("ProgressBox") );	
			//script.Initialize();
			//script.ShowDialog(GetSystemString(1530), "AttributeEnchantWnd", 2000);	
			OnOKClick();
		}
	}
}

function OnOKClick()
{
	class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);
}

function OnCancelClick()
{
	local ItemID tempID;
	
	tempID = GetItemID(-1);
	//debug("request attribute cancle");
	class'EnchantAPI'.static.RequestEnchantItemAttribute(tempID);
	confExit = 1;
	Me.HideWindow();
	Clear();
}

function Clear()
{
	ItemWnd.Clear();
}

function HandleAttributeEnchantShow(string param)
{
	local ItemID cID;
	//branch
	local WindowHandle m_WarehouseWnd;
	local WindowHandle m_DeliverWnd;

	m_WarehouseWnd = GetWindowHandle( "WarehouseWnd" );	//창고의 윈도우 핸들을 얻어온다.
	m_DeliverWnd = GetWindowHandle( "DeliverWnd" );

	if ( m_WarehouseWnd.IsShowWindow() || m_DeliverWnd.IsShowWindow() )			//창고 오픈시 활성화 안한다.
	{
		cID = GetItemID(-1);
		class'EnchantAPI'.static.RequestEnchantItemAttribute(cID);
		Clear();
	} 
	else
	{
	//end of branch
	
		Clear();
		ParseItemID(param, cID);
	 
		//debug("show doing ");
	
		// 과거에는 주문서 종류를 윈도우 타이틀에 표현해 주었으나, 앞으로는 윈도우 내부에 표시해주도록 한다. 
		//Me.SetWindowTitle(GetSystemString(1220) $ "(" $ class'UIDATA_ITEM'.static.GetItemName(cID) $ ")");
		ScrollCID = cID.ClassID;				// 스크롤 아이디 저장
		ScrollID.ClassID = cID.ClassID;
		ScrollID.ServerID = cID.ServerID;
		TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(cID) @ "[" $ CalcAtt() $ "]");
		OkButton.DisableWindow();				// 처음 뿌려줄 때는 아이템을 선택하지 않았기 때문에 무조건 확인 버튼을 disable 시켜준다. 
		Me.ShowWindow();
		Me.SetFocus();
		//Button control (c) Merc
		CrystalButton.DisableWindow();
		StoneButton.DisableWindow();

			
	//branch
	}
	//end of branch	
}

function HandleAttributeEnchantHide()
{
	Me.HideWindow();
	Clear();
}

// 밑의 이유 c++ 코드부분
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3속성이 다찼다
// };

function HandleAttributeEnchantItemList(string param)
{
	local ItemInfo infItem;
	local int Ispossible;
	ParseInt(param, "Ispossible", Ispossible);
	ParamToItemInfo(param, infItem);
	infItem.Reserved = Ispossible;
	//debug(string(Ispossible));
	//debug("Name :" $ infItem.Name $ " SlotBitType: "  $ infItem.SlotBitType $ " ShieldDefense : " $ infItem.ShieldDefense $ " CrystalType :"  $infItem.CrystalType);
	
	// item 정보로 판단하여 사용 가능한 아이템만 insert 한다.  - 친절한 UI정책 ^^ - innowind 
	// S급 이상의 무기/ 방어구만 속성 인챈트 가능
	
	//ItemWnd.AddItem(infItem);	// 서버에서 알아서 걸러주는것 같으니 아래 코드는 필요 없다.
	
	//S급 이상의 아이템만 추가. S80을 위해 부등호를 사용하였다. 
	//방패는 제외한다. 방패도 itemType이 1로 들어오기 때문에 shieldDefense 변수를 사용.
	confExit = 0;
	if((infItem.CrystalType > 4) && (infItem.ShieldDefense == 0) && (infItem.SlotBitType != 268435456) && (infItem.ArmorType != 4) && (infItem.SlotBitType != 1))
	{
		if(Ispossible == 0) //ATTR_ENCHAN_POSSIBLE
			ItemWnd.AddItem(infItem);
		else
			ItemWnd.AddItemWithFaded(infItem); //Removed adding noneed items (c) Merc
	}
	if (ItemIndex!=-1) 
	{
		//	AddSystemMessageString("123" @ ItemIndex);
		OnClickItem("ItemWnd", ItemIndex );
		ItemWnd.SetSelectedNum(ItemIndex);
	}	
}



function HandleAttributeEnchantResult(string param)
{
	//debug("Result param : " $ param);
	//결과에 상관없이 무조건 Hide
//	AddSystemMessageString("HandleAttributeEnchantResult");
	if ((Int64ToInt(AttInfo.ItemNum) >=1) && (param!="Result=2") && (confExit == 0))
	{
//		AddSystemMessageString("Result param 3: " $ param);
		RequestUseItem(ScrollID);
	}
//	if (!isAutomatic)
//	{
//		Me.HideWindow();
//		Clear();
//	}
		
}
defaultproperties
{
}
