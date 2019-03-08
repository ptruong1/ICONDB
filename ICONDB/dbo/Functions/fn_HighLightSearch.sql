-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_HighLightSearch](@contents NVARCHAR(MAX), 
  @searchTerm NVARCHAR(4000), @style NVARCHAR(4000), @maxLen INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @c NCHAR(1)
    DECLARE @len INT = 0
    DECLARE @l INT = 0
    DECLARE @p INT = 0
    DECLARE @prevPos INT = 0
    DECLARE @margin INT
    DECLARE @term NVARCHAR(4000)
    DECLARE @retval NVARCHAR(MAX) = ''
    DECLARE @var NVARCHAR(4000)
	SET @var=N'FORMSOF(FREETEXT, "' + @searchTerm + '")'
    DECLARE @positions TABLE
    (
        S INT,
        L INT
    )

    -- find all occurrences of the search term

    DECLARE cur1 CURSOR FOR
    SELECT display_term FROM sys.dm_fts_parser(@var, 1033, 0, 1)

    
    OPEN cur1
    FETCH NEXT FROM cur1 INTO @term

    WHILE @@FETCH_STATUS = 0
    BEGIN
        WHILE 1 = 1
        BEGIN
            SET @p = CHARINDEX(@term, @contents, @p)
            IF @p <= 0 BREAK
            
            SET @l = LEN(@term)
            
            IF @p > 0 BEGIN
                SET @c = SUBSTRING(@contents, @p - 1, 1)
                IF @c <> ' ' AND @c <> NCHAR(9) AND 
                   @c <> NCHAR(13) AND @c <> NCHAR(10) BREAK
            END
            
            INSERT INTO @positions (S, L) VALUES(@p, @l)
            SET @p = @p + LEN(@term)
        END
        
        FETCH NEXT FROM cur1 INTO @term   
    END   

    CLOSE cur1
    DEALLOCATE cur1
    
    -- build the result string
    
    DECLARE cur2 CURSOR FOR
    SELECT S, MAX(L)
    FROM @positions
    GROUP BY S
    ORDER BY S 
    
    SET @margin = LOG(@maxLen) * 5
    IF @margin > @maxLen / 4 SET @margin = @maxLen / 4
    SELECT @prevPos = MIN(S) - @margin FROM @positions

    OPEN cur2
    FETCH NEXT FROM cur2 INTO @p, @l

    WHILE @@FETCH_STATUS = 0 AND @len < @maxLen
    BEGIN
        SET @retval = @retval + SUBSTRING(@contents, @prevPos, @p - @prevPos)
        SET @retval = @retval + '<span style="' + @style + '">' + SUBSTRING(@contents, @p, @l)  + '</span>'
        SET @len = @len + @p - @prevPos + @l
        SET @prevPos = @p + @l
        
        FETCH NEXT FROM cur2 INTO @p, @l
    END   

    CLOSE cur2
    DEALLOCATE cur2

    SET @margin = LOG(@maxLen) * 5
    IF @margin + @len < @maxLen SET @margin = @maxLen - @len
    IF @margin > 0 SET @retval = @retval + SUBSTRING(@contents, @prevPos, @l)

    RETURN '...' + @retval + '...'
END

