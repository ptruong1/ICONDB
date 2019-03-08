-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_verify_Inmate_login]
@FacilityID int,
@InmateID varchar(12),
@PIN		varchar(12)

AS
BEGIN
    Declare @status tinyint,  @TTYoption tinyint, @FirstName as varchar(25), @LastName as varchar(25) ;
	SET @status =0;
	SET @TTYoption =0;
	SET @FirstName ='NA';
	SET @LastName ='NA';
	select  @status= [status], @TTYoption= isnull(TTY,0), @FirstName= FirstName, @LastName = lastName  from tblinmate with(nolock) where facilityID = @facilityID and InmateID = @InmateID and PIN = @PIN;

	Select @status as InmateStatus,  @TTYoption TTYoption, @FirstName as FirstName, @LastName as LastName;
	
END

