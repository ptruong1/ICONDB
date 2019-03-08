-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_send_Email] 
@ApmNo int,
@Reason varchar(40)	
AS
BEGIN
	DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>Cancel Confirmation</H1>' +
    N'<table border="1">' +
    N'<tr><th>Visit Confirmation</th><th>Cancel Reason</th>' +
    N'<th>Visitor</th><th>Inmate</th><th>VisitDate Date</th>' +
    N'<th>Visit Time</th></tr>' +
    CAST ( ( SELECT td =ApmNo ,       '',
                    td = @Reason, '',
                    td = v.VLastName, '',
                    td = InmateName, '',
                    td = ApmDate, '',
                    td = ApmTime
              FROM tblVisitEnduserSchedule as E
              JOIN tblvisitors AS v
              ON E.VisitorID  = V.VisitorID
              WHERE ApmNo=@ApmNo
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' + '</br> <p> Please Keep this email for your record!  </p>'  ;
    

EXEC msdb.dbo.sp_send_dbmail @recipients='ptruong@golegacy.com',@profile_name='LegacyInmate',
    @subject = 'Visit Cancel',
    @body = @tableHTML,
    @body_format = 'HTML' ;
END

