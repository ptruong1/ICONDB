﻿CREATE TABLE [dbo].[tblInmateLegalRequest] (
    [FormID]          INT          NOT NULL,
    [Status]          TINYINT      CONSTRAINT [DF_tblInmateLegalRequest_Status] DEFAULT ((1)) NOT NULL,
    [FacilityID]      INT          NOT NULL,
    [InmateID]        VARCHAR (12) NOT NULL,
    [BookingNo]       VARCHAR (15) NULL,
    [HousingUnit]     VARCHAR (20) NULL,
    [AgencyID]        TINYINT      NOT NULL,
    [OtherAgency]     VARCHAR (50) NULL,
    [Sentence]        BIT          NULL,
    [LawyerRepresent] BIT          NULL,
    [LawyerType]      TINYINT      NULL,
    [CAcriminal]      BIT          NULL,
    [CAcivil]         BIT          NULL,
    [FEDcriminal]     BIT          NULL,
    [FEDcivil]        BIT          NULL,
    [ICE]             BIT          NULL,
    [Administrative]  BIT          NULL,
    [OtherState]      VARCHAR (50) NULL,
    [OtherCase]       VARCHAR (50) NULL,
    [NextCourtDate]   DATETIME     NULL,
    [RequestDate]     DATETIME     NULL,
    [RecordDate]      DATETIME     CONSTRAINT [DF_tblInmateLegalRequest_RecordDate] DEFAULT (getdate()) NULL,
    [ReceivedDate]    DATETIME     NULL,
    [ReceivedBy]      VARCHAR (20) NULL,
    [SendDate]        DATETIME     NULL,
    [SendBy]          VARCHAR (20) NULL,
    [TrackingNo]      VARCHAR (20) NULL,
    [IDX]             VARCHAR (20) NULL,
    [CourtCert]       BIT          NULL,
    CONSTRAINT [PK_tblInmateLegalRequest] PRIMARY KEY CLUSTERED ([FormID] ASC)
);

