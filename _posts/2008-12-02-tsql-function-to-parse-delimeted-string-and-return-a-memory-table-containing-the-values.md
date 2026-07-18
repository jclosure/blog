---
layout: post
title: "TSQL function to parse delimeted string and return a memory table containing the values"
date: 2008-12-02 13:12:55 -0600
categories: []
tags: []
wordpress_id: 17
original_url: "https://joelholder.com/2008/12/02/tsql-function-to-parse-delimeted-string-and-return-a-memory-table-containing-the-values/"
---

This script is useful when you need to generate a rowset from a delimeted string. It allows the "WHERE IN" clause to be used against the values in the string, because they are converted into table rows. This UDF is designed to be plugged into other queries where this need is present. Here's an example of how to use it:

Basic Usage:

```sql
select VALUE from PARSE_STRING('a,b,c,d,e', ',')
GO
```

Real World Usage:

```sql
select * from customers where last_name in (select VALUE from PARSE_STRING('obama,biden,clinton,holder', ','))
GO
```

The Function:

```sql
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Joel Holder
-- Description: parses a delimeted string and returns a table
-- =============================================

/****** Object: UserDefinedFunction [dbo].[PARSE_STRING] ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARSE_STRING]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[PARSE_STRING]
go

CREATE FUNCTION PARSE_STRING (@string nvarchar(max), @delimeter char(1))
RETURNS @result_table TABLE (POSITION int, VALUE nvarchar(max))
AS
BEGIN

-- Fill the table variable with the rows for your result set
declare @pos int
declare @piece varchar(500)
declare @id int
set @id = 0
-- Need to tack a delimiter onto the end of the input string if one doesn't exist
    if right(rtrim(@string),1) <> @delimeter
    set @string = @string + @delimeter
    set @pos = patindex('%' + @delimeter + '%' , @string)
    while (@pos <> 0)
        begin
            set @id = @id + 1
            set @piece = left(@string, @pos - 1)
            -- You have a piece of data, so insert it, print it, do whatever you want to with it.
            insert into @result_table values (@id, @piece)
            set @string = stuff(@string, 1, @pos, '')
            set @pos = patindex('%' + @delimeter + '%' , @string)
        end

return
END
GO
```
