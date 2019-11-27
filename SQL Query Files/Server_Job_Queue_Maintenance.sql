delete top (1) JQ
output DELETED.Id, DELETED.JobId, DELETED.Queue
from [tasks].JobQueue JQ with (readpast, updlock, rowlock, forceseek)
where Queue in (@queues1) and (FetchedAt is null or FetchedAt < DATEADD(second, @timeout, GETUTCDATE()))
