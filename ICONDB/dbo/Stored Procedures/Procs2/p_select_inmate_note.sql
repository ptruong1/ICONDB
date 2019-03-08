
CREATE PROCEDURE [dbo].[p_select_inmate_note]
@FacilityID as integer,
@NoteTypeID as integer

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 
   select NoteID, FacilityID,InmateID, Note, InputDate,UserName, Descript  from tblInmateNote a inner join tblNoteType b on a.NoteTypeID = b.NoteTypeID
   where facilityID= @FacilityID and a.NoteTypeID =@NoteTypeID
    order by InputDate desc;
END


