-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_recordID_to_detect_third_party]
	@RecordID	bigInt output,
	@facilityID	int		output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @RecordID =0 ;
    select top 1 @RecordID= RecordID,@facilityID =FacilityID from [leg_Icon2].[dbo].tblcallsbilled with(nolock) 
    where   RecordID=22613446 
		--RecordDate > DATEADD(D,-1, GETDATE()) and 
			--InRecordFile <>'T' and 
			--duration >300 and 
			--RecordFile <>'NA' ;
	if (@RecordID >0)
		Update [leg_Icon2].[dbo].tblcallsbilled set InRecordFile='T' where RecordID=@RecordID ;
    else
     begin
		select top 1 @RecordID= RecordID,@facilityID =FacilityID from [leg_Icon1].[dbo].tblcallsbilled with(nolock) 
		where RecordID=22613446 
		 -- RecordDate >DATEADD(D,-1, GETDATE()) and  
			--	InRecordFile <>'T' and duration >300 and 
			--	RecordFile <>'NA' ;
		if (@RecordID >0)
			Update [leg_Icon1].[dbo].tblcallsbilled set InRecordFile='T' where RecordID=@RecordID ;
	 end
	 Return 0;
END

