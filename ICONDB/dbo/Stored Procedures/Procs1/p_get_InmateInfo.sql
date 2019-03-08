
CREATE PROCEDURE [dbo].[p_get_InmateInfo]
@PIN  varchar(12),
@facilityID	int ,
@VisitsAmount	int OUTPUT,
@ComAmount   numeric(7,2) OUTPUT ,
@Location	varchar(30)  OUTPUT

 AS
SET @VisitsAmount	 =0
SET @ComAmount  =0 
SET @Location	 =''
IF( select count(*)   From tblInmate  with(nolock)  where            PIN   = @PIN  and Status =1   ) > 0
 Begin
	--select    @VisitsAmount	= isnull(  Visits,0) , @ComAmount = isnull( Balance,0)    From  tblInmateBookInfo   where   PIN =  @PIN    
	--SELECT  @Location	=  Location from tblInmateInfo   where PIN =  @PIN  
	select @VisitsAmount=  VisitNo  ,   @ComAmount=  ComBalance ,@Location=  AtLocation   from tblInmateUpdate where  PIN =  @PIN    
	return 0                             

  End
Else
  	Return -1

