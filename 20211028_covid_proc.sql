USE [PortfolioProject]
GO
/****** Object:  StoredProcedure [dbo].[BLD_WRK_covid_death]    Script Date: 2021-10-28 11:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Amir Taha
-- Create date: 20211020
-- Description:	RAW -> WRK
-- =============================================
ALTER PROC [dbo].[BLD_WRK_covid_death]   
AS
BEGIN
-- =============================================
-- Drop Table
-- =============================================
if OBJECT_ID('WRK_covid_death') is not null
drop table [WRK_covid_death]

-- =============================================
-- Create table 
-- =============================================

create table [WRK_covid_death] 
(
[RowNumber]                           int identity (1,1)
	,[iso_code]                       varchar(50)
	,[continent]                      varchar(50)
    ,[location]                       varchar(50)
    ,[date]                           Date 
    ,[population]                     float
    ,[total_cases]                    float
    ,[new_cases]                      float
    ,[total_deaths]                   float
    ,[new_deaths]                     float
    ,[total_cases_per_million]        float
    ,[new_cases_per_million]          float
    ,[total_deaths_per_million]       float
	,[new_deaths_per_million]         float
    ,[reproduction_rate]              float
    ,[icu_patients]                   float
    ,[icu_patients_per_million]       float
    ,[hosp_patients]                  float
    ,[hosp_patients_per_million]      float
    ,[weekly_icu_admissions]          float
    ,[weekly_icu_admissions_per_million] float
    ,[weekly_hosp_admissions]         float
    ,[weekly_hosp_admissions_per_million] float
	  )

-- =============================================
-- truncate Table
-- =============================================
truncate table [WRK_covid_death]

-- =============================================
-- insert into Table
-- =============================================
insert into [WRK_covid_death]
(
                         
	 [iso_code]                      
	,[continent]                      
    ,[location]                       
    ,[date]                           
    ,[population]                     
    ,[total_cases]                    
    ,[new_cases]                      
    ,[total_deaths]                   
    ,[new_deaths]                     
    ,[total_cases_per_million]        
    ,[new_cases_per_million]          
    ,[total_deaths_per_million]       
	,[new_deaths_per_million]         
    ,[reproduction_rate]              
    ,[icu_patients]                   
    ,[icu_patients_per_million]       
    ,[hosp_patients]                  
    ,[hosp_patients_per_million]      
    ,[weekly_icu_admissions]          
    ,[weekly_icu_admissions_per_million] 
    ,[weekly_hosp_admissions]         
    ,[weekly_hosp_admissions_per_million] 
)

select 
	 [iso_code]                      
	,[continent]                      
    ,[location]                       
    ,[date]                           
    ,[population]                     
    ,[total_cases]                    
    ,[new_cases]                      
    ,[total_deaths]                   
    ,[new_deaths]                     
    ,[total_cases_per_million]        
    ,[new_cases_per_million]          
    ,[total_deaths_per_million]       
	,[new_deaths_per_million]         
    ,[reproduction_rate]              
    ,[icu_patients]                   
    ,[icu_patients_per_million]       
    ,[hosp_patients]                  
    ,[hosp_patients_per_million]      
    ,[weekly_icu_admissions]          
    ,[weekly_icu_admissions_per_million] 
    ,[weekly_hosp_admissions]         
    ,[weekly_hosp_admissions_per_million] 

	from [dbo].[covid_death]


END
