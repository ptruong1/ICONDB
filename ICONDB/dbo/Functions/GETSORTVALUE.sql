CREATE FUNCTION dbo.GETSORTVALUE(@value NVARCHAR)
RETURNS INT
BEGIN
    DECLARE @dummyValue INT = LEN(9)
    -- do something with your string here to get a sorting number
    RETURN @dummyValue
END