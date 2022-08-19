

select sum("Actual principal balances as of the day") as loanbook_size
from dbo.loan_performances
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A'

-- loanbook size


select sum("ArrearsBalance") as total_arrears_balance
from dbo.loan_performances
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A' and "ArrearsBalance" > 0

-- total arrears amount

select count(RecordID) as Total_Loans_Active
from dbo.loan_performances
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A'

--total loans active


select sum("Loan Amount Requested") 
from dbo.loan_performances a
join dbo.loan_info b
on a.RecordID = b.RecordID
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A'

--gross loanbook size

select count(Delinquency) as Total_Delinquent_Accounts
from dbo.loan_performances
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A' and Delinquency > 0

--total delinquent accounts

select *
from dbo.loan_performances a
join dbo.loan_info b
on a.RecordID = b.RecordID
join dbo.customer_info c
on b.RecordID = c.RecordID
where "Snapshot Date" = '2021-10-31 00:00:00.000' and "Account Status" = 'A'

-- join all 3 tables at the most recent snapshot date

select distinct "snapshot date"
from dbo.loan_performances
order by [Snapshot Date]

select distinct "Snapshot Date", round(sum("Actual principal balances as of the day")over(partition by "Snapshot Date"), 2)  as loanbook_size
from dbo.loan_performances
where "Account Status" = 'A'
order by "Snapshot Date"

--loanbook size by month for visualisation

