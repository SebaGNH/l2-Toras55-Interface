class AdenaInfoWnd extends UICommonAPI;

var WindowHandle Me;

var TextureHandle AdenaInfoTexture;
var	TextBoxHandle AdenaInfoT;
var INT64 AdenaSum,ExpSum;
var float exp,expprev, expstart, expshow, percentexp;
var int startLvl,currentLvl, counttimer;
var CustomTooltip TooltipAdena;
var array<INT64> adenatimer, exptimer;
var bool isFirst;

function OnRegisterEvent()
{
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_SystemMessage );
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_GamingStateEnter);
}

function OnLoad()
{	
	InitHandles();

}

function OnEnterState( name a_PreStateName )
{		
	expstart = -1;
}

function InitHandles()
{
	Me = GetWindowHandle("AdenaInfoWnd");
	AdenaInfoTexture =  GetTextureHandle( "AdenaInfoWnd.AdenaInfoTex" );
	AdenaInfoT = GetTextBoxHandle( "AdenaInfoWnd.AdenaInfoText" );
}

function OnEvent(int EventID, string param)
{
	local UserInfo	info;
	local int i;
	switch (EventID)
	{
		case EV_GamingStateEnter:
			
			Me.ShowWindow();
			isFirst = true;
			counttimer = 0;
			percentexp = 0;
			for (i=0; i<40;++i)
			{
				exptimer[i]=IntToInt64(0);
			}
			AdenaSum = IntToInt64(0);
			ExpSum = IntToInt64(0);
			Me.SetTimer(1120,50);
		break;
		
		case EV_UpdateUserInfo:	
			GetPlayerInfo(info);		
			currentLvl = info.nLevel;						 
			if  (expstart == -1) 
			{	 
				expstart = class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
				startLvl = info.nLevel;	
				expprev = expstart;
			}
			exp = class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
			expshow = exp - expstart;
			AdenaInfoT.SetText(MakeCostString(Int64ToString(GetAdena())));
			
		break;	
		case EV_SystemMessage:
			HandleSystemmsg(param);	
		break;
		case EV_Restart:	
			Me.KillTimer(1120);
			AdenaSum = IntToInt64(0);
			ExpSum = IntToInt64(0);		
			expshow = 0;
			expstart = -1;
		break;		
	}
}


function OnTimer(int TimerID)
{
	local int a,b; 
	if (TimerID == 1120)
	{
		exptimer[counttimer]=ExpSum;
		adenatimer[counttimer]=AdenaSum;	
		Me.KillTimer(1120);				
		counttimer=counttimer+1;
		if (counttimer==40) {counttimer=0; isFirst = false;}
		Me.SetTimer(1120,15000);		
		if (counttimer == 0) {a = 39; b = 38;}
		if (counttimer == 1) {a = 0; b = 39;} 
		if ((counttimer!=0) && (counttimer!=1)) {a = counttimer-1; b = counttimer-2;}		
		
		if ((exp>expprev) && (exptimer[a]>IntToInt64(0)) && (exptimer[b]>IntToInt64(0)))
		{						
			percentexp = (INT64toInt((exptimer[a] - exptimer[b]) ) /  (exp - expprev))/100; // 0,01
		}
		expprev = exp;
		InitAdenaInfoTooltip();
	}

}

function InitAdenaInfoTooltip()
{
	
	
	TooltipAdena.DrawList.length = 14;

	TooltipAdena.DrawList[0].eType = DIT_TEXTURE;
	TooltipAdena.DrawList[0].nOffSetY = 5;
	TooltipAdena.DrawList[0].u_nTextureWidth = 18;
	TooltipAdena.DrawList[0].u_nTextureHeight = 13;
	TooltipAdena.DrawList[0].u_strTexture = "L2UI_CT1.Icon_DF_Common_Adena";
	
	TooltipAdena.DrawList[1].eType = DIT_TEXT;
	TooltipAdena.DrawList[1].nOffSetX = 20;
	TooltipAdena.DrawList[1].t_bDrawOneLine = true;
	TooltipAdena.DrawList[1].nOffSetY = 6;
	TooltipAdena.DrawList[1].t_color.R = 163;
	TooltipAdena.DrawList[1].t_color.G = 163;
	TooltipAdena.DrawList[1].t_color.B = 163;
	TooltipAdena.DrawList[1].t_color.A = 255;
	TooltipAdena.DrawList[1].t_strText = "all:";	
														
	TooltipAdena.DrawList[2].eType = DIT_TEXT;
	TooltipAdena.DrawList[2].nOffSetX = 10;
	TooltipAdena.DrawList[2].t_bDrawOneLine = true;
	TooltipAdena.DrawList[2].nOffSetY = 6;
	TooltipAdena.DrawList[2].t_strText = MakeCostString( Int64ToString(AdenaSum));		
		
	TooltipAdena.DrawList[3].eType = DIT_TEXT;
	TooltipAdena.DrawList[3].t_bDrawOneLine = true;
	TooltipAdena.DrawList[3].nOffSetY = 6;
	TooltipAdena.DrawList[3].t_strText ="  ";	
			
	TooltipAdena.DrawList[4].eType = DIT_TEXT;
	TooltipAdena.DrawList[4].bLineBreak = true;
	TooltipAdena.DrawList[4].nOffSetX = 13;
	TooltipAdena.DrawList[4].t_bDrawOneLine = true;
	TooltipAdena.DrawList[4].nOffSetY = 1;
	TooltipAdena.DrawList[4].t_color.R = 163;
	TooltipAdena.DrawList[4].t_color.G = 163;
	TooltipAdena.DrawList[4].t_color.B = 163;
	TooltipAdena.DrawList[4].t_color.A = 255;
	TooltipAdena.DrawList[4].t_strText = "10 min:";	
															
	TooltipAdena.DrawList[5].eType = DIT_TEXT;
	TooltipAdena.DrawList[5].t_bDrawOneLine = true;
	TooltipAdena.DrawList[5].nOffSetY = 1;
	TooltipAdena.DrawList[5].nOffSetX = 10;
	if (isFirst) 
	{
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString(adenatimer[39]));
		}
		else
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString(adenatimer[counttimer-1]));
		}	
	}
	else 
	{
		if (counttimer == 0) 
		{	
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString((adenatimer[39]) - adenatimer[counttimer] ));
		}
		else 
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString((adenatimer[counttimer-1]) - adenatimer[counttimer] ));
		}
	
	}
	
	TooltipAdena.DrawList[6].eType = DIT_TEXTURE;
	TooltipAdena.DrawList[6].bLineBreak = true;
	TooltipAdena.DrawList[6].nOffSetY = 5;
	TooltipAdena.DrawList[6].nOffSetX = 2;
	TooltipAdena.DrawList[6].u_nTextureWidth = 14;
	TooltipAdena.DrawList[6].u_nTextureHeight = 14;
	TooltipAdena.DrawList[6].u_nTextureUWidth = 32;
	TooltipAdena.DrawList[6].u_nTextureUHeight = 32;
	TooltipAdena.DrawList[6].u_strTexture = "br_cashtex.item.br_cash_rune_of_exp_i00";
		
	TooltipAdena.DrawList[7].eType = DIT_TEXT;
	TooltipAdena.DrawList[7].nOffSetX = 22;
	TooltipAdena.DrawList[7].t_bDrawOneLine = true;
	TooltipAdena.DrawList[7].nOffSetY = 6;
	TooltipAdena.DrawList[7].t_color.R = 163;
	TooltipAdena.DrawList[7].t_color.G = 163;
	TooltipAdena.DrawList[7].t_color.B = 163;
	TooltipAdena.DrawList[7].t_color.A = 255;
	TooltipAdena.DrawList[7].t_strText = "all:";	
			
	TooltipAdena.DrawList[8].eType = DIT_TEXT;
	TooltipAdena.DrawList[8].nOffSetX = 10;
	TooltipAdena.DrawList[8].nOffSetY = 6;
	TooltipAdena.DrawList[8].t_bDrawOneLine = true;
	TooltipAdena.DrawList[8].t_strText = MakeCostString( Int64ToString(ExpSum));
	
	if ((expshow != 0) && (startLvl == currentLvl))
	{			
		TooltipAdena.DrawList[9].eType = DIT_TEXT;
		TooltipAdena.DrawList[9].t_bDrawOneLine = true;
		TooltipAdena.DrawList[9].nOffSetX = 2;
		TooltipAdena.DrawList[9].nOffSetY = 6;
		TooltipAdena.DrawList[9].t_color.R = 163;
		TooltipAdena.DrawList[9].t_color.G = 163;
		TooltipAdena.DrawList[9].t_color.B = 163;
		TooltipAdena.DrawList[9].t_color.A = 255;
		TooltipAdena.DrawList[9].t_strText = "  (" $ string(expshow) $ "%)";
	}
	else
	{
		TooltipAdena.DrawList[9].eType = DIT_TEXT;
		TooltipAdena.DrawList[9].t_bDrawOneLine = true;
		TooltipAdena.DrawList[9].nOffSetY = 6;
		TooltipAdena.DrawList[9].t_strText ="  ";
	}


	
	if ((startLvl < currentLvl) && (expstart !=0) ) 
	{
		TooltipAdena.DrawList[10].eType = DIT_TEXT;
		TooltipAdena.DrawList[10].t_bDrawOneLine = true;
		TooltipAdena.DrawList[10].t_color.R = 163;
		TooltipAdena.DrawList[10].t_color.G = 163;
		TooltipAdena.DrawList[10].t_color.B = 163;
		TooltipAdena.DrawList[10].t_color.A = 255;
		TooltipAdena.DrawList[10].nOffSetY = 6;
		TooltipAdena.DrawList[10].t_strText = string(startLvl) $ "(" $ string(expstart) $ "%)  ";
	}
	else
	{
		TooltipAdena.DrawList[10].nOffSetY = 6;
		TooltipAdena.DrawList[10].t_strText ="";
	}
	
	TooltipAdena.DrawList[11].eType = DIT_TEXT;
	TooltipAdena.DrawList[11].bLineBreak = true;
	TooltipAdena.DrawList[11].nOffSetX = 13;
	TooltipAdena.DrawList[11].t_bDrawOneLine = true;
	TooltipAdena.DrawList[11].t_color.R = 163;
	TooltipAdena.DrawList[11].t_color.G = 163;
	TooltipAdena.DrawList[11].t_color.B = 163;
	TooltipAdena.DrawList[11].t_color.A = 255;
	TooltipAdena.DrawList[11].t_strText = "10 min:";	
	
	TooltipAdena.DrawList[12].eType = DIT_TEXT;
	TooltipAdena.DrawList[12].t_bDrawOneLine = true;
	TooltipAdena.DrawList[12].nOffSetX = 10;
	
	if (isFirst) 
	{
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString(exptimer[39]));
		}
		else
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString(exptimer[counttimer-1]));
		}	
	}
	else 
	{
		if (counttimer == 0) 
		{	
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString((exptimer[39]) - exptimer[counttimer] ));
		}
		else 
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString((exptimer[counttimer-1]) - exptimer[counttimer] ));
		}
	
	}
	
	if (percentexp>0)
	{	
		TooltipAdena.DrawList[13].eType = DIT_TEXT;
		TooltipAdena.DrawList[13].t_bDrawOneLine = true;
		TooltipAdena.DrawList[13].nOffSetX = 10;
		TooltipAdena.DrawList[13].t_color.R = 163;
		TooltipAdena.DrawList[13].t_color.G = 163;
		TooltipAdena.DrawList[13].t_color.B = 163;
		TooltipAdena.DrawList[13].t_color.A = 255;
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[13].t_strText = "(" $string(( (Int64ToInt(exptimer[39] - exptimer[counttimer]) / percentexp) / 100)) $"%)";
		}
		else
		{
			TooltipAdena.DrawList[13].t_strText = "(" $string(( (Int64ToInt(exptimer[counttimer-1] - exptimer[counttimer]) / percentexp) / 100)) $"%)";
		}
	}
	else
	{
		TooltipAdena.DrawList[13].t_strText = "";
	}

	AdenaInfoT.SetTooltipCustomType(TooltipAdena);
}

function HandleSystemmsg(string param) 
{
	local int i;
    local int msg_idx;
    local int adenadrop;
	local int expgain;
	
	ParseInt(param, "Index", msg_idx);
	
	if ( msg_idx == 28 || msg_idx == 52) // loot adena
	{
	ParseInt(param, "Param1", adenadrop);
	AdenaSum = AdenaSum + IntToInt64(adenadrop);
	}
	
	if ( msg_idx == 3259) // exp
	{
		
	ParseInt(param, "Param1", expgain);
	ExpSum = ExpSum + IntToInt64(expgain);		
	}
	
	if (( msg_idx == 1269) || ( msg_idx == 1270)) // sub
	{
		expstart = -1;	
		AdenaSum = IntToInt64(0);
		ExpSum = IntToInt64(0);		
		isFirst = true;
		counttimer = 0;
		percentexp = 0;
		for (i=0; i<40;++i)
		{
			exptimer[i]=IntToInt64(0);
			adenatimer[i]=IntToInt64(0);
		}
	}

}













defaultproperties
{
}
