CREATE FUNCTION dbo.fn_determine_IntraState_call (@fromNPANXX char(6), @toNPANXX char(6))  
RETURNS int  AS  
BEGIN 
	declare @fromNPA char(3) , @toNPA char(3), @i int, @fromState varchar(2), @toState varchar(2), @fromNXX char(3) ,@toNXX char(3)
	set @fromNPA  =  left(@fromNPANXX, 3 ) 
	set   @fromNXX = right(@fromNPANXX, 3 ) 
	set @toNPA  =   left(@toNPANXX ,3) 
	set @toNXX  =   right(@toNPANXX ,3) 
	 IF(@fromNPANXX = @toNPANXX) RETURN 1
	
	SELECT  top 1 @fromState = [State]	    From tblTPM with(NOLOCK)   WHERE NPA = @fromNPA  AND NXX = @fromNXX
	if ( @fromState is null )
		SELECT  top 1 @fromState = [State]	    From tblTPM with(NOLOCK)   WHERE NPA = @fromNPA  

	SELECT top 1     @toState  = [State]   From tblTPM with(NOLOCK)   WHERE NPA = @toNPA  AND NXX = @toNXX
	if ( @toState is null )  
		SELECT top 1     @toState  = [State]   From tblTPM with(NOLOCK)   WHERE NPA = @toNPA  
	if(  @fromState=   @toState )  RETURN 1

	 RETURN 0
END


































