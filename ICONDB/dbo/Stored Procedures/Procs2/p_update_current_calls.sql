
CREATE PROCEDURE [dbo].[p_update_current_calls] 
@duration int,
@RecFileName  varchar(20),
 @projectcode char(6),
@calldate char(6)
AS



  Update  tblcalls  SET duration =  @duration, RecordFile = @RecFileName  where  calldate = @calldate and projectcode = @projectcode

Return @@error

