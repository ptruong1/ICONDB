CREATE TABLE [dbo].[tblTabletCenter] (
    [CenterID]        INT           NOT NULL,
    [FacilityID]      INT           NOT NULL,
    [CenterName]      VARCHAR (35)  NULL,
    [PINRequired]     BIT           NOT NULL,
    [DayTimeRestrict] BIT           NOT NULL,
    [userName]        VARCHAR (25)  NULL,
    [ModifyDate]      SMALLDATETIME NULL,
    [inputDate]       SMALLDATETIME NULL,
    [CenterStatus]    TINYINT       CONSTRAINT [DF__tblTablet__Cente__25FC62E4] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblTabletCenter] PRIMARY KEY CLUSTERED ([CenterID] ASC)
);

