
CREATE PROCEDURE [dbo].[p_select_FreeCallRequest_v2]
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
			SELECT  a.[InmateID], b.FirstName, b.LastName, a.[FreeCallRemain] LastFreeCallRemain , a.FreeCallNo as FreeCallRequest, isnull (b.[FreeCallRemain],0) CurrentFreeCallRemain ,
			[RequestBy],[RequestNote],[RequestDate]
			FROM [leg_Icon].[dbo].[tblFreeCallRequest] a inner join [leg_Icon].[dbo].[tblInmate] b on (a.FacilityID=b.FacilityId and a.InmateID=b.InmateID)
			where a.FacilityID = @FacilityID 
				 and a.InmateID =@InmateID
				 and (a.RequestDate between @fromDate and dateadd(d,1,@todate) )
				 Order by RequestDate Desc;
		 end
	 else
		 begin
			SELECT  a.[InmateID], b.FirstName, b.LastName, a.[FreeCallRemain] LastFreeCallRemain ,a.FreeCallNo as FreeCallRequest, isnull (b.[FreeCallRemain],0) CurrentFreeCallRemain ,
			[RequestBy],[RequestNote],[RequestDate]
			FROM [leg_Icon].[dbo].[tblFreeCallRequest] a inner join [leg_Icon].[dbo].[tblInmate] b on (a.FacilityID=b.FacilityId and a.InmateID=b.InmateID)
			where a.FacilityID = @FacilityID 				 
				 and (a.RequestDate between @fromDate and dateadd(d,1,@todate) )
				 Order by RequestDate Desc;
		 end
		
		 
	  
  
