import time_nanos, strutils, parseutils

type
  Stamp* = distinct int

# Bunch of methods we borrow to allow mixing stamps with seconds.
proc `+`*(x: Stamp, y: Nano): Stamp {.borrow.}
proc `+`*(x: Nano, y: Stamp): Stamp {.borrow.}
proc `-`*(x: Stamp, y: Nano): Stamp {.borrow.}
proc `-`*(x: Nano, y: Stamp): Stamp {.borrow.}

const
  year_start = "".len
  month_start = "YYYY-".len
  days_start = "YYYY-MM-".len
  hours_start = "YYYY-MM-DDT".len
  minutes_start = "YYYY-MM-DDThh:".len
  seconds_start = "YYYY-MM-DDThh:mm:".len
  nanos_start = "YYYY-MM-DDThh:mm:ss:".len
  max_stamp_len = "YYYY-MM-DDThh:mm:ss:012345678".len
  epoch_offset = 1970
  days_in_a_month = 30 # Because I'm worth it…


proc year*(x: Stamp): int {.inline.} = Nano(x).year + epoch_offset
proc week*(x: Stamp): int {.inline.} = Nano(x).week
proc month*(x: Stamp): int {.inline.} = Nano(x).month
proc day*(x: Stamp): int {.inline.} = Nano(x).day
proc hour*(x: Stamp): int {.inline.} = Nano(x).hour
proc minute*(x: Stamp): int {.inline.} = Nano(x).minute
proc second*(x: Stamp): int {.inline.} = Nano(x).second
proc microsecond*(x: Stamp): int {.inline.} = Nano(x).microsecond
proc millisecond*(x: Stamp): int {.inline.} = Nano(x).millisecond
proc nanosecond*(x: Stamp): int {.inline.} = Nano(x).nanosecond


proc date*(x: string): Stamp =
  ## Converts a random string into a timestamp value.
  ##
  ## For simplicity this is just a naive implementation that will easily break
  ## under the weight of any real user input, there is no real user friendly
  ## validation here. We expect strings to be in the format YYYY-MM-DD and
  ## that's it. Ok, maybe we allow times later too…
  assert x.len >= 10 and x.len <= max_stamp_len
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
  result = Stamp((yyyy - epoch_offset) * u_year +
    (mm - 1) * days_in_a_month * u_day + (dd - 1) * u_day)

  if x.len < minutes_start - 1:
    return

  # Ugh, we got some times… ok, try to parse them.
  var hh: int
  do_assert 2 == x.parse_while(token, Digits, hours_start)
  do_assert 2 == token.parse_int(hh)
  do_assert hh >= 0 and hh < 24
  result = result + hh.h

  if x.len < seconds_start - 1:
    return

  var minutes: int
  do_assert 2 == x.parse_while(token, Digits, minutes_start)
  do_assert 2 == token.parse_int(minutes)
  do_assert minutes >= 0 and minutes < 60
  result = result + minutes.i

  if x.len < nanos_start - 1:
    return

  var seconds: int
  do_assert 2 == x.parse_while(token, Digits, seconds_start)
  do_assert 2 == token.parse_int(seconds)
  do_assert seconds >= 0 and seconds < 60
  result = result + seconds.s

  if x.len > nanos_start:
    var nanos: int
    var num_nanos = x.parse_while(token, Digits, nanos_start)
    do_assert num_nanos > 0 and num_nanos < 10
    do_assert num_nanos == token.parse_int(nanos)
    # Compensate lack of decimals during parsing with pow-like loop.
    while num_nanos < 9:
      nanos = nanos * 10
      num_nanos.inc
    result = result + Nano(nanos)


proc `$`*(x: Stamp): string =
  ## Represents the time as a computer readable date.
  ##
  ## Because we really are not humans, are we? If we were I would have to deal
  ## with regions and locale and all that bulsh…KILL ALL HUMANS.
  var total = Nano(x)
  let seconds = total mod u_minute
  total = total - seconds

  let minutes = total mod u_hour
  total = total - minutes

  let hours = total mod u_day
  total = total - hours

  let
    days = total mod u_year
    years = (total - days) div u_year

  result = $(epoch_offset + years) & "."

  # Convert days to numbers for final in year calculations.
  var numeric_days = days div u_day
  let numeric_months = numeric_days div days_in_a_month
  numeric_days = numeric_days mod days_in_a_month

  result &= align($(1 + numeric_months), 2, '0') & "." &
    align($(1 + numeric_days), 2, '0')

  let
    numeric_seconds = seconds div u_second
    numeric_minutes = minutes div u_minute
    numeric_hours = hours div u_hour
    numeric_nanos = int(seconds mod u_second)

  # Return already if the time ends at midnight.
  if numeric_seconds < 1 and numeric_minutes < 1 and
      numeric_hours < 1 and numeric_nanos < 1:
    return

  # Aww… format an hour then.
  result &= "T" & align($numeric_hours, 2, '0') &
    ":" & align($numeric_minutes, 2, '0') &
    ":" & align($numeric_seconds, 2, '0')

  if numeric_nanos > 0:
    result &= "." & align($numeric_nanos, 9, '0')


# Helper procs to map lists.
proc `+`*(x: Stamp, y: seq[Nano]): seq[Stamp] =
  result.new_seq(y.len)
  var pos = 0
  while pos < y.len:
    result[pos] = x + y[pos]
    pos.inc


proc test_stamps*() =
  echo "Testing stamps\n"
  var a = "2012-01-01".date
  echo "let's start at ", a
  echo "plus one day is ", a + 1.d
  echo "plus one month is ", a + 1.m
  echo "plus one month and a day is ", a + 1.m + 1.d
  echo "…plus 1h15i17s ", a + 1.m + 1.d + 1.h + 15.i + 17.s
  echo "…plus 23 hours ", a + 1.m + 2.d - 1.h
  echo "2001.01.01T01".date
  echo "2001.01.01T02:01".date
  echo "2001.01.01T03:02:01".date
  echo "2001.01.01T04:09:02.1".date
  echo "2001.01.01T04:09:02.12".date
  echo "2001.01.01T04:09:02.123".date
  echo "2001.01.01T05:04:03.0123".date
  echo "2001.01.01T06:05:04.012345678".date
  a = "2001.01.01T06:05:04.012345678".date
  echo "\tyear ", a.year
  echo "\tmonth ", a.month
  echo "\tday ", a.day
  echo "\thour ", a.hour
  echo "\tminute ", a.minute
  echo "\tsecond ", a.second
  echo "\tmicrosecond ", a.microsecond
  echo "\tmillisecond ", a.millisecond
  echo "\tnanosecond ", a.nanosecond