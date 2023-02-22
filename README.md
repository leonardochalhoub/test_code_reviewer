# test_code_reviewer

- **Task 1. Working with data**
    
    To complete this task, use the data set in the attached file. Indicate the answer to each of the
    following steps and time to complete the entire task.
    
    1.1. Download the data set movie_metadata.csv, which contains data about films from IMDb
    (Internet Movie Database).
    
    [movie_metadata.csv]
    
    1.2. The duration column contains data on the film length. How many missing values are there
    in this column?
    
    1.3. Replace the missing values in the duration column with the median value for this column.
    
    1.4. What is the average film length? Give the answer as a floating-point figure rounded to
    two decimal places.
    
    1.5. Create a movie_duration_category column, which will contain three categories
    depending on the film length:
    • Category "1. <90" if the film is less than 90 minutes long
    • Category "2. 90–120" if the film is between 90 minutes and two hours long (inclusively)
    • Category "3. >120" if the film is more than two hours long
    
    1.6. Build a summary table for films released after 2000 (inclusively), to list the numbers of
    films:
    • Table rows: year
    • Table columns: movie duration category ("<90", "90–120", ">120")
    • The year of release should be displayed in the YYYY format.
    
    1.7. How many films between 90 minutes and two hours long were released in 2008?
    
    1.8. The plot_keywords column holds keywords characterizing the film's plot. Using the data
    in this column, create a column called movie_plot_category, to contain four categories
    depending on the key words in the column:
    • Category "love_and_death" if the keywords include both "love" and "death"
    • Category "love" if the keywords include the word "love"
    • Category "death" if the keywords include the word "death"
    • Category "other" if the keywords do not meet the conditions above
    
    1.9. The imdb_score column shows a viewer rating for the film. Build a table to reflect the
    average rating of films depending on which movie_plot_category category they belong to.
    
    1.10. What is the average rating of films in the "love" category? Give the answer as a floating point figure rounded to two decimal places.
    
    1.11. The budget column contains the film's budget. What is the median budget for all the films listed? Give the answer as an integer.
    
- **Task 2. Problem-solving**
    
    To complete this task, use the data set in the attached file. Indicate the answer to each of the
    following steps and time to complete the entire task.
    
    [event_data.csv]
    
    1. Download the event_data.csv dataset, which contains data on the use of the mobile
    application of users who registered from July 29 to September 1, 2019:
    • user_id - user identifier;
    • event_date - time of the event;
    • event_type - type of event: registration - registration in the application; 
    simple_event - click event in the application; purchase - an event of purchase within the application; purchase_amount - purchase amount.
    
    2. Highlight user cohorts based on the week of registration in the application. The cohort
    identifier should be the week ordinal (for example, the week from July 29 to August 4
    should have identifier 31).
    
    3. How many unique users in the cohort with ID 33?
    
    4. For each event, highlight the indicator lifetime - the weekly lifetime of the cohort. The
    lifetime indicator is calculated based on the serial number of the week in which the event
    is committed, relative to the week of registration. For example, an event committed on
    August 3 by a user from a cohort of registrants at 31 weeks will be committed on the zero
    week of lifetime, and an event committed by the same user on August 5 will be committed
    on the first week of lifetime).
    
    5. Build a summary table of changes in the Retention Rate for cohorts depending on lifetime.
    
    6. What is the 3 week retention rate for a cohort with ID 32? Give the answer in percent,
    rounded to 2 decimal places, inclusive.
    
    7. Build a summary table of changes in the indicator ARPPU (Average Revenue Per Paying
    User) for cohorts depending on lifetime.
    
    8. What is the 3-week ARPPU of a cohort with ID 31? Give the answer with a floating point
    number, rounded to 2 decimal places, inclusive.
    
    9. What is the median time between user registration and first purchase? Give the answer
    in seconds (!) As an integer.
    
- **Task 3. Answering student questions**
    
    How would you answer the student's question below? Your task is to get your message across in such a way that a beginner can understand your explanation. You can do this any way you want (pictures, GIFs, metaphors, anything) so long as it makes your explanation clear. Indicate how much time you spent completing this task.
    
    > **What is the difference between DataFrame and Series?**

- **Task 4.**

    You are given two random variables X and Y.

    E(X) = 0.5, Var(X) = 2

    E(Y) = 7, Var(Y) = 3.5

    cov (X, Y) = -0.8

    Find the variance of the random variable Z = 2X - 3Y
    
- **Task 5.**
    
    Omer trained a linear regression model and tested its performance on a test sample of 500 objects. On 400 of those, the model returned a prediction higher than expected by 0.5, and on the remaining 100, the model returned a prediction lower than expected by 0.7.
    
    What is the MSE for his model?
    
    Limor claims that the linear regression model wasn't trained correctly, and we can do improve it by changing all the answers by a constant value. What will be her MSE?
    
    You can assume that Limor found the smallest error under her constraints.
    
    **Return two values - Omer's and Limor's MSE.**