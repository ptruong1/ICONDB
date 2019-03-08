CREATE Proc [dbo].[p_get_visit_type_v1]
@FacilityID int
As
Begin
	SET NOCOUNT ON;
	Declare @visitTypeID tinyint;
	SET @visitTypeID =3;
	select  @visitTypeID = VisitOpt from tblVisitFacilityConfig with(nolock) where FacilityID=@FacilityID;
	If(  @visitTypeID =3)
		select VisitTypeID, Descript from tblVisitType with(nolock) ; 
	Else if (@visitTypeID =2)
		select VisitTypeID, Descript from tblVisitType with(nolock) where VisitTypeID=1;
	Else if (@visitTypeID =1)
		select VisitTypeID, Descript from tblVisitType with(nolock) where VisitTypeID= 2;
	Else
		select VisitTypeID, Descript from tblVisitType with(nolock) where VisitTypeID= 0;
	
End