CREATE PROCEDURE [dbo].[p_get_Account_Balance]
@AccountNo	varchar(10)
 AS
Declare @balance  numeric(8,2), @status smallint;
SET nocount on;
set @balance =0;
set @status =-1;

select @balance= balance, @status = status  from tblprepaid with(nolock) where  phoneno = @AccountNo ;

Select @status as Status,@balance as Balance;
