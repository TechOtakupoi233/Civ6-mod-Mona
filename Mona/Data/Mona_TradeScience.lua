include("GameCapabilities");
-- 回合计数器
function TurnCounter()
    -- 获取当前回合数，if回合数能被5整除
    if (Game.GetCurrentGameTurn() ~= nil and Game.GetCurrentGameTurn() % 5 == 0 ) then
        MonaTradeScience()
    end
end
-- 钱换瓶
function MonaTradeScience()
    -- 检查玩家是否具备“伟大的占星术士”特性
    for playerID = 0, GameDefines.MAX_PLAYERS-1, 1 do
    if (not HasTrait("TRAIT_GREAT_ASTROLOGIST", playerID)) then return; end
        local pPlayer = Players[playerID]
        if pPlayer ~= nil then
        -- 获取金币余额并计算转换的科技值
        TradingGold = pPlayer:GetTreasury():GetGoldBalance() * 0.9
        TradingScience = TradingGold / 2
        -- 转科技和钱
        pPlayer:GetTechs():ChangeCurrentResearchProgress(TradingScience)
        pPlayer:GetTreasury():ChangeGoldBalance(0 - TradingGold)
        -- 获取首都坐标
        pCapital = pPlayer:GetCities():GetCapitalCity()
        CapitalPlotX = pCapital:GetX()
        CapitalPlotY = pCapital:GetY()
        -- 首都上方显示飘字
        Game.AddWorldViewText(0, '[COLOR_FLOAT_GOLD]' .. string.format("%.1f", TradingGold) .. GameInfo.Yields['YIELD_GOLD'].IconString .. '[ENDCOLOR]' .. '[ICON_GoingTo]'.. '[COLOR_FLOAT_SCIENCE]' ..  string.format("%.1f", TradingScience) .. GameInfo.Yields['YIELD_SCIENCE'].IconString .. '[ENDCOLOR]' , CapitalPlotX, CapitalPlotY)
        end
    end
end
-- 研究返点
function MonaResearchReward(ePlayer, eTech)
    -- 检查完成研究eTech的玩家是否具备“伟大的占星术士”特性
    if (not HasTrait("TRAIT_GREAT_ASTROLOGIST", ePlayer)) then return; end
    -- 获取完成研究eTech所消耗的科技点，计算返点金额
    local pPlayer = Players[ePlayer]
    RewardGold = pPlayer:GetTechs():GetResearchCost(eTech) / 3
    -- 返点到账
    pPlayer:GetTreasury():ChangeGoldBalance(RewardGold)
    -- 获取首都坐标
    pCapital = pPlayer:GetCities():GetCapitalCity()
    CapitalPlotX = pCapital:GetX()
    CapitalPlotY = pCapital:GetY()
    -- 首都上方显示飘字
    Game.AddWorldViewText(0, '[COLOR_FLOAT_GOLD]' .. '+' .. string.format("%.1f", RewardGold) .. GameInfo.Yields['YIELD_GOLD'].IconString .. '[ENDCOLOR]', CapitalPlotX, CapitalPlotY)
end

Events.TurnBegin.Add(TurnCounter)
Events.ResearchCompleted.Add(MonaResearchReward)