-- These Codes are modified from TC's "ExpandInitialVision" mod. This genius has all the copyrights.
-- https://steamcommunity.com/workshop/browse/?appid=289070&searchtext
-- Thanks a lot.

include("GameCapabilities");

function MonaIntialVision()
    --Set desired sight radius here
    local rad = 10;
    for i, playerID in pairs(PlayerManager.GetAliveMajorIDs()) do
        if (not HasTrait("TRAIT_GREAT_ASTROLOGIST", playerID)) then return; end
        local pPlayer = Players[playerID]
        local pVis = PlayersVisibility[pPlayer]
        local pPlot = Players[playerID]:GetStartingPlot();
        local tPlots = GetValidPlotsInRadiusR(pPlot, rad);
    
        for k, pPickPlot in pairs(tPlots) do
        
            --If there is a natural wonder on the tile, do not reveal. Any amount of revealing this tile will not allow the wonder discovery eureka during game.
            if(pPickPlot:IsNaturalWonder()) then
                print("wonder on tile - not revealing tile");

            --If there is a unit on the tile, do not remove FOW. This avoids the diplomatic meet event.
            elseif(pPickPlot:GetUnitCount() > 0 or pPickPlot:IsCity()) then
               pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), 0);
                print("unit or city on tile - revealing tile, not removing FOW");

            --If there is no unit or wonder, temporarily remove FOW so that the resouce icon will show.
            else
                pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), 1);
                pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), -1);
                --print("no unit or wonder on tile - revealing tile, temporarily removing FOW");
            end
        end
    end
end

function GetValidPlotsInRadiusR(pPlot, iRadius)
    local tTempTable = {}
    if pPlot ~= nil then
        local iPlotX, iPlotY = pPlot:GetX(), pPlot:GetY()
        for dx = (iRadius * -1), iRadius do
            for dy = (iRadius * -1), iRadius do
                local pNearPlot = Map.GetPlotXYWithRangeCheck(iPlotX, iPlotY, dx, dy, iRadius);
                if pNearPlot then
                    table.insert(tTempTable, pNearPlot)
                end
            end
        end
    end
    return tTempTable;
end

MonaIntialVision();