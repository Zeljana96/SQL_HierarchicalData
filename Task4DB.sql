USE [Task4DB]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 11/10/2020 10:43:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeId] [int] NOT NULL,
	[FirstName] [nvarchar](25) NOT NULL,
	[JobTitle] [nvarchar](50) NULL,
 CONSTRAINT [PK_Employee_EmployeeId] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee_path]    Script Date: 11/10/2020 10:43:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_path](
	[Id] [int] NOT NULL,
	[Ancestor] [int] NOT NULL,
	[Descendant] [int] NOT NULL,
	[NumLevels] [int] NOT NULL,
 CONSTRAINT [PK_Employee_path_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee_path]  WITH CHECK ADD  CONSTRAINT [FK_Employee_path_Employee_Ancestor] FOREIGN KEY([Ancestor])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Employee_path] CHECK CONSTRAINT [FK_Employee_path_Employee_Ancestor]
GO
ALTER TABLE [dbo].[Employee_path]  WITH CHECK ADD  CONSTRAINT [FK_Employee_path_Employee_Descendant] FOREIGN KEY([Descendant])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Employee_path] CHECK CONSTRAINT [FK_Employee_path_Employee_Descendant]
GO
/****** Object:  StoredProcedure [dbo].[FilteredEmployees]    Script Date: 11/10/2020 10:43:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FilteredEmployees] @Id int
AS
	 SELECT EmployeeId, FirstName, JobTitle, NumLevels, CASE 
														WHEN EmployeeId = 1 THEN NULL
														ELSE SuperiorName
														END AS SuperiorName
FROM
    (SELECT  EmployeeId, FirstName, JobTitle, NumLevels, Ancestor
	FROM (SELECT e.EmployeeId, e.FirstName, e.JobTitle, p.NumLevels
		FROM Employee e INNER JOIN Employee_path p ON e.EmployeeId = p.Descendant
		WHERE p.Ancestor = @Id) AS temp1
		INNER JOIN 
		(SELECT Id, Ancestor, Descendant
		FROM Employee_path 
		WHERE NumLevels = 1 OR Id = 1) AS temp2 ON temp1.EmployeeId = temp2.Descendant) as RelationWithoutSuperiorName
		INNER JOIN 
		(SELECT EmployeeId as SuperiorId, FirstName AS SuperiorName
		FROM Employee) as proba1
		ON proba1.SuperiorId = RelationWithoutSuperiorName.Ancestor 
		
GO
