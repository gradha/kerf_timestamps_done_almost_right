import time_seconds, strutils, parseutils

type
  Stamp* = distinct int

# Bunch of methods we borrow to allow mixing stamps with seconds.
proc `+`*(x: Stamp, y: Second): Stamp {.borrow.}
proc `+`*(x: Second, y: Stamp): Stamp {.borrow.}


const
  year_start = 0
  month_start = "YYYY-".len
  days_start = "YYYY-MM-".len
  epoch_offset = 1970
  days_in_a_month = 30 # Because I'm worth it…


proc date*(x: string): Stamp =
  ## Converts a random string into a timestamp value.
  ##
  ## For simplicity this is just a naive implementation that will easily break
  ## under the weight of any real user input, there is no real user friendly
  ## validation here. We expect strings to be in the format YYYY-MM-DD and
  ## that's it.
  assert x.len == 10
  var token: string
  do_assert 4 == x.parse_while(token, Digits, year_start)
  var
    yyyy: int
    mm: int
    dd: int
  do_assert 4 == token.parse_int(yyyy)
  do_assert yyyy >= epoch_offset

  do_assert 2 == x.parse_while(token, Digits, month_start)
  do_assert 2 == token.parse_int(mm)
  do_assert mm > 0 and mm < 13

  do_assert 2 == x.parse_while(token, Digits, days_start)
  do_assert 2 == token.parse_int(dd)
  do_assert dd > 0 and dd < 32

  # Finally, convert the individual values to a (fake) calendar.
  result = Stamp((yyyy - epoch_offset) * year +
    (mm - 1) * days_in_a_month * day + (dd - 1) * day)


proc `$`*(x: Stamp): string =
  ## Represents the time as a computer readable date.
  ##
  ## Because we really are not humans, are we? If we were I would have to deal
  ## with regions and locale and all that bulsh…KILL ALL HUMANS.
  var total = Second(x)
  let seconds = total mod minute
  total = total - seconds

  let minutes = total mod hour
  total = total - minutes

  let hours = total mod day
  total = total - hours

  let
    days = total mod year
    years = (total - days) div year

  result = $(epoch_offset + years) & "."

  # Convert days to numbers for final in year calculations.
  var numeric_days = days div day
  let numeric_months = numeric_days div days_in_a_month
  numeric_days = numeric_days mod days_in_a_month

  result &= align($(1 + numeric_months), 2, '0') & "." &
    align($(1 + numeric_days), 2, '0')


proc test_stamps*() =
  echo "Testing stamps"
  let a = "2012-01-02".date
  echo "let's start at ", a
  echo "plus one day is ", a + 1.d
  echo "plus one month is ", a + 1.m
