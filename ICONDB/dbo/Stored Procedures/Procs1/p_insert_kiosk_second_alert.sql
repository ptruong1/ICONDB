﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_kiosk_second_alert]
@FacilityID int,
@computerName varchar(20),
@PublicIP	varchar(16),
@PictureName varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert tblkioskalert (FacilityID, ComputerName,AlertDate,PublicIP,UserPic) values(@FacilityID,@computerName,getdate(),@PublicIP,@PictureName) ;
    
END

