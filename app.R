# **Task 1. Working with data**

# 1.1. Download the data set movie_metadata.csv, which contains data about films from IMDb (Internet Movie Database).
link_movie_metadata <-
  paste0(
    'https://s3.us-west-2.amazonaws.com/secure.notion-static.com/',
    'ad88c1ae-a16a-4a9b-a0dd-a12ecc5a9568/movie_metadata.csv?',
    'X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=',
    'UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230221',
    '%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230221T121244Z&X-Amz',
    '-Expires=86400&X-Amz-Signature=942cec4c0eaa979194c3c339d752010a9970',
    'e2b3775011366ba1e62f59e456f7&X-Amz-SignedHeaders=host&response-content',
    '-disposition=filename%3D%22movie_metadata.csv%22&x-id=GetObject'
  )

movie_df <- readr::read_csv(link_movie_metadata,
                            col_names = TRUE)

# 1.2. The duration column contains data on the film length. How many missing values are there in this column?
colnames(movie_df)

sprintf('There are %s missing values in the Duration column',
        sum(is.na(movie_df$duration)))

# 1.3. Replace the missing values in the duration column with the median value for this column.

movie_df$durationAdjusted <- ifelse(
  is.na(movie_df$duration),
  median(movie_df$duration, na.rm = TRUE),
  movie_df$duration
)

sprintf('There are %s missing values in the Duration column',
        sum(is.na(movie_df$durationAdjusted)))

# 1.4. What is the average film length? Give the answer as a floating-point figure rounded to two decimal places.

sprintf(
  'The average Duration/Length %s and %s for the Adjusted Duration',
  format(round(mean(
    movie_df$duration, na.rm = TRUE
  ), 2), nsmall = 2),
  format(round(
    mean(movie_df$durationAdjusted, na.rm = TRUE), 2
  ), nsmall = 2)
)

# 1.5. Create a movie_duration_category column, which will contain three categories depending on the film length:
#   • Category "1. <90" if the film is less than 90 minutes long
#   • Category "2. 90–120" if the film is between 90 minutes and two hours long (inclusively)
#   • Category "3. >120" if the film is more than two hours long

movie_df <- movie_df |>
  dplyr::mutate(
    movie_duration_category =
      dplyr::case_when(
        durationAdjusted < 90 ~ '1. <90',
        durationAdjusted <= 120 ~ '2. 90-120',
        .default = '3. >120'
      )
  )

# 1.6. Build a summary table for films released after 2000 (inclusively), to list the numbers of films:
# • Table rows: year
# • Table columns: movie duration category ("<90", "90–120", ">120")
# • The year of release should be displayed in the YYYY format.

summary_1 <- movie_df |> 
  dplyr::filter(title_year >= 2000) |> 
  dplyr::group_by(title_year, movie_duration_category) |> 
  dplyr::summarise(n = dplyr::n()) |> 
  tidyr::pivot_wider(names_from = movie_duration_category,
                     values_from = n)

# 1.7. How many films between 90 minutes and two hours long were released in 2008?

summary_2 <- movie_df |> 
  dplyr::filter(title_year == 2008,
                movie_duration_category %in% c('2. 90-120')) |> 
  dplyr::group_by(title_year) |> 
  dplyr::summarise(n = dplyr::n())

sprintf('There are %s films between 90 minutes and 2 hours long released in 2008',
        summary_2$n)  

# 1.8. The plot_keywords column holds keywords characterizing the film's plot. Using the data
#     in this column, create a column called movie_plot_category, to contain four categories
#     depending on the key words in the column:
#     • Category "love_and_death" if the keywords include both "love" and "death"
#     • Category "love" if the keywords include the word "love"
#     • Category "death" if the keywords include the word "death"
#     • Category "other" if the keywords do not meet the conditions above

movie_df <- movie_df |>
  dplyr::mutate(
    movie_plot_category =
      dplyr::case_when(
        movie_df$plot_keywords %in% stringr::str_subset(movie_df$plot_keywords, 'love') &
          movie_df$plot_keywords %in% stringr::str_subset(movie_df$plot_keywords, 'death')
        ~ 'love_and_death',
        movie_df$plot_keywords %in% stringr::str_subset(movie_df$plot_keywords, 'love')
        ~ 'love',
        movie_df$plot_keywords %in% stringr::str_subset(movie_df$plot_keywords, 'death')
        ~ 'death',
        .default = 'other'
      )
  )

# 1.9. The imdb_score column shows a viewer rating for the film. Build a table to reflect the
# average rating of films depending on which movie_plot_category category they belong to.

summary_plot_category <- movie_df |> 
  dplyr::group_by(movie_plot_category) |> 
  dplyr::summarise(average_rating = mean(imdb_score, na.rm = TRUE))

# 1.10. What is the average rating of films in the "love" category?
# Give the answer as a floating point figure rounded to two decimal places.

sprintf(
  'The average rating of filmes in the love category is %s.',
  round(
    summary_plot_category |>
      dplyr::filter(movie_plot_category %in% c('love')) |>
      dplyr::select(2),
    2
  )
)

# 1.11. The budget column contains the film's budget. What is the median budget for all the films listed?
# Give the answer as an integer.
movie_df <- movie_df |> 
  dplyr::mutate(budget_2 = as.numeric(stringr::str_replace_all(budget, "[^[:alnum:]]", ""))/10)

sprintf('The median budget for all the films listed is $ %s.',
        as.integer(median(movie_df$budget_2, na.rm = TRUE)))

# Task 2. Problem-solving

link_events_data <-
  paste0(
    'https://s3.us-west-2.amazonaws.com/secure.notion-static.com/',
    '3d249c69-fd8f-419f-8606-554c9a089cd7/event_data.csv?X-Amz-Algorithm',
    '=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-',
    'Credential=AKIAT73L2G45EIPT3X45%2F20230221%2Fus-west-2%2Fs3%2Faws4_',
    'request&X-Amz-Date=20230221T212108Z&X-Amz-Expires=86400&X-Amz-Signature',
    '=a5f66dc8edc62d2a5e40374690e7f29bb4f8a04c17ed95a3bae643acc21f13fd&X-Amz-',
    'SignedHeaders=host&response-content-disposition=filename%3D%22event_data.csv',
    '%22&x-id=GetObject'
  )

# 1. Download the event_data.csv dataset, which contains data on the use of the mobile
# application of users who registered from July 29 to September 1, 2019:
#   • user_id - user identifier;
# • event_date - time of the event;
# • event_type - type of event: registration - registration in the application; 
# simple_event - click event in the application; purchase - an event of purchase within the application; purchase_amount - purchase amount.

events_df <- readr::read_csv(link_events_data,
                             col_names = TRUE)

colnames(events_df)

# 2. Highlight user cohorts based on the week of registration in the application. The cohort
# identifier should be the week ordinal (for example, the week from July 29 to August 4
# should have identifier 31).

registrations_events_df <- events_df |>
  dplyr::mutate_at(dplyr::vars(event_date), as.Date) |> 
  dplyr::mutate(year = lubridate::year(event_date),
                month = lubridate::month(event_date),
                day = lubridate::day(event_date),
                week = lubridate::isoweek(event_date)) |> 
  dplyr::filter(event_type %in% c('registration')) |> 
  dplyr::select(1, 5, 6, 7, 'reg_week' = 8)

events_df <- events_df |>
  dplyr::mutate(week = lubridate::isoweek(event_date)) |> 
  dplyr::left_join(registrations_events_df, by = c('user_id'))

# 3. How many unique users in the cohort with ID 33?

week33Count <- events_df |> 
  dplyr::filter(reg_week == 33) |> 
  dplyr::group_by(reg_week) |> 
  dplyr::summarise(n_distinct = dplyr::n_distinct(user_id))

sprintf('There are %s unique users in the cohort with ID == 33.',
        week33Count$n_distinct)
        
# 4. For each event, highlight the indicator lifetime - the weekly lifetime of the cohort. The
# lifetime indicator is calculated based on the serial number of the week in which the event
# is committed, relative to the week of registration. For example, an event committed on
# August 3 by a user from a cohort of registrants at 31 weeks will be committed on the zero
# week of lifetime, and an event committed by the same user on August 5 will be committed
# on the first week of lifetime).

events_df <- events_df |> 
  dplyr::mutate(lifetime = week - reg_week)

# 5. Build a summary table of changes in the Retention Rate for cohorts depending on lifetime.

summary_3 <- events_df |> 
  dplyr::group_by(reg_week, lifetime) |> 
  dplyr::summarise(n_distinct = dplyr::n_distinct(user_id))

# a Retention Rate is asked, so I will use the lifetime == 0 as reference to new users
# the rate will be calculated by lifetime > 0 / initial value

base_user_count <- summary_3 |>
  dplyr::filter(lifetime == 0) |> 
  dplyr::select(1, 'n_user_begin' = 3)

summary_3 <- summary_3 |> 
  dplyr::left_join(base_user_count, by = c('reg_week')) |> 
  dplyr::ungroup() |> 
  dplyr::mutate(retentionRate = scales::percent(n_distinct / n_user_begin, accuracy = 0.01)) |> 
  dplyr::select(1, 2, 5) |> 
  tidyr::pivot_wider(names_from = reg_week,
                     values_from = retentionRate)

print(summary_3)

# 6. What is the 3 week retention rate for a cohort with ID 32? Give the answer in percent,
# rounded to 2 decimal places, inclusive.

answer_6 <- summary_3 |> 
  dplyr::filter(reg_week == 32,
                lifetime == 3) |> 
  dplyr::select(5)

sprintf('The 3 week retention rate for cohort ID == 32 is %s.',
        answer_6)

# 7. Build a summary table of changes in the indicator ARPPU (Average Revenue Per Paying
# User) for cohorts depending on lifetime.

totalPurchases <- events_df |> 
  dplyr::filter(event_type %in% c('purchase')) |> 
  dplyr::group_by(reg_week, lifetime) |> 
  dplyr::summarise(sum_purchases = sum(purchase_amount, na.rm = TRUE)) |> 
  dplyr::ungroup()

summary_4 <- summary_3 |> 
  dplyr::left_join(totalPurchases, by = c('reg_week', 'lifetime')) |> 
  dplyr::mutate(ARPPU = sum_purchases / n_distinct) |> 
  dplyr::select(1, 2, 7) |> 
  tidyr::pivot_wider(names_from = reg_week,
                     values_from = ARPPU)

print(summary_4)

# 8. What is the 3-week ARPPU of a cohort with ID 31? Give the answer with a floating point
# number, rounded to 2 decimal places, inclusive.

sprintf('The 3-week ARPPU of cohort ID == 31 is %s.',
        round(summary_4$`31`[4], 2))
  
# 9. What is the median time between user registration and first purchase? Give the answer
# in seconds (!) As an integer.     

reg_df <- events_df |> 
  dplyr::filter(event_type %in% c('registration')) |> 
  dplyr::rename('reg_date' = event_date)

purchase_df <- events_df |>
  dplyr::filter(event_type %in% c('purchase')) |> 
  dplyr::rename('purchase_date' = event_date) |>
  dplyr::arrange(purchase_date) |> 
  dplyr::group_by(user_id) |> 
  dplyr::slice_head(n = 1)

total_df <- events_df |> 
  dplyr::left_join(reg_df |> 
                     dplyr::select(1, 2),
                   by = c('user_id')) |> 
  dplyr::left_join(purchase_df |> 
                     dplyr::select(1, 2),
                   by = c('user_id')) |> 
  dplyr::mutate(diff_secs = as.double(difftime(purchase_date, reg_date, units='secs')),
                median_diff = median(diff_secs, na.rm = TRUE))

sprintf('The median time between user registration and first purchase is %s seconds.',
        total_df$median_diff[1])

# - **Task 3. Answering student questions**
#   
# How would you answer the student's question below?
# Your task is to get your message across in such a way 
# that a beginner can understand your explanation.
# You can do this any way you want (pictures, GIFs, metaphors, anything) so long as it makes your explanation clear. Indicate how much time you spent completing this task.

# Best answer I found:
#   https://www.includehelp.com/python/what-is-the-difference-between-a-pandas-series-and-a-dataframe.aspx

# "Both DataFrame and series are the two main data structure of pandas library.
# Series in pandas contains a single list which can store heterogeneous type of data, because of this,
# series is also considered as a 1-dimensional data structure.
# 
# On the other hand, DataFrame is a 2-dimensional data structure which contains multiple lists
# of heterogeneous type of data. DataFrame can contain multiple series or it can be considered as 
# a collection of series.
# 
# When we analyse a series, each value can be considered as a separate row of a single column, whereas when 
# we analyse a DataFrame, we have multiple columns and multiple rows."


# - **Task 4.**

# You are given two random variables X and Y.
# 
# E(X) = 0.5, Var(X) = 2
# 
# E(Y) = 7, Var(Y) = 3.5
# 
# cov (X, Y) = -0.8
# 
# Find the variance of the random variable Z = 2X - 3Y

# "Answer from ChatGPT
# We can start by using the properties of variances and covariances:
#   
#   Var(Z) = Var(2X - 3Y)
# 
# = Var(2X) + Var(-3Y) - 2Cov(2X, -3Y)
# 
# = 4Var(X) + 9Var(Y) - 12Cov(X,Y)
# 
# = 4(2) + 9(3.5) - 12(-0.8) (using the given values for X and Y)
# 
# = 8 + 31.5 + 9.6
# 
# = 49.1
# 
# Therefore, the variance of the random variable Z is 49.1."


# - **Task 5.**
#   
# Omer trained a linear regression model and tested its performance on a test sample of 500 objects. On 400 of those, 
# the model returned a prediction higher than expected by 0.5, and on the remaining 100, the model returned 
# a prediction lower than expected by 0.7.
# What is the MSE for his model?
#   
# Limor claims that the linear regression model wasn't trained correctly, and we can do improve it by changing all 
# the answers by a constant value. What will be her MSE?
# You can assume that Limor found the smallest error under her constraints.
# **Return two values - Omer's and Limor's MSE.**

# Answer from ChatGPT

# To calculate the mean squared error (MSE) for Omer's linear regression model, we need to first calculate the errors 
# for each prediction. The error for each prediction is the difference between the predicted value and the true value.
# 
# For the 400 objects where the model returned a prediction higher than expected by 0.5, the error is 0.5.
# For the 100 objects where the model returned a prediction lower than expected by 0.7, the error is -0.7.
# 
# The MSE is calculated as the average of the squared errors. So we first square each of the errors and then
# take the average:
# 
# MSE = (1/n) * ∑(y_i - yhat_i)^2
# 
# where n is the number of observations, y_i is the true value for the i-th observation, 
# and yhat_i is the predicted value for the i-th observation.
# 
# In this case, n = 500, and we have 400 observations with an error of 0.5 and 100 observations with an error 
# of -0.7. Let's assume that the expected value for all the observations is the same (we don't know what it is, but we don't need it for the calculation of the MSE).
# 
# Then, the MSE is:
#   
#   MSE = (1/500) * [400*(0.5^2) + 100*(-0.7)^2]
# 
# = (1/500) * [4000.25 + 1000.49]
# 
# = 0.197
# 
# Therefore, the MSE for Omer's linear regression model is 0.197.

# If Limor claims that the linear regression model wasn't trained correctly, and that we can improve it by 
# changing all the answers by a constant value, this means that she is proposing to add a constant value 
# to all the predicted values.
# 
# Let's say that the original predicted values are yhat_i and the corrected predicted values are yhat_i_new.
# Then, Limor's proposal is:
# 
# yhat_i_new = yhat_i + c
# 
# where c is the constant value that she proposes to add.
# 
# Adding a constant value to all the predicted values will not change the MSE, because the errors
# (the differences between the predicted values and the true values) will remain the same.
# 
# In other words, the MSE is calculated based on the squared errors, which are the differences
# between the predicted values and the true values, squared. Adding a constant value to all the predicted values will not change these differences, because the same constant value will be added to both the predicted and the true values. Therefore, the squared differences will remain the same, and so will the MSE.
# 
# So, if Limor's proposal does not change the MSE, the MSE will remain the same as before, which is 0.197, 
# as we calculated in the previous answer.