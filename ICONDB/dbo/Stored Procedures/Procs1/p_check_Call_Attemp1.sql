
CREATE PROCEDURE [dbo].[p_check_Call_Attemp1] 
@iMinRange smallint,
@Attempt  int OUTPUT
AS
SET @Attempt  = 0
select  @Attempt  = count(*) from    tblCallAttempt  where dateDiff(Mi,RecordDate , getdate()) < @iMinRange
