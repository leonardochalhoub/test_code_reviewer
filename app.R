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
                     
                  