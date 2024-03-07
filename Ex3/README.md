#  Query a MySQL database

This repository provides instructions for setting up a MySQL container, importing data into the "company" database, creating a user, and finding the average salary for each department.

## Prerequisites

- Docker installed on your machine.


## Steps

1. **Pull MySQL Image:**

```bash
   docker pull mysql:latest
```
This command downloads the latest MySQL Docker image from the official Docker Hub repository. The image serves as the base for creating a MySQL container.

2.  **Run MySQL Container:**

   ```bash
  docker run -d --name mysql-company -e MYSQL_ROOT_PASSWORD=3012 -p 3307:3306 mysql:latest
```
This command creates and starts a Docker container named "mysql-company" with MySQL. It sets the root password using the -e option and maps the container's port 3307 to the host machine's port 3306.

3. **Copy "company.sql" into Container:**

```bash
  docker cp company.sql mysql-company:/root
```
This copies the given "company.sql" file from the local machine into the "/root" directory of the running MySQL container.

4. **Access MySQL Container and Navigate to /root Directory:**

```bash
 docker exec -it mysql-company /bin/bash
 cd /root
 ls
```
This command allows you to access the shell inside the running MySQL container. You will use this shell to navigate and execute commands within the container. We moved to /root directory within the container because this is the location where  the "company.sql" file is copied.
The command 'ls' is used to make sure that 'company.sql' is in this directory.

5. ** Enter MySQL Shell:**
```bash
mysql -uroot -pcompany company < company.sql 
```
This command initiates the MySQL shell. Make sure to also provide the password set when creating the SQL container to avoid errors.

6. **Create "company" Database and Import Data:**
```bash
USE company;
source company.sql;
```
Switch to the "company" database and import data from the "company.sql" file.

7. **Create User and Grant Permissions:**
```bash
CREATE USER 'Alexandra'@'%';
GRANT ALL PRIVILEGES ON company.* TO 'Alexandra'@'%';
FLUSH PRIVILEGES;
```
After running the commands from above, to make sure that all privileges were granted to the user 'Alexandra' I logged in using 'mysql -u Alexandra -p' command, then used the following SQL query 'SHOW GRANTS FOR 'Alexandra'@'%';'.


8. **Find Average Salary for Each Department:**
```bash
USE company;

SELECT department, AVG(salary) AS average_salary
FROM employees
GROUP BY department;

```
*SELECT department*: This part of the query specifies that the values will be retrieved from the "department" column.

*AVG(salary) AS average_salary*: This part calculates the average salary (AVG(salary)) for each group of rows with the same "department" value. The result is labeled as "average_salary".

*FROM employees*: Specifies the table from which to retrieve the data. In this case, it's the "employees" table.

*GROUP BY department*: It groups the rows in the "employees" table based on the values in the "department" column. After grouping, the AVG(salary) function is applied separately to each group, calculating the average salary for each department.
The results are:

| department | average_salary |
|------------|----------------|
|      1     | 60000.000000   |
|      2     | 75111.111111   |
|      3     | 53666.666667   |
|      4     | 67250.000000   |
|      5     | 51500.000000   |
|      6     | 63500.000000   |
|      7     | 83000.000000   |
|      8     | 58500.000000   |


