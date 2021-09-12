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

// ���� ���
var ItemInfo AttInfo;
var ItemInfo SelectItemInfo, TargetInfo;		// ������ ������
var int ScrollCID;			// ��ũ���� ������ �����Ѵ�. 
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
		// �Ӽ� ���� â�� ���������� �Ӽ� ��þƮ�� ���ϰ� ���´�.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd") )	
		{	
			// �� �Ӽ� ��þƮ�� â�� �������� �ȳ�
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


//�׼��� Ŭ��
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
	
	// ������ �������� ������ �޾ƿ´�. 
	ItemWnd.GetSelectedItem(SelectItemInfo);	
	
	if(SelectItemInfo.ID.ClassID != 0)	// ���õ� �������� ���� ��츸 ����
	{
		if(IsShowWindow("ItemEnchantWnd"))	//������ ��þƮ�� ���� ���ִٸ� ��æƮ�� �����Ű�� �ʴ´�. 
		{
			AddSystemMessage(2188);
		}
		// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
// };
		else if(SelectItemInfo.Reserved != 0) //��æ�Ҽ� ���� �������̶��
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
			// ���α׷��� �ٸ� ����ش�. 
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

	m_WarehouseWnd = GetWindowHandle( "WarehouseWnd" );	//â���� ������ �ڵ��� ���´�.
	m_DeliverWnd = GetWindowHandle( "DeliverWnd" );

	if ( m_WarehouseWnd.IsShowWindow() || m_DeliverWnd.IsShowWindow() )			//â�� ���½� Ȱ��ȭ ���Ѵ�.
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
	
		// ���ſ��� �ֹ��� ������ ������ Ÿ��Ʋ�� ǥ���� �־�����, �����δ� ������ ���ο� ǥ�����ֵ��� �Ѵ�. 
		//Me.SetWindowTitle(GetSystemString(1220) $ "(" $ class'UIDATA_ITEM'.static.GetItemName(cID) $ ")");
		ScrollCID = cID.ClassID;				// ��ũ�� ���̵� ����
		ScrollID.ClassID = cID.ClassID;
		ScrollID.ServerID = cID.ServerID;
		TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(cID) @ "[" $ CalcAtt() $ "]");
		OkButton.DisableWindow();				// ó�� �ѷ��� ���� �������� �������� �ʾұ� ������ ������ Ȯ�� ��ư�� disable �����ش�. 
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

// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
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
	
	// item ������ �Ǵ��Ͽ� ��� ������ �����۸� insert �Ѵ�.  - ģ���� UI��å ^^ - innowind 
	// S�� �̻��� ����/ ���� �Ӽ� ��æƮ ����
	
	//ItemWnd.AddItem(infItem);	// �������� �˾Ƽ� �ɷ��ִ°� ������ �Ʒ� �ڵ�� �ʿ� ����.
	
	//S�� �̻��� �����۸� �߰�. S80�� ���� �ε�ȣ�� ����Ͽ���. 
	//���д� �����Ѵ�. ���е� itemType�� 1�� ������ ������ shieldDefense ������ ���.
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
	//����� ������� ������ Hide
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
