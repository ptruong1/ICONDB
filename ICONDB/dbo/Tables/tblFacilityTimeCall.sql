CREATE TABLE [dbo].[tblFacilityTimeCall] (
    [FacilityID] INT           NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME CONSTRAINT [DF_tblFacilityTimeCall_inputdate] DEFAULT (getdate()) NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblFaciltiyTimeCall] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [days] ASC)
);

