/*
Description: Script for running on merge on 2 tables gtc_voters and gtc_voters_updated.
Output any removals from the voters list to an audit table called voters_removed
*/

--create an audit table which will store any removals
CREATE TABLE  voters_removed (id int, address varchar(100), jobtitle varchar(50), logdate DATETIME) ;

-----

INSERT INTO voters_removed
SELECT  id, address, jobtitle, GETDATE() as logdate
FROM
(
  MERGE  gtc_voters v
  USING  gtc_voters_updated as stg
  ON v.id = stg.id
  WHEN MATCHED AND DATEDIFF(day, v.updatedate, stg.updatedate) > 0  THEN 
	UPDATE SET 
		v.address = stg.address,
		v.jobtitle = stg.jobtitle,
  		v.updatedate = stg.updatedate
  WHEN NOT MATCHED THEN
	INSERT VALUES (stg.id, stg.address, stg.jobtitle, stg.updatedate)
  WHEN NOT MATCHED BY SOURCE THEN
        DELETE
  OUTPUT $action, Deleted.id, Deleted.Address, Deleted.JobTitle 
) AS removals (Action, id, address, jobtitle)
WHERE Action = 'DELETE';



