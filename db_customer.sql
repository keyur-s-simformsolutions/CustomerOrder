USE [db_customer]
GO
/****** Object:  Table [dbo].[Agents]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Agents](
	[AgentCode] [int] IDENTITY(1,1) NOT NULL,
	[AgentName] [nvarchar](max) NULL,
	[WorkingArea] [nvarchar](50) NULL,
	[Commission] [decimal](18, 2) NULL,
	[PhoneNo] [nchar](10) NULL,
	[Country] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AgentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerCode] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[CustomerCity] [nvarchar](max) NULL,
	[WorkingArea] [nvarchar](max) NULL,
	[CustomerCountry] [nvarchar](max) NULL,
	[Grade] [nvarchar](max) NULL,
	[OpeningAmount] [decimal](18, 2) NULL,
	[ReceivingAmount] [decimal](18, 2) NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[OutstandingAmount] [decimal](18, 2) NULL,
	[PhoneNo] [varchar](10) NULL,
	[AgentCode] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderNum] [int] IDENTITY(1,1) NOT NULL,
	[OrderAmount] [decimal](18, 2) NULL,
	[AdvanceAmount] [decimal](18, 2) NULL,
	[OrderDate] [date] NULL,
	[CustomerCode] [int] NOT NULL,
	[OrderDescription] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_ToTable] FOREIGN KEY([AgentCode])
REFERENCES [dbo].[Agents] ([AgentCode])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_ToTable]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_ToTable] FOREIGN KEY([CustomerCode])
REFERENCES [dbo].[Customer] ([CustomerCode])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_ToTable]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Agent]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Delete_Agent] 
    @AgentCode int

AS
begin 
delete from Agents where AgentCode = @AgentCode

end 
GO
/****** Object:  StoredProcedure [dbo].[Delete_Customer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Delete_Customer] 
    @CustomerCode int

AS
begin 
delete from Customer where CustomerCode = @CustomerCode

end
GO
/****** Object:  StoredProcedure [dbo].[Delete_Order]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Delete_Order] 
    @OrderNum int

AS

   Begin
        DECLARE @RemainingAmount int;
        DECLARE @OrderAmount int;
        DECLARE @AdvanceAmount int;
        DECLARE @CustomerCode int;
        
        select @OrderAmount =OrderAmount from Orders where OrderNum=@OrderNum
        select @AdvanceAmount =AdvanceAmount from Orders where OrderNum=@OrderNum
        select @CustomerCode =CustomerCode from Orders where OrderNum=@OrderNum
        
        delete from [Orders]  where [Orders].OrderNum = @OrderNum
        set @RemainingAmount = @OrderAmount - @AdvanceAmount
         update Customer
        set PaymentAmount = PaymentAmount - @AdvanceAmount, OutstandingAmount =  OutstandingAmount - @RemainingAmount where Customer.CustomerCode =@CustomerCode



end 
GO
/****** Object:  StoredProcedure [dbo].[Get_AllOrder]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_AllOrder]
    @CustomerCode int = 0
AS
    select o.*,c.FirstName+' '+c.LastName as CustomerName,c.CustomerCity ,ag.AgentName,c.OpeningAmount
from Orders o
inner join Customer c  on o.CustomerCode=c.CustomerCode

inner join Agents ag on ag.AgentCode=c.AgentCode
where
(@CustomerCode=0 or c.CustomerCode=@CustomerCode)
order by o.OrderDate asc,c.FirstName asc
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[GetById_Agent]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[GetById_Agent]
@AgentCode int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select * from Agents where AgentCode = @AgentCode
END
GO
/****** Object:  StoredProcedure [dbo].[GetById_Customer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[GetById_Customer]
   @CustomerCode int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

select * from Customer where CustomerCode = @CustomerCode
END
GO
/****** Object:  StoredProcedure [dbo].[GetById_Order]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[GetById_Order]
   @OrderNum int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

select * from Orders where OrderNum= @OrderNum
END
GO
/****** Object:  StoredProcedure [dbo].[GetData_Customer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[GetData_Customer]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select * from Customer
END
GO
/****** Object:  StoredProcedure [dbo].[GetData_Order]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[GetData_Order]
 @search nvarchar(max) =NULL,
   @cityname nvarchar(max)=NULL,
    @sdate nvarchar(max)=NULL,
    @edate nvarchar(max)=NULL,
	@PageSize int =5,
    @PageNumber int = 1,
	@SortOrder nvarchar(max),
	@SortColumn nvarchar(max),
    @PossibleRows int output
AS


    Begin
        set nocount on;
        Declare @SkipRows int = (@PageNumber - 1) * @PageSize;
		 select @possiblerows= sum(t1.CO)
from(
    select  COUNT(distinct o.CustomerCode) as CO
    from Orders o 
    inner join Customer c  on o.CustomerCode=c.CustomerCode

    inner join Agents a on a.AgentCode=c.AgentCode
    where 
   (@search='' or c.FirstName like '%'+@search+'%' or c.LastName like '%'+@search+'%' or o.OrderDescription like '%'+@search+'%')
and (@cityname='' or c.CustomerCity=@cityname)
and (@sdate=''  or o.OrderDate>=@sdate)
and (@edate=''  or o.OrderDate<=@edate)
    group by o.OrderDate,o.CustomerCode,c.FirstName,c.LastName,a.AgentName) as t1

 
 select SUM(o.OrderAmount) as OrderAmount,SUM(o.AdvanceAmount) AdvanceAmount,o.CustomerCode,o.OrderDate,
c.FirstName+' '+c.LastName as CustomerName,c.CustomerCity,a.AgentName
from Orders o 
inner join Customer c  on o.CustomerCode=c.CustomerCode

inner join Agents a on a.AgentCode=c.AgentCode

 
 where 
(@search='' or c.FirstName like '%'+@search+'%' or c.LastName like '%'+@search+'%' or o.OrderDescription like '%'+@search+'%')
and (@cityname='' or c.CustomerCity=@cityname)
and (@sdate=''  or o.OrderDate>=@sdate)
and (@edate=''  or o.OrderDate<=@edate)
 group by o.OrderDate,o.CustomerCode,c.FirstName,c.LastName,a.AgentName,c.CustomerCity
order by 
case when (@SortColumn='fullname' and @SortOrder='ASC') then c.FirstName 
end asc,
case when (@SortColumn='fullname' and @SortOrder='DESC') then c.FirstName 
end desc,
case when (@SortColumn='OrderAmount' and @sortOrder='ASC') then SUM(o.OrderAmount)
end asc,
case when (@SortColumn='OrderAmount' and @sortOrder='DESC') then SUM(o.OrderAmount)
end desc,
case when (@SortColumn='AdvanceAmount' and @sortOrder='ASC') then SUM(o.AdvanceAmount)
end asc,
case when (@SortColumn='AdvanceAmount' and @sortOrder='DESC') then SUM(o.AdvanceAmount)
end desc,
case when (@SortColumn='OrderDate' and @sortOrder='ASC') then o.OrderDate 
end asc,
case when (@SortColumn='OrderDate' and @sortOrder='DESC') then o.OrderDate
end desc,
case when (@SortColumn='city' and @sortOrder='ASC') then c.CustomerCity
end asc,
case when (@SortColumn='city' and @sortOrder='DESC') then c.CustomerCity
end desc,
case when (@SortColumn='AgentName' and @sortOrder='ASC') then a.AgentName 
end asc,
case when (@SortColumn='AgentName' and @sortOrder='DESC') then a.AgentName
end desc

    OFFSET @SkipRows ROWS
            FETCH NEXT @PageSize ROWS ONLY
        return
    End
GO
/****** Object:  StoredProcedure [dbo].[GetDataAgents]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE  [dbo].[GetDataAgents]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select * from Agents
END
GO
/****** Object:  StoredProcedure [dbo].[GetDataCustomer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[GetDataCustomer]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select * from Customer
END
GO
/****** Object:  StoredProcedure [dbo].[Insert_Order]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Insert_Order]
@OrderNum int,
@OrderAmount decimal(18,2),
@AdvanceAmount decimal(18,2),
@OrderDate date,
@CustomerCode int,
@OrderDescription nvarchar(max)
AS
if(@OrderNum=0)
begin
    declare @com int;
select @com= A.Commission from Agents A inner join Customer c on c.AgentCode = a.AgentCode

	Insert into Orders(OrderAmount,AdvanceAmount,OrderDate,CustomerCode,OrderDescription) 
	values(@OrderAmount,@AdvanceAmount,@OrderDate,@CustomerCode,@OrderDescription )

	update Customer set PaymentAmount = @OrderAmount,ReceivingAmount= @OrderAmount*@com/100,OutstandingAmount = @OrderAmount-@AdvanceAmount where CustomerCode = @CustomerCode

end
else
 update Orders Set OrderAmount= @OrderAmount,AdvanceAmount=@AdvanceAmount,OrderDate=@OrderDate,OrderDescription=@OrderDescription where OrderNum=@OrderNum

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[InsertUpdateAgent]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[InsertUpdateAgent] 
    @AgentCode int,
	@AgentName nvarchar(max),
	@WorkingArea nvarchar(max),
	@Commission  decimal(18,2),
	@PhoneNo nvarchar(10),
	@Country nvarchar(max)
	 
AS
begin 
 if(@AgentCode=0)
BEGIN
	Insert into Agents(AgentName,WorkingArea,Commission,PhoneNo,Country) values (@AgentName,@WorkingArea,@Commission,@PhoneNo,@Country)
END
else 
  update Agents set AgentName=@AgentName,WorkingArea=@WorkingArea,Commission=@Commission,PhoneNo=@PhoneNo,Country=@Country where AgentCode=@AgentCode

end 
GO
/****** Object:  StoredProcedure [dbo].[InsertUpdateCustomer]    Script Date: 31-03-2021 10:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertUpdateCustomer]
	@CustomerCode int,
	@FirstName nvarchar(max),
	@Lastname nvarchar(max),
	@CustomerCity nvarchar(max),
	@WorkingArea nvarchar(max),
	@CustomerCountry nvarchar(max),
	@Grade nvarchar(max),
	@OpeningAmount decimal(18,2),
  @Phone nvarchar(max),
	@AgentCode int
AS
begin
if(@CustomerCode=0)
begin
	Insert into Customer (FirstName,LastName,CustomerCity,WorkingArea,CustomerCountry,Grade,OpeningAmount,ReceivingAmount,PaymentAmount,OutstandingAmount,PhoneNo,AgentCode) 
	values(@FirstName,@Lastname,@CustomerCity,@WorkingArea,@CustomerCountry,@Grade,@OpeningAmount,0,0,0,@Phone,@AgentCode)
end

  else
        update Customer
        set FirstName=@FirstName,
        LastName=@LastName,
        CustomerCity=@CustomerCity,
        WorkingArea=@WorkingArea,
        CustomerCountry=@CustomerCountry,
        Grade=@Grade,
        OpeningAmount=@OpeningAmount,
		PhoneNo=@Phone,
        AgentCode=@AgentCode
        where CustomerCode=@CustomerCode
end

RETURN 0
GO
