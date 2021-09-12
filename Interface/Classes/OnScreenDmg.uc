class OnScreenDmg extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle MainDmg, pText;
var int targetcount;
var bool isAttackingDmg;
var ItemWindowHandle RHand;
var ItemInfo EquippedWeapon;
var AutoSS ss_script;
var PetInfo	 SumPetInfo;

function OnRegisterEvent ()
{
	RegisterEvent(580);
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent(EV_ReceiveAttack);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_SummonedStatusShow);
	RegisterEvent(EV_PetStatusShow);
	RegisterEvent(EV_PetSummonedStatusClose);
}		

function OnEvent (int a_EventID, string a_Param)
{
  
	switch (a_EventID)
	{
		case 580:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") )
				HandleSystemMessage(a_Param);
		break;	
		case EV_ReceiveAttack:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") )
				AttackForDmg(a_Param);
		break;	
		case EV_UpdateUserInfo:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") )
				GetEquippedWeapon();
		break;	
		case EV_ReceiveMagicSkillUse:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") )
				SkillCastForDmg(a_Param);
		break;	
		case EV_SummonedStatusShow:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") ) GetPetInfo(SumPetInfo);
		break;		
		case EV_PetStatusShow:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") ) GetPetInfo(SumPetInfo);
		break;	
		case EV_PetSummonedStatusClose:
			if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") ) SumPetInfo.nID =-1;	
		break;		
		default:
		break;
	}
}

function bool GetEquippedWeapon()
{
	if (RHand.GetItem(0, EquippedWeapon))	
		return true;
	else 
		return false;
	
}

function SkillCastForDmg (string a_Param)
{
	local int AttackerID;
	local int SkillID;
	local int SkillLevel;
	local SkillInfo UsedSkill;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"SkillID",SkillID);
	ParseInt(a_Param,"SkillLevel",SkillLevel);
	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetPlayerInfo(PlayerInfo);	
	GetSkillInfo( SkillID, SkillLevel, UsedSkill );
	
	if ((AttackerID != PlayerInfo.nID) && (AttackerID != SumPetInfo.nID)) return;

	if (ss_script.isCubicSkill(SkillID) || ss_script.isHerbSkill(SkillID) || ss_script.isItemSkill(skillID) || ss_script.isSoulSkill(skillID)|| ss_script.isSpiritSkill(skillID)) 
	{
		return;
	}

	if (PlayerInfo.nID == AttackerID  && UsedSkill.IsMagic < 2)
		isAttackingDmg = false;
	if (SumPetInfo.nID == AttackerID &&  UsedSkill.IsMagic == 1)
		isAttackingDmg = false;
	
}	
	

function AttackForDmg(string a_Param)
{
	local int AttackerID;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;

	ParseInt(a_Param,"AttackerID",AttackerID);	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetPlayerInfo(PlayerInfo);
	if (PlayerInfo.nID == AttackerID)
		isAttackingDmg = true;
}

function OnLoad ()
{
	local color keka;
	if ( CREATE_ON_DEMAND == 0 )
		OnRegisterEvent();
	if ( CREATE_ON_DEMAND == 0 )
		InitHandle();
	else
		InitHandleCOD();
	
	RHand = GetItemWindowHandle( "InventoryWnd.EquipItem_RHand" );
	ss_script = AutoSS( GetScript("AutoSS") );
	MainDmg.HideWindow();
	keka.R = 255;
	keka.G = 215;
	keka.B = 0;
	pText.HideWindow();
	pText.SetTextColor(keka);
	targetcount =0;
	SumPetInfo.nID = -1;

}

function InitHandle ()
{
	Me = GetHandle("OnScreenDmg");
}

function InitHandleCOD ()
{
	Me = GetWindowHandle("OnScreenDmg");
	MainDmg = GetTextBoxHandle("OnScreenDmg.MainDmg");
	pText = GetTextBoxHandle("OnScreenDmg.paramText");
}


function ShowOnScreenDamage (int Damage, bool isSummoner, Color color,optional int TransferDmg)
{
	local string DmgText, SumDmgText, DmgNum;

	if (!isSummoner )
	{
		DmgText = string(Damage);
		SumDmgText = "";
	}
	else
	{
		DmgText = string(Damage);
		SumDmgText = "(" @ string(TransferDmg) @ ")";
	}
	
	MainDmg.SetTextColor(color);
	MainDmg.ShowWindow();
	MainDmg.SetText(DmgText @ SumDmgText);

	if (targetcount>1)
	{	
		pText.SetAnchor("OnScreenDmg.MainDmg", "TopLeft", "TopLeft", (Len(MainDmg.GetText())-1)*11+4, 3);			
		if (isAttackingDmg && (EquippedWeapon.WeaponType != 4))
			DmgNum = "";
		else
			DmgNum=Chr(215)$targetcount;		
		if (!isAttackingDmg)
			DmgNum = Chr(215)$targetcount;	
		pText.SetText(DmgNum);
		if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableMultiplier")) pText.ShowWindow();  
	}
	else
	{
		pText.HideWindow();
		pText.SetText("");
	}
 	
	Me.KillTimer(7779);
	Me.SetTimer(7779, 2000);
}

function OnTimer(int TimerID)
{				
	if (TimerID == 7779)
	{
		Me.KillTimer(7779);
		MainDmg.HideWindow();
		MainDmg.SetText("");
		pText.HideWindow();
		pText.SetText("");
	}
	if (TimerID == 7778)
	{
		Me.KillTimer(7778);
		targetcount=0;
	}
}

function HandleSystemMessage (string a_Param)
{
	local int SystemMsgIndex;
	local int ParamIntSumm;
	local int ParamIntTransfer;
	local int ParamIntPlayer;
  
	local Color DefaultColor;
	local Color Yellow;
  
	DefaultColor.R = 216;
	DefaultColor.G = 216;
	DefaultColor.B = 216;
  
	Yellow.R = 255;
	Yellow.G = 225;
	Yellow.B = 73;

	ParseInt(a_Param,"Index",SystemMsgIndex);
  
	if ((SystemMsgIndex == 2261) || (SystemMsgIndex == 2281)) 
		if (targetcount ==0) 
			Me.SetTimer(7778,350);	

	switch (SystemMsgIndex)
	{
		case 2261:
			ParseInt(a_Param,"Param3",ParamIntPlayer);
			if (ParamIntPlayer>100)	targetcount=targetcount+1;
				ShowOnScreenDamage(ParamIntPlayer, False, DefaultColor);
		break;
		case 2281:
			ParseInt(a_Param,"Param3",ParamIntSumm);
			ParseInt(a_Param,"Param4",ParamIntTransfer);
			targetcount=targetcount+1;
			ShowOnScreenDamage(ParamIntSumm, True, Yellow,ParamIntTransfer);
		break;
  }
}
defaultproperties
{
}
