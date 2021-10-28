set nocount on
declare @i int
declare @s varchar(100)

set @i = 100000000

while @i > 0 

begin
       select @s = @@version;
       set @i = @i - 1;
end