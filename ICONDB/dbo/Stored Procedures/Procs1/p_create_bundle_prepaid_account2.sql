
CREATE PROCEDURE [dbo].[p_create_bundle_prepaid_account2]
@facilityID	int

AS

Select FacilityID, ('# ' +  AccountNo) as AccountNo, Balance, ReservedBalance, ActiveDate   from tblDebit  where  facilityID = @facilityID  AND inputdate >= convert (varchar(10), getdate(),101)

