-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_Inmate_by_name] 
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
   
	
		if(@LastName <>'' and @FirstName <>'')
			SELECT LastName,FirstName, isnull(MidName,'') MidName , isnull(balance,0) Balance   from leg_Icon.dbo.tblInmate Left outer join tbldebit on leg_Icon.dbo.tblInmate.FacilityId = tbldebit.FacilityID and leg_Icon.dbo.tblInmate.InmateID = tbldebit.InmateID 
			 where 
				leg_Icon.dbo.tblInmate.FacilityId =@facilityID and LastName like  @LastName + '%' and FirstName like '%' + @FirstName +'%' and leg_Icon.dbo.tblInmate.Status=1
				--and  leg_Icon.dbo.tblInmate.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')
		Else if(@LastName <>'' )
			SELECT LastName,FirstName, isnull(MidName,'') MidName, isnull(balance,0) Balance   from leg_Icon.dbo.tblInmate Left outer join tbldebit on leg_Icon.dbo.tblInmate.FacilityId = tbldebit.FacilityID and leg_Icon.dbo.tblInmate.InmateID = tbldebit.InmateID 
			where 
				leg_Icon.dbo.tblInmate.FacilityId =@facilityID and LastName like  @LastName + '%' and leg_Icon.dbo.tblInmate.Status=1
				--and  leg_Icon.dbo.tblInmate.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')
		Else if (@FirstName <>'')
			SELECT LastName,FirstName, isnull(MidName,'') MidName, isnull(balance,0) Balance   from leg_Icon.dbo.tblInmate Left outer join tbldebit on leg_Icon.dbo.tblInmate.FacilityId = tbldebit.FacilityID and leg_Icon.dbo.tblInmate.InmateID = tbldebit.InmateID 
			where 
				leg_Icon.dbo.tblInmate.FacilityId =@facilityID and  FirstName like  + @FirstName +'%' and leg_Icon.dbo.tblInmate.Status=1
				--and  leg_Icon.dbo.tblInmate.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')
		else
			SELECT LastName,FirstName, isnull(MidName,'') MidName, isnull(balance,0) Balance   from leg_Icon.dbo.tblInmate left outer join tbldebit on leg_Icon.dbo.tblInmate.FacilityId = tbldebit.FacilityID and leg_Icon.dbo.tblInmate.InmateID = tbldebit.InmateID 
			where  
				leg_Icon.dbo.tblInmate.FacilityId =@facilityID and leg_Icon.dbo.tblInmate.Status=1
				--and  leg_Icon.dbo.tblInmate.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')
	 
		 
END
