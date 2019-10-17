SELECT TOP(1) txtSubmitBy 
From TblReportsStore 
WHERE txtSubmitBy = @P1 AND intProgress BETWEEN @P2 and @P3 ; 
