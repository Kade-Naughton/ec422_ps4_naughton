library(tidyverse)
library(fpp3)
library(BVAR)

# read data
liquor_raw <- read_csv(
  "data/MRTSSM4453USN.csv",
  na = ".",
  col_types = cols(
    observation_date = col_date(format = "%Y-%m-%d"),
    MRTSSM4453USN = col_double()
  )
)

liquor <- liquor_raw |>
  transmute(Month = yearmonth(observation_date), sales = MRTSSM4453USN) |>
  as_tsibble(index = Month) |>
  filter(Month <= yearmonth("2019 Dec"))

has_gaps(liquor)

# season/sales plot
liquor |>
  autoplot(sales) +
  labs(title = "U.S. Retail Sales at Beer, Wine, and Liquor Stores",
       x = "Month", y = "Millions of dollars (NSA)")

liquor |>
  mutate(log_sales = log(sales)) |>
  gg_season(log_sales) +
  labs(title = "Season Plot of log(Liquor Store Sales)",
       x = "Month", y = "log(sales)")