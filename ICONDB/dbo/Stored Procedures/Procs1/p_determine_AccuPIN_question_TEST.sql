﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_AccuPIN_question_TEST]
@FacilityID int,
@PIN varchar(12) , -- Or Inmate
@AccuQ		varchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @qID as tinyint, @qIDandAns varchar(12), @Ans varchar(5) ;
	SET @AccuQ ='';
	SET @qIDandAns  ='';
	DECLARE Ques_cursor CURSOR FOR
    SELECT top 3  QuestionID FROM tblAccuPIN where facilityID =@FacilityID  order by newID() ;
	OPEN Ques_cursor
	FETCH NEXT from Ques_cursor INTO  @qID  ;
	WHILE @@FETCH_STATUS =0
	 begin
		Set @Ans ='';
		select @Ans = 		 DBO.fn_getAccPIN(@facilityID, @PIN, @qID) ;
		if(  @Ans <>'' and isnumeric(@Ans) =1) 
			SET @qIDandAns=  CAST(@qID as varchar(2)) + '-' +  @Ans ;
		else
		 begin
				SET  @Ans ='';
				SET  @AccuQ  ='';
				break;
		 end
		if(@AccuQ  <> '')
			SET  @AccuQ  =  @AccuQ + '_' + @qIDandAns;
		else
			SET  @AccuQ  =  @qIDandAns;
		FETCH NEXT from Ques_cursor INTO  @qID  ; 
	 end
   CLOSE Ques_cursor;
   DEALLOCATE Ques_cursor;
   if(@AccuQ ='')
	 EXEC [dbo].[p_determine_AccuPIN_question_static] @FacilityID ,@PIN ,@AccuQ  OUTPUT

END

