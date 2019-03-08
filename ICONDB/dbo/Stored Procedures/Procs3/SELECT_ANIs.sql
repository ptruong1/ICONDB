
CREATE PROCEDURE [dbo].[SELECT_ANIs]

AS
	SET NOCOUNT ON;
SELECT        ANINo, StationID, T.Descript as [AccessType] , IDrequired, PINRequired, DayTimeRestrict
FROM            tblANIs A  with(nolock)  INNER JOIN tblAccessType T  with(nolock)  ON T.AccessTypeID = A.AccessTypeID

