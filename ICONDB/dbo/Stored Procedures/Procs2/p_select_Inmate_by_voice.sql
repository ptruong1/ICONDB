-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_Inmate_by_voice] 
	@facilityID int,
	@LastName	varchar(25),
	@FirstName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@facilityID is null)	SET @facilityID =1
	declare @fl int, @locationID int
	SET @locationID =0
    -- Insert statements for procedure here
    SET @LastName = LTRIM(rtrim(@lastName))
    SET @FirstName = LTRIM(rtrim(@firstName))
    SET @LastName = ISNULL (@LastName,'')
    SET @FirstName = ISNULL (@firstname,'')

	
	        
	if(@LastName <>'' and @LastName <>'""' and @FirstName <>'' and  @FirstName <>'""')
		SELECT LastName,FirstName, InmateID, DOB,  datediff(year,isnull(DOB,getdate()),getdate()) as Age  from leg_Icon.dbo.tblInmate with(nolock) where 
			FacilityId =@facilityID and LastName like  @LastName + '%' and FirstName like '%' + @FirstName +'%' and Status=1
			--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
	Else if(@LastName <>'' and  @LastName <>'""')
		SELECT LastName,FirstName, InmateID, DOB, datediff(year,isnull(DOB,getdate()),getdate()) as Age  from leg_Icon.dbo.tblInmate with(nolock) where 
			FacilityId =@facilityID and LastName like  @LastName + '%' and Status=1
			--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
	Else if (@FirstName <>'' and  @FirstName <>'""')
		SELECT LastName,FirstName, InmateID , DOB ,datediff(year,isnull(DOB,getdate()),getdate()) as Age from leg_Icon.dbo.tblInmate with(nolock) where 
			FacilityId =@facilityID and  FirstName like  + @FirstName +'%' and Status=1 
			--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
	else
		SELECT LastName,FirstName, InmateID,  DOB, datediff(year,isnull(DOB,getdate()),getdate()) as Age  from leg_Icon.dbo.tblInmate with(nolock) where 
			FacilityId =@facilityID and Status=1
			--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
		 
	
END

