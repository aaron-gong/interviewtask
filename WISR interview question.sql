\
select distinct RecordID as "30+@3 customers"
from (
		select RecordID, Delinquency, "Snapshot Date", "loan_month_duration"
		from (
			select RecordID, DATEDIFF(month, min("Snapshot Date") OVER(partition by RecordID), c."Snapshot Date") as loan_month_duration, c.Delinquency, "Snapshot Date"
			from (
				select a.RecordID, ArrearsBalance, "Snapshot Date", "Write Off Date", Delinquency
				from dbo.loan_performances a
				INNER JOIN dbo.loan_info b
				on a.RecordID = b.RecordId
						) c
					) d
		where Delinquency >= 2 and loan_month_duration <=3) e

-- datediff was used along with a window function to calculate how long a loan was active for. Used Snapshot date minus minimum snapshot date, output is in months. 
-- from there parameters of Deliquency >= 2 and months < 3 were used to calculate 30+@3
-- assumed that the first snapshot date is the month of the loan settling, there aren't any other useable dates in the data. 
-- end result was 28 unique customers


select distinct RecordID as "30+@3 customers" into "30+@3"
from (
		select RecordID, Delinquency, "Snapshot Date", "loan_month_duration"
		from (
			select RecordID, DATEDIFF(month, min("Snapshot Date") OVER(partition by RecordID), c."Snapshot Date") as loan_month_duration, c.Delinquency, "Snapshot Date"
			from (
				select a.RecordID, ArrearsBalance, "Snapshot Date", "Write Off Date", Delinquency
				from dbo.loan_performances a
				INNER JOIN dbo.loan_info b
				on a.RecordID = b.RecordId
						) c
					) d
		where Delinquency >= 2 and loan_month_duration <=3) e

-- creating new table for easier analysis. 


select b.RecordID, "Credit Score"
from dbo.[30+@3] a
inner join dbo.customer_info b
on a."30+@3 customers" = b.RecordID

-- getting 30+@3 client's credit scores

select distinct b.RecordID, cast(min("Snapshot Date") over(partition by RecordID) as date) as "loan_settlement_month"
from dbo.[30+@3] a
inner join dbo.loan_performances b
on a."30+@3 customers" = b.RecordID
order by loan_settlement_month asc

-- getting 30+@3 client's settlement months 



select STDEV("Credit Score") as "Standard Deviation", avg("Credit Score") as "Mean"
from dbo.loan_performances a
INNER JOIN dbo.customer_info b
on a.RecordID = b.RecordId

--figuring out standard deviation and mean of approved clients to create credit score buckets.

select distinct "Snapshot Date"
from dbo.loan_performances
order by "Snapshot Date" asc

--figuring out how many months are included in dataset. 

select a."RecordID","Credit Score" 
from dbo.customer_info a
JOIN dbo.loan_info b
on a.RecordID = b.RecordID
where "Status" = 'Settled'

-- getting all settled client's data + credit score
