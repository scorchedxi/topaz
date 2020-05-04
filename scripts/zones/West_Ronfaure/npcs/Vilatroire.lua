-----------------------------------
-- Area: West Ronfaure
--  NPC: Vilatroire
-- Involved in Quests: "Introduction To Teamwork", "Intermediate Teamwork",
-- "Advanced Teamwork"
-- !pos -260.361 -70.999 423.420 100
-----------------------------------
local ID = require("scripts/zones/West_Ronfaure/IDs");
require("scripts/globals/quests");
require("scripts/globals/titles");
require("scripts/globals/status");
-----------------------------------

function onTrade(player, npc, trade)
end

function onTrigger(player, npc)
    --player:startEvent(129) -- starts the ready check for all three quests
    --player:startEvent(130) -- post third quest dialog
    --player:startEvent(131) -- Same job
    --player:startEvent(132) -- You don't have the requirements to start the second quest
    --player:startEvent(133) -- Same race
    --player:startEvent(134) -- You don't have the requirements to start the first quest
    --player:startEvent(135) -- Starts first quest - 6 members same alliance
    --player:startEvent(136) -- Default - before quests

    -- get players fame for this quest region
    local sandyFame = player:getFameLevel(SANDORIA);

    -- get quest statuses
    local questIntroToTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK);
    local questIntermediateTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.INTERMEDIATE_TEAMWORK);
    local questAdvancedTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.ADVANCED_TEAMWORK);

    if (questIntroToTeamwork == QUEST_AVAILABLE and sandyFame >= 2) then
        -- start the event that starts the quest
         player:startEvent(135);
    elseif (questIntroToTeamwork == QUEST_AVAILABLE and sandyFame < 2) then
        -- don't meet fame requirements
        player:startEvent(134);
    elseif (questIntroToTeamwork == QUEST_ACCEPTED) then
        -- start the event that asks them if they are ready to check
        player:startEvent(129, 0, 1);
    elseif (questIntroToTeamwork == QUEST_COMPLETED and questIntermediateTeamwork == QUEST_AVAILABLE and sandyFame >= 3 and player:getMainLvl() >= 10) then
        -- they've completed the first quest, the second quest is available, and they have thee required fame,
        -- start event that starts the next quest
        player:startEvent(133);
    elseif (questIntroToTeamwork == QUEST_COMPLETED and questIntermediateTeamwork == QUEST_AVAILABLE and sandyFame < 3 and player:getMainLvl() < 10) then
        -- don't meet fame requirements
        player:startEvent(132);
    elseif (questIntermediateTeamwork == QUEST_ACCEPTED) then
         -- start the event that asks them if they are ready to check
        player:startEvent(129, 0, 2);
    elseif (questIntermediateTeamwork == QUEST_COMPLETED and questAdvancedTeamwork == QUEST_AVAILABLE and sandyFame >= 4 and player:getMainLvl() >= 10) then
        -- they've completed the second quest, the third quest is available, and they have thee required fame,
        -- start event that starts the next quest
        player:startEvent(131);
    elseif (questIntermediateTeamwork == QUEST_COMPLETED and questAdvancedTeamwork == QUEST_AVAILABLE and sandyFame < 4 and player:getMainLvl() < 10) then
        -- don't meet fame requirements
        player:startEvent(130);
    elseif (questAdvancedTeamwork == QUEST_ACCEPTED) then
         -- start the event that asks them if they are ready to check
        player:startEvent(129, 0, 3);
    elseif (questAdvancedTeamwork == QUEST_COMPLETED) then
        player:startEvent(130);
    else
        player:startEvent(136);
    end
end

function onEventUpdate(player, csid, option)
    -- csid 129 happens for both quests
    if (csid == 129) then
        local questIntroToTeamwork = player:getQuestStatus(SANDORIA,tpz.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK);
        local questIntermediateTeamwork = player:getQuestStatus(SANDORIA,tpz.quest.id.sandoria.INTERMEDIATE_TEAMWORK);
        local questAdvancedTeamwork = player:getQuestStatus(SANDORIA,tpz.quest.id.sandoria.ADVANCED_TEAMWORK);

        -- newer versions of these quests only require a party of 2. 
        -- older versions require all 6
        local partySizeRequirement = 2;

        -- get party
        local party = player:getParty();

        -- since we loop through the party to check zone and distance, may as well check these in the same loop
        local partySameNationCount = 0;
        local partySameRaceCount = 0;
        local partySameJobCount = 0;

        -- make sure the party is at least the right partySizeRequirement
        if (#party >= partySizeRequirement) then

            -- make sure everyone in the party is in the same zone and nearby
            for key, member in pairs(party) do
                if (member:getZoneID() ~= player:getZoneID() or member:checkDistance(player) > 50) then
                    -- member not in zone or range
                    player:updateEvent(1); 

                    return;
                else
                    -- check nation for first quest
                    if (member:getNation() == player:getNation()) then
                        partySameNationCount = partySameNationCount + 1;
                    end

                    -- check race for second
                    if (player:getRace() == tpz.race.HUME_M and member:getRace() == tpz.race.HUME_M or member:getRace() == tpz.race.HUME_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.HUME_F and member:getRace() == tpz.race.HUME_M or member:getRace() == tpz.race.HUME_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.ELVAAN_M and member:getRace() == tpz.race.ELVAAN_M or member:getRace() == tpz.race.ELVAAN_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.ELVAAN_F and member:getRace() == tpz.race.ELVAAN_M or member:getRace() == tpz.race.ELVAAN_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.TARU_M and member:getRace() == tpz.race.TARU_M or member:getRace() == tpz.race.TARU_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.TARU_F and member:getRace() == tpz.race.TARU_M or member:getRace() == tpz.race.TARU_F) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.GALKA and member:getRace() == tpz.race.GALKA) then
                        partySameRaceCount = partySameRaceCount + 1;
                    elseif (player:getRace() == tpz.race.MITHRA and member:getRace() == tpz.race.MITHRA) then
                        partySameRaceCount = partySameRaceCount + 1;
                    end

                    -- job for third
                    if (member:getMainJob() == player:getMainJob()) then
                        partySameJobCount = partySameJobCount + 1;
                    end
                end
            end

            if (questIntroToTeamwork == QUEST_ACCEPTED) then
                -- https://www.bg-wiki.com/bg/Introduction_to_Teamwork
                if (partySameNationCount == partySizeRequirement) then
                    -- nation requirements met
                    player:setCharVar("introToTmwrk_pass", 1);
                    player:updateEvent(15, 1);
                else
                    -- not met
                    player:updateEvent(3);
                end
            elseif (questIntermediateTeamwork == QUEST_ACCEPTED) then
                -- https://www.bg-wiki.com/bg/Intermediate_Teamwork
                if (partySameRaceCount == partySizeRequirement) then
                    -- race requirements met
                    player:setCharVar("intermedTmwrk_pass", 1);
                    player:updateEvent(15, 2);
                else
                    -- not met
                    player:updateEvent(4);
                end
            elseif (questAdvancedTeamwork == QUEST_ACCEPTED) then
                -- https://www.bg-wiki.com/bg/Advanced_Teamwork
                if (partySameJobCount == partySameJobCount) then
                    -- race requirements met
                    player:setCharVar("advTmwrk_pass", 1);
                    player:updateEvent(15, 3);
                else
                    -- not met
                    -- UPDATE ME --
                    player:updateEvent(5);
                end
            end
        else
            -- need more party members
            player:updateEvent(1);
        end
    end
end

function onEventFinish(player, csid, option)
    -- csid 129 is the event for when they have selected ready/not ready
    
    if (csid == 129 and option == 0) then
        local questIntroToTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK);
        local questIntermediateTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.INTERMEDIATE_TEAMWORK);
        local questAdvancedTeamwork = player:getQuestStatus(SANDORIA, tpz.quest.id.sandoria.ADVANCED_TEAMWORK);

            if (questIntroToTeamwork == QUEST_ACCEPTED and player:getCharVar("introToTmwrk_pass") == 1) then
                -- check their inventory
                if (player:getFreeSlotsCount() == 0) then
                    player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 13442);
                else
                    player:completeQuest(SANDORIA,tpz.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK);
                    player:addFame(SANDORIA, 80); -- unsure of actual fame value
                    player:addTitle(tpz.title.THIRDRATE_ORGANIZER);
                    player:addItem(13442); -- shell ring
                    player:messageSpecial(ID.text.ITEM_OBTAINED, 13442); -- shell ring
                    player:setCharVar("introToTmwrk_pass", 0) -- Delete charVar from memory
                end
            elseif (questIntermediateTeamwork == QUEST_ACCEPTED and player:getCharVar("intermedTmwrk_pass") == 1) then
                 -- check their inventory
                if (player:getFreeSlotsCount() == 0) then
                    player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 4994);
                else
                    player:completeQuest(SANDORIA,tpz.quest.id.sandoria.INTERMEDIATE_TEAMWORK);
                    player:addFame(SANDORIA, 80);-- unsure of actual fame value
                    player:addTitle(tpz.title.SECONDRATE_ORGANIZER);
                    player:addItem(4994); -- mage's ballad
                    player:messageSpecial(ID.text.ITEM_OBTAINED, 4994); -- mage's ballad
                    player:setCharVar("intermedTmwrk_pass", 0) -- Delete charVar from memory
                end
            elseif (questAdvancedTeamwork == QUEST_ACCEPTED and player:getCharVar("advTmwrk_pass") == 1) then
                 -- check their inventory
                if (player:getFreeSlotsCount() == 0) then
                    player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 13459);
                else
                    player:completeQuest(SANDORIA,tpz.quest.id.sandoria.ADVANCED_TEAMWORK);
                    player:addFame(SANDORIA, 80);-- unsure of actual fame value
                    player:addTitle(tpz.title.FIRSTRATE_ORGANIZER);
                    player:addItem(13459); -- horn ring
                    player:messageSpecial(ID.text.ITEM_OBTAINED, 13459); -- horn
                    player:setCharVar("advTmwrk_pass", 0) -- Delete charVar from memory
                end
    end 
    elseif (csid == 131 and option == 1) then
        -- 131 is the third and last quest
        player:addQuest(SANDORIA,tpz.quest.id.sandoria.ADVANCED_TEAMWORK);
    elseif (csid == 133 and option == 1) then
        -- 133 is the second quest
        player:addQuest(SANDORIA,tpz.quest.id.sandoria.INTERMEDIATE_TEAMWORK);
    elseif (csid == 135 and option == 1) then
        -- 135 is the first quest
        player:addQuest(SANDORIA,tpz.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK);
    end
end