-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_inmate_visit_request]
@FacilityID int,
@InmateID int,
@VisitorID int,
@RequestID int OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

	Set @RequestID =0;
	select top 1 @RequestID = RequestID from tblvisitRequest order by RequestID Desc;
	SET @RequestID =@RequestID +1;

	Insert tblvisitRequest (RequestID, FacilityID, InmateID, VisitorID, RequestStatus, RequestDate)
			values( @RequestID, @FacilityID , @InmateID, @VisitorID, 1, getdate());
    
END

