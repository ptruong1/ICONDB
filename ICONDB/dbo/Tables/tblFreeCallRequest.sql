CREATE TABLE [dbo].[tblFreeCallRequest] (
    [FacilityID]     INT           NOT NULL,
    [InmateID]       VARCHAR (12)  NOT NULL,
    [FreeCallNo]     TINYINT       NOT NULL,
    [RequestBy]      VARCHAR (20)  NOT NULL,
    [RequestNote]    VARCHAR (200) NULL,
    [RequestDate]    DATETIME      CONSTRAINT [DF_tblFreeCallRequest_RequestDate] DEFAULT (getdate()) NOT NULL,
    [FreeCallRemain] TINYINT       NULL
);

