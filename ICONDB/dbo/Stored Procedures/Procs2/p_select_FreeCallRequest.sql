
CREATE PROCEDURE [dbo].[p_select_FreeCallRequest]
( 
	@FacilityID int,
	@FromDate dateTime,
	@Todate DateTime,
	@InmateID varchar(12) 
)
AS
	SET NOCOUNT ON;
	If (@InmateID <> '')
		begin
			SELECT  [InmateID], [FreeCallNo] ,isnull ([FreeCallRemain],0) "FreeCallRemain" ,[RequestBy],[RequestNote],[RequestDate]
			FROM [leg_Icon].[dbo].[tblFreeCallRequest] 
			where FacilityID = @FacilityID 
				 and InmateID =@InmateID
				 and (RequestDate between @fromDate and dateadd(d,1,@todate) )
				 Order by RequestDate Desc
		 end
	 else
		 begin
			SELECT  [InmateID], [FreeCallNo] ,isnull ([FreeCallRemain],0) "FreeCallRemain" ,[RequestBy],[RequestNote],[RequestDate]
			FROM [leg_Icon].[dbo].[tblFreeCallRequest] 
			where FacilityID = @FacilityID 
				and (RequestDate between @fromDate and dateadd(d,1,@todate) )
			Order by RequestDate Desc
		 end
		
		 
	  
  
