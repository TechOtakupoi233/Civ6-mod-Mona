INSERT INTO CivilizationCitizenNames (CivilizationType, CitizenName, Female, Modern)
SELECT 'CIVILIZATION_IESS', CitizenName, Female, Modern
FROM CivilizationCitizenNames
WHERE CivilizationType IN 
	('CIVILIZATION_MONDSTADT',
	'CIVILIZATION_LIYUE_CL',
	'CIVILIZATION_INAZUMA_TEYVAT',
	'CIVILIZATION_SUMERU');

INSERT INTO CityNames (CivilizationType, CityName)
SELECT 'CIVILIZATION_IESS', CityName
FROM CityNames
WHERE CivilizationType IN 
	('CIVILIZATION_MONDSTADT',
	'CIVILIZATION_LIYUE_CL',
	'CIVILIZATION_INAZUMA_TEYVAT',
	'CIVILIZATION_SUMERU');

UPDATE CityNames SET CityName = 'LOC_CIVILIZATION_IESS_NAME' || CityName || 'LOC_BRANCH' WHERE CivilizationType = 'CIVILIZATION_IESS';