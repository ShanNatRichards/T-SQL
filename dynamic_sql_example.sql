CREATE PROC  getTopOccupation ( @tablename nvarchar(50) )
AS
BEGIN
DECLARE @sql_stmt nvarchar(500),  @tablename nvarchar(50);
DECLARE @occ varchar(50), @num_voters INT;  

SET @sql_stmt =  N’SELECT TOP(1) @occ_out = jobtitle , @num_voters_out= COUNT(*) FROM ’ + @tablename + N‘ GROUP By jobtitle ORDER BY Count(*) DESC, jobtitle asc;’ ;
EXECUTE sp_executesql @stmt = @sql_stmt , 
                   @params = N'@occ_out varchar(50) OUTPUT, @num_voters_out int OUTPUT', 
                   @occ_out = @occ OUTPUT, 
                   @num_voters_out = @num_voters OUTPUT;

SELECT @occ, @num_voters;

END;

