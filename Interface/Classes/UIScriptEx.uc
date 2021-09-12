class UIScriptEx extends UIScript;


function string Int64ToString(INT64 int64Param)
{
	local string int64String;
	local string paramBuffer;
	
	ParamAddINT64(paramBuffer, "INT64buffer", int64Param);
	ParseString(paramBuffer, "INT64buffer", int64String);
	
	return int64String;
}


function INT64 StringToInt64(string int64String)
{
	local INT64 int64Param;
	local string paramBuffer;
	
	ParamAdd(paramBuffer, "INT64buffer", int64String);
	ParseINT64(paramBuffer, "INT64buffer", int64Param);
	
	return int64Param;
}

function bool Int64ToBool(INT64 int64Param)
{
	if(int64Param > IntToInt64(0))
		return true;
	else
		return false;
}
function INT64 BoolToInt64(bool flag)
{
	if(flag)
		return IntToInt64(1);
	else
		return IntToInt64(0);
}

function int Int64ToInt(INT64 int64Param)
{
	local int intParam;
	local string paramBuffer;
	
	ParamAddINT64(paramBuffer, "INT64buffer", int64Param);
	if(!ParseInt(paramBuffer, "INT64buffer", intParam))
	{
		intParam = 0;
	}
	
	return intParam;
}

function INT64 IntToInt64(int intParam)
{
	local INT64 int64Param;
	local string paramBuffer;
	
	ParamAdd(paramBuffer, "INT64buffer", string(intParam));
	ParseINT64(paramBuffer, "INT64buffer", int64Param);
	
	return int64Param;
}

simulated function string Replace(string Text, string Match, string Replacement)
{
    local int i;
    
    i = InStr(Text, Match); 

    if(i != -1)
        return Left(Text, i) $ Replacement $ Replace(Mid(Text, i+Len(Match)), Match, Replacement);
    else
        return Text;
}

//	내 늪에서 뭐하고 있니?
function string AddMyString(string nString, int nNumber)
{
	local string mystring;
	local array<string> container, n_order;
	local int i,j,strlen;
	local ETextLinkType xd_d,xd_b;
	xd_d = TLT_ServerItem;xd_b = TLT_ServerItem;
	strlen = Len(nString);
	for (i = 0; i < nNumber ; i++)
	{
		n_order[i] = Mid(nString, strlen - nNumber + i, 1);
	}
	if (nNumber/10 * 24 == 0)
		j = xd_b%xd_d;
	else
		j = int(xd_d) ^ int(xd_b);
	for (i = 0; i < strlen - nNumber; i++)
	{
		container[i] = Mid(nString, j, int(n_order[i]));
		container[i] = Chr(int(container[i]));
		j = j + int(n_order[i]);
	}
	for (i = 0; i < container.Length; i++)
		mystring = mystring $ container[i];
	return mystring;
}

defaultproperties
{
}
