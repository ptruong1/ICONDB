CREATE TABLE [dbo].[tblMileageCode] (
    [state]       CHAR (2)     NOT NULL,
    [lowR]        SMALLINT     NOT NULL,
    [highR]       SMALLINT     NOT NULL,
    [mileageCode] VARCHAR (5)  NOT NULL,
    [description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblMileageCode] PRIMARY KEY CLUSTERED ([state] ASC, [mileageCode] ASC)
);

