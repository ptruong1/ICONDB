-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_list] 
@facilityID int,
@InmateID varchar(12),
@VLastName varchar(25),
@VFirstName varchar(25)

AS
 If @InmateID <> ''
	 SELECT [VLastName], [VFirstName], [VMi], [Address], [City], [State], [Zipcode], [Phone1], [Phone2], 
	[Email], tblVisitors.InmateID, tblVisitors.RelationshipID, [RecordOpt], [Approved], [VisitorID], [DriverLicense], 
	Descript, FirstName, LastName  
	FROM [tblVisitors] 
	inner join [tblRelationship] on tblVisitors.RelationshipID = tblRelationship.RelationshipID
	inner join [tblInmate] on tblVisitors.InmateID = tblInmate.InmateID and tblVisitors.FacilityID = tblInmate.FacilityID
	WHERE tblVisitors.FacilityID = @FacilityID and
		  tblVisitors.InmateID = @InmateID
Else
If @VLastName <> '' and @VFirstName <> ''
	SELECT [VLastName], [VFirstName], [VMi], [Address], [City], [State], [Zipcode], [Phone1], [Phone2], 
	[Email], tblVisitors.InmateID, tblVisitors.RelationshipID, [RecordOpt], [Approved], [VisitorID], [DriverLicense], 
	Descript, FirstName, LastName  
	FROM [tblVisitors] 
	inner join [tblRelationship] on tblVisitors.RelationshipID = tblRelationship.RelationshipID
	inner join [tblInmate] on tblVisitors.InmateID = tblInmate.InmateID and tblVisitors.FacilityID = tblInmate.FacilityID
	WHERE tblVisitors.FacilityID = @FacilityID and
		  tblVisitors.VLastName = @VLastName and
		  tblvisitors.VFirstName = @VFirstName
Else
If @VLastName <> '' 
	SELECT [VLastName], [VFirstName], [VMi], [Address], [City], [State], [Zipcode], [Phone1], [Phone2], 
	[Email], tblVisitors.InmateID, tblVisitors.RelationshipID, [RecordOpt], [Approved], [VisitorID], [DriverLicense], 
	Descript, FirstName, LastName  
	FROM [tblVisitors] 
	inner join [tblRelationship] on tblVisitors.RelationshipID = tblRelationship.RelationshipID
	inner join [tblInmate] on tblVisitors.InmateID = tblInmate.InmateID and tblVisitors.FacilityID = tblInmate.FacilityID
	WHERE tblVisitors.FacilityID = @FacilityID and
		  tblVisitors.VLastName = @VLastName
Else
If  @VFirstName <> ''
	SELECT [VLastName], [VFirstName], [VMi], [Address], [City], [State], [Zipcode], [Phone1], [Phone2], 
	[Email], tblVisitors.InmateID, tblVisitors.RelationshipID, [RecordOpt], [Approved], [VisitorID], [DriverLicense], 
	Descript, FirstName, LastName  
	FROM [tblVisitors] 
	inner join [tblRelationship] on tblVisitors.RelationshipID = tblRelationship.RelationshipID
	inner join [tblInmate] on tblVisitors.InmateID = tblInmate.InmateID and tblVisitors.FacilityID = tblInmate.FacilityID
	WHERE tblVisitors.FacilityID = @FacilityID and
		  tblvisitors.VFirstName = @VFirstName
Else

	SELECT [VLastName], [VFirstName], [VMi], [Address], [City], [State], [Zipcode], [Phone1], isnull(Phone2,'') as Phone2, 
	[Email], tblVisitors.InmateID, tblVisitors.RelationshipID, [RecordOpt], [Approved], [VisitorID], [DriverLicense], 
	Descript, FirstName, LastName  
	FROM [tblVisitors] 
	inner join [tblRelationship] on tblVisitors.RelationshipID = tblRelationship.RelationshipID
	inner join [tblInmate] on tblVisitors.InmateID = tblInmate.InmateID and tblVisitors.FacilityID = tblInmate.FacilityID
	WHERE tblVisitors.FacilityID = @FacilityID

