
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_country]
AS
BEGIN
	select CountryID,CountryName from tblCountryCode  with(nolock) 
	
END


