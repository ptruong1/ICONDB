﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_set_bio_Identification_Trans]
	@userID	varchar(16),
	@TransID varchar(16),
	@Result varchar(50),
	@transType	int,
	@Note nchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    Insert tblBioMetricIdentification
    (UserID,transID,Results,RecordDate,transType,Note) 
    values(@userID,@transID,@Result,getdate(),@transType,@Note)
END

