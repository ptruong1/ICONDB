CREATE TABLE [dbo].[tblDigitLeter] (
    [PhoneDigit] TINYINT  NOT NULL,
    [PhoneLeter] CHAR (1) NOT NULL,
    CONSTRAINT [PK_tblDigitLeter] PRIMARY KEY CLUSTERED ([PhoneDigit] ASC, [PhoneLeter] ASC)
);

