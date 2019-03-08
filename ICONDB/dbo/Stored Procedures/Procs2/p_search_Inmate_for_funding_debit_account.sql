-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_Inmate_for_funding_debit_account]   --- Use for Debit and get  name for email
	@facilityID int,
	@LastName	varchar(25),
	@FirstName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	Declare @AgentID int, @DebitOpt tinyint, @DebitPaid tinyint, @EmailOpt tinyint, @VideoMessOpt tinyint ;
	
	declare @fl int, @locationID int;
	SET @locationID =0;
	SET  @DebitPaid =0;
	SET @DebitOpt =0;
	SET @EmailOpt = 0;
	SET @VideoMessOpt  =0;
	if(@facilityID is null)	SET @facilityID =1;
    -- Insert statements for procedure here
    SET @LastName = LTRIM(rtrim(@lastName));
    SET @FirstName = LTRIM(rtrim(@firstName));
	select @DebitOpt= isnull(DebitCardLessOpt,0)  from tblFacilityOption with(nolock)  where FacilityID = @facilityID;
	--select @AgentID =AgentID,@DebitOpt= isnull(DebitOpt,0)  from tblfacility with(nolock) where FacilityID = @facilityID;
    if(@DebitOpt =1)
     Begin
		
			if(@LastName <>'' and @FirstName <>'')
				SELECT FirstName + ' ' + LastName as InmateName, InmateID   from leg_Icon.dbo.tblInmate with(nolock) where 
					FacilityId =@facilityID and LastName like  @LastName + '%' and FirstName like '%' + @FirstName +'%' and [Status]=1 ;
					
			Else if(@LastName <>'' )
				SELECT FirstName + ' ' + LastName  as InmateName, InmateID from leg_Icon.dbo.tblInmate with(nolock) where 
					FacilityId =@facilityID and LastName like  @LastName + '%' and [Status]=1; 
					
			Else if (@FirstName <>'')
				SELECT FirstName + ' ' + LastName  as InmateName, InmateID  from leg_Icon.dbo.tblInmate with(nolock) where 
					FacilityId =@facilityID and  FirstName like  + @FirstName +'%' and [Status]=1 ;
					
			else
				SELECT FirstName + ' ' + LastName  as InmateName, InmateID from leg_Icon.dbo.tblInmate with(nolock) where 
					FacilityId =@facilityID and [Status]=1 ;
					
		 end	 
		
	 Else
		begin
			select @emailOpt =isnull( emailOpt,0) , @VideoMessOpt = isnull(VideoMessageOpt,0) from tblfacilityoption  with(nolock)  where facilityID = @facilityID ;
			if(  @emailOpt = 1 or @VideoMessOpt  =1)
			 begin
					if(@LastName <>'' and @FirstName <>'')
						SELECT FirstName + ' ' + LastName as InmateName, InmateID   from leg_Icon.dbo.tblInmate with(nolock) where 
						FacilityId =@facilityID and LastName like  @LastName + '%' and FirstName like '%' + @FirstName +'%' and [Status]=1 ;
					
					Else if(@LastName <>'' )
						SELECT FirstName + ' ' + LastName  as InmateName, InmateID from leg_Icon.dbo.tblInmate with(nolock) where 
						FacilityId =@facilityID and LastName like  @LastName + '%' and [Status]=1 ;
					
					Else if (@FirstName <>'')
						SELECT FirstName + ' ' + LastName  as InmateName, InmateID  from leg_Icon.dbo.tblInmate with(nolock) where 
						FacilityId =@facilityID and  FirstName like  + @FirstName +'%' and [Status]=1;
					
				else
					SELECT FirstName + ' ' + LastName  as InmateName, InmateID from leg_Icon.dbo.tblInmate with(nolock) where 
						FacilityId =@facilityID and [Status]=1 ;
			 end
		    else 
			 begin
				  SELECT ''  as InmateName, '' InmateID	;
				--SELECT distinct FirstName + ' ' + LastName  as InmateName, InmateID from leg_Icon.dbo.tblInmate with(nolock) where 
				--		FacilityId =@facilityID and [Status]=1 and lastName <>'DOE';  
			 end
		end 
	Return @@ERROR;
		
END

