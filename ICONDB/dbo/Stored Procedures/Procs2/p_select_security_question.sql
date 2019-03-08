CREATE PROCEDURE [dbo].[p_select_security_question]
@questionID tinyint OUTPUT,
@question varchar(150) OUTPUT
AS
SET NOCOUNT ON
SET @questionID = rand()*6
If(@questionID =0 ) SET @questionID=1
else If(@questionID >4 ) SET @questionID=5
select  @questionID = questionID, @question=question  from tblPWSecurityQ  where questionID = @questionID
