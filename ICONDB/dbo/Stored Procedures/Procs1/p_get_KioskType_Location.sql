
CREATE PROCEDURE [dbo].[p_get_KioskType_Location] 
@facilityID int

 AS

Declare @temp Table (Descript varchar(30), LocationName varchar(30) )
insert @temp (Descript, LocationName)
select distinct 'NA', LocationName from [tblStationType],[tblVisitLocation]where FacilityID =@facilityID

insert @temp (Descript, LocationName)
select  distinct Descript, 'NA' from [tblStationType],[tblVisitLocation]where FacilityID =@facilityID

select Descript, LocationName from @temp
