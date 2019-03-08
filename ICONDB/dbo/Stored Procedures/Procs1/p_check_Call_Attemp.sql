
CREATE PROCEDURE [dbo].[p_check_Call_Attemp] 
@Attempt  int OUTPUT
AS
declare @h int 
SET @Attempt  = 0
SET  @h = datepart(hh,getdate()) 
If ( (@h >= 0 and  @h  < 5)  Or  ( @h= 23)) 
	select  @Attempt  = count(*) from    tblCallAttempt where dateDiff(Mi,RecordDate , getdate()) < 10
else 
	select  @Attempt  = count(*) from    tblCallAttempt  where dateDiff(Mi,RecordDate , getdate()) < 4
