
CREATE PROCEDURE [dbo].[SELECT_Inmates]

AS
	SET NOCOUNT ON;
SELECT        InmateID, LastName, FirstName, MidName, tblStatus.Descrip as [Status]
FROM            tblInmate  with(nolock) INNER JOIN tblStatus   with(nolock)  ON tblInmate.Status = tblStatus.statusID

