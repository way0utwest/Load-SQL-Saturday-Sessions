SELECT 
 speaker
,  COUNT(DISTINCT ss.EventID)
 FROM dbo.SessionsStaging AS ss
 GROUP BY speaker
 ORDER BY COUNT(*) DESC
 
 SELECT DISTINCT speaker
  FROM dbo.SessionsStaging AS ss

  CREATE TABLE BadSpeakers
  ( speaker NVARCHAR(200)
  )
  GO
  INSERT badspeakers 
    SELECT DISTINCT speaker
	 FROM dbo.SessionsStaging AS ss
	 WHERE speaker LIKE 'SQLSat%'
  INSERT badspeakers 
    SELECT DISTINCT speaker
	 FROM dbo.SessionsStaging AS ss
	 WHERE speaker LIKE 'SQLSatruday%'
  INSERT badspeakers 
    SELECT DISTINCT speaker
	 FROM dbo.SessionsStaging AS ss
	 WHERE speaker LIKE 'SQL Saturday'

DELETE dbo.SessionsStaging
 FROM dbo.SessionsStaging AS ss
 INNER JOIN dbo.BadSpeakers AS bs
 ON bs.speaker = ss.Speaker


INSERT badspeakers 
   VALUES 
 ('Registration Registration')
, ('Denver WIT')
, ('PASS SQLSat')
, ('Staff SQL Saturday')
, ('Women in Technology Panel')
		, ('Kick Off')
		, ('Coffee  ')
		, ('Blank Blank')
		, ('STL SQL Saturday STL SQL Saturday')
		, ('SQLSAT DC')
		, ('Equipe SQLSat100 Equipe SQLSat100')
		, ('Next to Vendor Area')
		, ('Brought to you by the Institute for Information Assurance')
		, ('Closing Remarks Closing Remarks')
		, ('SQLSat Staff')
		, ('. .')

  INSERT badspeakers 
  values
		('SQLSAT312 Raffle')
		,('SQL Saturday # 99 Committee')
		,('SQL Saturday  276')
		,('SQL Saturday 160')
		,('SQL Saturday 131')
		,('Event Committee')
		,('PASS Board')
		,('Prize Drawings')
		,('We will')
		,('SQL Saturday 277')
		,('SQL Saturday SQL Saturday')
		,('ALL ALL')
		,('SQLSAT312 Registration')
		,('SQLSAT312 Registration')
		,('NA NA')
		,('SQL Saturday #154 SQL Saturday #154')
		,('TBD TBD')
		,('TBD TBD')
		,('SQL Saturday Rochester, NY')
		,('SQL Saturday 315')
		,('Team  SQL PASS PERU')
		,('')



SELECT distinct speaker
 FROM dbo.SessionsStaging AS ss
