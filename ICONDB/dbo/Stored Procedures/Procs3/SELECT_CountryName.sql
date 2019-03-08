
CREATE PROCEDURE [dbo].[SELECT_CountryName]

AS
	SET NOCOUNT ON;
SELECT      distinct CountryCode,Descript 
FROM            tblIntlRate  with(nolock)  order by Descript

