INSERT OR IGNORE INTO Players (Domain, CivilizationType, LeaderType, CivilizationName, CivilizationIcon, LeaderName, LeaderIcon, CivilizationAbilityName, CivilizationAbilityDescription, CivilizationAbilityIcon, LeaderAbilityName, LeaderAbilityDescription, LeaderAbilityIcon, Portrait, PortraitBackground)
SELECT	Domain, CivilizationType, 'LEADER_MONA_MONDSTANT', CivilizationName, CivilizationIcon, 'LOC_LEADER_MONA_NAME', 'ICON_LEADER_MONA', CivilizationAbilityName, CivilizationAbilityDescription, CivilizationAbilityIcon, 'LOC_TRAIT_GREAT_ASTROLOGIST_NAME', 'LOC_TRAIT_GREAT_ASTROLOGIST_DESCRIPTION', 'ICON_LEADER_MONA', 'LEADER_MONA_THIN', 'LEADER_MONA_BACKGROUND'
FROM Players WHERE CivilizationType = 'CIVILIZATION_MONDSTADT';

--INSERT OR IGNORE INTO PlayerItems (Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
--SELECT	Domain, CivilizationType, 'LEADER_MONA_MONDSTANT', Type, Icon, Name, Description, SortIndex
--FROM	PlayerItems WHERE CivilizationType = 'CIVILIZATION_MONDSTADT';