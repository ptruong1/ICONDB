Create Proc p_get_visit_type
As
Begin
	select VisitTypeID, Descript from tblVisitType
End