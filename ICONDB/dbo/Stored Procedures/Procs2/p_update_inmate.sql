
CREATE PROCEDURE [dbo].[p_update_inmate] 
@RecordType	varchar(12),
@PIN	varchar(12),
@BookingNo	varchar(10),
@StartDate	varchar(20),
@EndDate	varchar(20),
@OffenderName	varchar(50),
@DOB		varchar(12),
@gender	char(1)




AS
Declare @firstName varchar(25), @lastName varchar(25), @modifyDate  datetime
SET @modifyDate =  getdate() 
If(@RecordType = 'RELEASES' ) 
 Begin
	If (@EndDate < @modifyDate)
		UPDATE tblInmate set status = 2,  EndDate = @EndDate, modifyDate = @modifyDate  where  PIN = @PIN and FacilityID =  352  
		delete leg_Icon.dbo.tblInmateBookInfo where PIN=@PIN
	--else
		--UPDATE tblInmate set  EndDate = @EndDate, modifyDate = @modifyDate  where  PIN = @PIN and FacilityID =  352  --- For Fresno only
 End
Else
 Begin
	SET  @LastName  = ltrim(substring (@OffenderName,1, CHARINDEX(',',@OffenderName)-1))

	SET @FirstName =ltrim( substring (@OffenderName, CHARINDEX(',',@OffenderName)+1, len(@OffenderName)))
	If (select count(*) from  tblInmate  where  PIN = @PIN and FacilityID =   352 ) =  0
 	  Begin
		INSERT tblInmate(InmateID   , CaseID  ,    LastName       ,           FirstName   ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,  StartDate ,  PIN,  DOB   ,       SEX  )
			Values( @PIN, @BookingNo, @lastName, @FirstName,1, 0,0,0, 352, @StartDate, @PIN,@DOB, @gender	)

	  End
	else
	 Begin
		UPDATE tblInmate SET  status = 1 , inputdate =@StartDate,  CaseID =  @BookingNo  where  PIN = @PIN and FacilityID =   352
	 End
 End
