-- 1. ) What are the names of all the customers who live in New York?

SELECT
CONCAT(Firstname, " ", Lastname) as Full_Name,
City
FROM Customers
WHERE
City = "New York";

-- 2. ) What is the total number of accounts in the Accounts table?

SELECT
COUNT(AccountID) as Total_Accounts
FROM Accounts;

-- 3. ) What is the total balance of all checking accounts?

SELECT
AccountType,
SUM(Balance) AS Total_Balance
FROM Accounts
WHERE
AccountType = "Checking";

-- 4. ) What is the total balance of all accounts associated with customers who live in Los Angeles?

SELECT
C.City,
SUM(A.Balance) as Total_Balance
FROM Customers C
JOIN Accounts A USING(customerID)
WHERE C.City = "Los Angeles"
GROUP BY 1;

-- 5. Which branch has the highest average account balance?

SELECT
BranchName,
Avg_Balance
FROM(
	SELECT
	B.BranchName,
	AVG(A.Balance) as Avg_Balance,
    DENSE_RANK() OVER (ORDER BY SUM(A.Balance) DESC) AS Balance_Dense_Rank
	FROM Branches B
	JOIN Accounts A USING(BranchID)
	GROUP BY 1
) Balance_Rank
	WHERE Balance_Dense_Rank = 1;



-- 6. ) Which customer has the highest current balance in their accounts?

SELECT
CONCAT(C.Firstname, " ", C.Lastname) AS Full_Name,
MAX(A.Balance) AS Highest_Balance
FROM Customers C
JOIN Accounts A USING(CustomerID)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 7. ) Which customer has made the most transactions in the Transactions table?

SELECT
 FullName,
 Total_Transactions
FROM (
  SELECT
    CONCAT(C.Firstname, " ", C.Lastname) AS FullName,
    COUNT(T.TransactionID) AS Total_Transactions,
    DENSE_RANK() OVER (ORDER BY COUNT(T.TransactionID) DESC) AS Transaction_Dense_Rank
  FROM Customers C
  JOIN Accounts A USING(CustomerID)
  JOIN Transactions T USING(AccountID)
  GROUP BY 1
) Ranked_Customers
WHERE Transaction_Dense_Rank = 1;

-- 8. ) Which branch has the highest total balance across all of its accounts?

SELECT
BranchName,
Total_Balance
FROM (
  SELECT
    B.BranchName,
    SUM(A.Balance) AS Total_Balance,
    DENSE_RANK() OVER (ORDER BY SUM(A.Balance) DESC) AS Balance_Rank
  FROM Branches B
  JOIN Accounts A USING(BranchID)
  GROUP BY B.BranchName
) Ranked_Balance
WHERE Balance_Rank = 1;


-- 9. )Which customer has the highest total balance across all of their accounts, including savings and checking accounts?

SELECT
Full_Name,
Total_Balance
FROM (
	SELECT
		CONCAT(C.Firstname, " ", C.Lastname) AS Full_Name,
		SUM(A.Balance) AS Total_Balance,
		DENSE_RANK() OVER (ORDER BY SUM(A.Balance) DESC) AS Balance_Rank
    FROM Customers C
    JOIN Accounts A USING(CustomerID)
    WHERE A.AccountType IN ("Checking", "Savings")
    GROUP BY 1
)   Ranked_Balance 
WHERE Balance_Rank = 1;

-- 10. ) Which branch has the highest number of transactions in the Transactions table?

SELECT
 BranchName,
 Total_Transactions
FROM (
  SELECT
    B.BranchName,
    COUNT(T.AccountID) AS Total_Transactions,
    DENSE_RANK() OVER (ORDER BY COUNT(T.AccountID) DESC) AS Transaction_Dense_Rank
  FROM Branches B
  JOIN Accounts A USING(BranchID)
  JOIN Transactions T USING(AccountID)
  GROUP BY 1
) Ranked_Branches
WHERE Transaction_Dense_Rank = 1;