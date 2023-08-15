include("GameCapabilities");

DebugON = true
-- 回合计数器
function TurnCounter()
    -- 获取当前回合数，if回合数能被5整除
    if (Game.GetCurrentGameTurn() ~= nil and Game.GetCurrentGameTurn() % 5 == 0 ) then
        if DebugON then print("Turn " .. Game.GetCurrentGameTurn()) end
        --遍历玩家，如果发现玩家具备“伟大的占星术士”特性，则将其加入MonaIDs表，且使OtherPlayers表从AlivePlayers表中获取数据时排除。
        AlivePlayers = PlayerManager.GetAliveMajorIDs()
        MonaIDs, OtherPlayers = {}, AlivePlayers
        if DebugON then print("AlivePlayers: " .. table.concat(AlivePlayers, ",")) end
        for i, playerID in pairs(AlivePlayers) do
            if (HasTrait("TRAIT_GREAT_ASTROLOGIST", playerID)) then
                table.insert(MonaIDs, playerID)
                table.remove(OtherPlayers, i)
            end
        end
        if DebugON then print("Found Mona PlayerID: " .. table.concat(MonaIDs, ",")) end
        MonaTradeScience(MonaIDs, OtherPlayers)
    end
end

-- 钱换瓶
function MonaTradeScience(MonaIDs, OtherPlayers)
    for i, playerID in pairs(MonaIDs) do
        local pPlayer = Players[playerID]
        if pPlayer ~= nil then
        -- 获取金币余额并计算转换的科技值
        TradingGold = pPlayer:GetTreasury():GetGoldBalance() * 0.9
        TradingScience = TradingGold / 2
        -- 转科技和钱
        pPlayer:GetTechs():ChangeCurrentResearchProgress(TradingScience)
        pPlayer:GetTreasury():ChangeGoldBalance(0 - TradingGold)
        if DebugON then print("Player " .. playerID .. " is trading " .. TradingScience .. " Science to " .. TradingGold .. " Gold") end
        MonaFindHighestSciencePlayer(OtherPlayers, TradingGold)
        -- 获取首都坐标
        pCapital = pPlayer:GetCities():GetCapitalCity()
        CapitalPlotX = pCapital:GetX()
        CapitalPlotY = pCapital:GetY()
        -- 首都上方显示飘字
        Game.AddWorldViewText(0, '[COLOR_FLOAT_GOLD]' .. string.format("%.1f", TradingGold) .. GameInfo.Yields['YIELD_GOLD'].IconString .. '[ENDCOLOR]' .. '[ICON_GoingTo]'.. '[COLOR_FLOAT_SCIENCE]' ..  string.format("%.1f", TradingScience) .. GameInfo.Yields['YIELD_SCIENCE'].IconString .. '[ENDCOLOR]' , CapitalPlotX, CapitalPlotY)
        end
    end
end

--寻找场上除自身以外科技值最高的玩家
function MonaFindHighestSciencePlayer(OtherPlayers, TradingGold)
    if OtherPlayers == nil then print("No OtherPlayers found! MonaIDs:" .. table.concat(MonaIDs, ",")) return end
    --获取OtherPlayers表中所有playerID所对应的科技值及其索引值
    local PlayersScience = {}
    for i, playerID in pairs(OtherPlayers) do PlayersScience[#OtherPlayers] = Players[playerID]:GetTechs():GetScienceYield() end
    --计算最大值对应的PlayerID
    maxSciencePlayerID = Getmaxnum(PlayersScience)
    Players[maxSciencePlayerID]:GetTreasury():ChangeGoldBalance(TradingGold)
    if DebugON then print("Sending " .. TradingGold .. " Gold to Player " .. maxSciencePlayerID) end
end

-- 研究返点
function MonaResearchReward(ePlayer, eTech)
    -- 检查完成研究eTech的玩家是否具备“伟大的占星术士”特性
    if (not HasTrait("TRAIT_GREAT_ASTROLOGIST", ePlayer)) then
    else
    -- 获取完成研究eTech所消耗的科技点，计算返点金额
    local pPlayer = Players[ePlayer]
    RewardGold = pPlayer:GetTechs():GetResearchCost(eTech) / 2
    -- 返点到账
    pPlayer:GetTreasury():ChangeGoldBalance(RewardGold)
    -- 获取首都坐标
    pCapital = pPlayer:GetCities():GetCapitalCity()
    CapitalPlotX = pCapital:GetX()
    CapitalPlotY = pCapital:GetY()
    -- 首都上方显示飘字
    Game.AddWorldViewText(0, '[COLOR_FLOAT_GOLD]' .. '+' .. string.format("%.1f", RewardGold) .. GameInfo.Yields['YIELD_GOLD'].IconString .. '[ENDCOLOR]', CapitalPlotX, CapitalPlotY)
    local sTitle = "LOC_NOTIFICATION_MONA_RESEARCHREWARD_TITLE"
    local sString = ("LOC_NOTIFICATION_MONA_RESEARCHREWARD_STRING_1" .. string.format("%.1f", RewardGold) .. GameInfo.Yields['YIELD_GOLD'].IconString .. "LOC_NOTIFICATION_MONA_RESEARCHREWARD_STRING_2")
    local notificationData = {};
    notificationData[ParameterTypes.MESSAGE] = sTitle;
    notificationData[ParameterTypes.SUMMARY] = sString;
    if(CapitalPlotX ~= nil) then
        notificationData [ParameterTypes.LOCATION] = { x = CapitalPlotX, y = CapitalPlotY};
    end
    notificationData.AlwaysAutoActivate = true;
    notificationData.AlwaysUnique = true;
    --notificationData.ShowIcon = false;
    NotificationManager.SendNotification(ePlayer, ResearchRewardNotification, notificationData)
    end
end

function Getmaxnum(a)
    local mi = 1             -- maximum index
    local m = a[mi]          -- maximum value
    for i,val in ipairs(a) do
       if val > m then
           mi = i
           m = val
       end
    end
    return mi
end

Events.TurnBegin.Add(TurnCounter)
Events.ResearchCompleted.Add(MonaResearchReward)