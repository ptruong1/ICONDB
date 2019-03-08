-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_relationship]

AS
BEGIN
	SET NOCOUNT ON;
	select RelationshipID,Descript from tblRelationship order by RelationshipID  ;
	

END

