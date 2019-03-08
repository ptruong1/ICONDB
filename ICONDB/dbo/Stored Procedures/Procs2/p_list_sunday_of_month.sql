-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_list_sunday_of_month]
	@Year int
AS
BEGIN
SET @Year = 2016

;WITH Months AS (
	-- Create a month numbers CTE
	SELECT 1 AS MonthNumber
	UNION ALL SELECT 2
	UNION ALL SELECT 3
	UNION ALL SELECT 4
	UNION ALL SELECT 5
	UNION ALL SELECT 6
	UNION ALL SELECT 7
	UNION ALL SELECT 8
	UNION ALL SELECT 9
	UNION ALL SELECT 10
	UNION ALL SELECT 11
	UNION ALL SELECT 12
	UNION ALL SELECT 13
),
Dates AS (
	-- Find first day of month
	SELECT monthNumber,
		firstDayOfMonth = DATEADD(month, monthNumber - 1, CONVERT(datetime, CAST(@Year as char(4)) + '0101', 112))
	FROM Months
),
MonthRange AS (
	-- Find last day of month
	SELECT *, lastDayOfMonth = (
		SELECT TOP 1 
			DATEADD(day, -1, firstDayOfMonth)
		FROM Dates
		WHERE MonthNumber = D.MonthNumber + 1
	)
	FROM Dates  AS D 
	WHERE monthNumber <= 12
)
SELECT *, firstSunday = (
		SELECT TOP 1
			DATEADD(day, monthNumber -1, firstDayOfMonth) 
		FROM Months
		WHERE DATEPART(weekday, DATEADD(day, monthNumber -1, firstDayOfMonth)) = 1
		ORDER BY monthNumber
	),
	lastSaturday = (
		SELECT TOP 1
			DATEADD(day, (-1) * (monthNumber -1), lastDayOfMonth) 
		FROM Months
		WHERE DATEPART(weekday, DATEADD(day, (-1) * (monthNumber -1), lastDayOfMonth)) = 7
		ORDER BY monthNumber
	)
FROM MonthRange



;WITH cteCalendar(FirstOfMonth, LastOfMonth)
AS (
	SELECT	DATEADD(MONTH, 12 * @Year + number - 22801, 6) AS FirstOfMonth,
		DATEADD(MONTH, 12 * @Year + number - 22800, -1) AS LastOfMonth
 	FROM	master..spt_values
	WHERE	TYPE = 'P'
		AND number BETWEEN 1 AND 12
)
SELECT	DATEADD(DAY, DATEDIFF(DAY, 6, FirstOfMonth) / 7 * 7, 6) AS FirstSunday,
	DATEADD(DAY, DATEDIFF(DAY, 5, LastOfMonth) / 7 * 7, 5) AS LastSaturday
FROM	cteCalendar
END

