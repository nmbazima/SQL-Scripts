-- Test_RegexMatches


USE AdventureWorks2014;
GO


--------------------------------------------------------------------------------
-- Test the function on its own
--
-- The regular expression pattern has the following parts:
--	[fd]	any single character in the set, ie f or d
--	o		literal o
--	[xg]	any single character in the set, ie x or g
--------------------------------------------------------------------------------

SELECT *
	FROM dbo.RegexMatches(N'The quick brown fox jumped over the lazy dog.', N'[fd]o[xg]');



--------------------------------------------------------------------------------
-- Search Product color
--
-- The regular expression pattern has the following parts:
--	Silver|Black	Silver or Black
--
--------------------------------------------------------------------------------

SELECT P.ProductID, P.Color, M.match
	FROM Production.Product AS P
		CROSS APPLY dbo.RegexMatches(P.Color, N'Silver|Black') AS M
	ORDER BY ProductID;


--------------------------------------------------------------------------------
-- Search ProductDescription for The and the following word
--
-- The regular expression pattern has the following parts:
--	[Tt]			any single character in the set, ie T or t
--	he				literal he and space
--	[A-Za-z0-9\-]+	one or more characters A-Z or a-z or 0-9 or hyphen
--
--------------------------------------------------------------------------------

SELECT P.ProductDescriptionID, P.[Description], M.match
	FROM Production.ProductDescription AS P
		CROSS APPLY dbo.RegexMatches(P.[Description], N'[Tt]he [A-Za-z0-9\-]+') AS M
	ORDER BY P.ProductDescriptionID;


--------------------------------------------------------------------------------
-- Search ProductDescription for numbers and the following word
--
-- The regular expression pattern has the following parts:
--	[0-9]+			one or more characters in the set 0 to 9
--  [ ]?			optional space
--	[A-Za-z0-9\-]+	one or more characters A-Z or a-z or 0-9 or hyphen
--
--------------------------------------------------------------------------------

SELECT P.ProductDescriptionID, P.[Description], M.match
	FROM Production.ProductDescription AS P
		CROSS APPLY dbo.RegexMatches(P.[Description], N'[0-9]+[ ]?[A-Za-z0-9\-]+') AS M
	ORDER BY P.ProductDescriptionID;


