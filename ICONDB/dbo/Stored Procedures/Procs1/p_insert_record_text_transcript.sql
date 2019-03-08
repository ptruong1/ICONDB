-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_record_text_transcript]
@RecordID bigint,
@InmateText varchar(5000),
@ContactText varchar(5000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Insert tblCallsbilledText values(@RecordID , @InmateText, @ContactText);
    
END

