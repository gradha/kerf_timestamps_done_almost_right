## Implementation of nanos, used for time differences.
type
  Nano* = distinct int64 ## Our new super type. Super native. Super… yes.

# Bunch of methods we borrow from plain integers. They are mostly one liners,
# but sometimes even one line is too much.
proc `<`*(x: Nano, y: int64): bool {.borrow.}
proc `<`*(x: int64, y: Nano): bool {.borrow.}
proc `<=`*(x: Nano, y: int64): bool {.borrow.}
proc `<=`*(x: int64, y: Nano): bool {.borrow.}
proc `mod`*(x: Nano, y: int64): int64 {.borrow.}
proc `mod`*(x: int64, y: Nano): int64 {.borrow.}
proc `mod`*(x: Nano, y: Nano): Nano {.borrow.}
proc `div`*(x: Nano, y: int64): int64 {.borrow.}
proc `div`*(x: int64, y: Nano): int64 {.borrow.}
proc `div`*(x: Nano, y: Nano): int64 {.borrow.}
proc `+`*(x, y: Nano): Nano {.borrow.}
proc `-`*(x, y: Nano): Nano {.borrow.}


# Proper multiplication of nanoseconds.
proc `*`*(x: Nano, y: int64): Nano = Nano(int64(x) * y)
proc `*`*(x: int64, y: Nano): Nano = Nano(x * int64(y))


# Define some constants for testing and human reference.
# U stands for unit. C stands for cookie.
const
  u_nano* = Nano(1)
  u_second* = Nano(1_000_000_000)
  u_minute* = u_second * 60
  u_hour* = u_minute * 60
  u_day* = 24 * u_hour
  u_month* = 30 * u_day
  u_year* = u_day * 365


# Conversion procs to the Nano distinct type.
proc ns*(x: int64): Nano {.inline.} = Nano(x)
proc s*(x: int64): Nano {.inline.} = x * u_second
proc i*(x: int64): Nano {.inline.} = x * u_minute
proc h*(x: int64): Nano {.inline.} = x * u_hour
proc d*(x: int64): Nano {.inline.} = x * u_day
proc m*(x: int64): Nano {.inline.} = x * u_month
proc y*(x: int64): Nano {.inline.} = x * u_year

# These return the specific time units.
proc year*(x: Nano): int {.procvar.} =
  result = int(x div u_year)

proc month*(x: Nano): int {.procvar.} =
  result = int(x div u_day)
  result = (result mod 365)
  result = 1 + (result mod 12)

proc week*(x: Nano): int {.procvar.} =
  result = int(x div u_day)
  result = (result mod 365)
  result = 1 + (result div 7)

proc day*(x: Nano): int {.procvar.} =
  result = int(x div u_day)
  result = (result mod 365)
  result = 1 + (result mod 30)

proc hour*(x: Nano): int {.procvar.} =
  result = int(x div u_hour)
  result = result mod 24

proc minute*(x: Nano): int {.procvar.} =
  result = int(x div u_minute)
  result = result mod 60

proc second*(x: Nano): int {.procvar.} =
  result = int(x div u_second)
  result = result mod 60

proc millisecond*(x: Nano): int {.procvar.} =
  result = int(x mod u_second) div 1_000_000

proc microsecond*(x: Nano): int {.procvar.} =
  result = int(x mod u_second) div 1_000

proc nanosecond*(x: Nano): int {.procvar.} =
  result = int(x mod u_second)


proc `$`*(x: Nano): string =
  ## Represents the time difference as a human readable string.
  ##
  ## The proc tries to be optimal in size, so it won't display zeroed units.
  assert x >= 0
  if x < 1:
    return "0s"

  var
    nano = x mod 1_000_000_000
    seconds = (x div 1_000_000_000) mod 60
    minutes = x div 60_000_000_000

  result = (if 0 == nano: "" else: $nano & "ns")
  result = (if 0 == seconds: result else: $seconds & "s" & result)
  if minutes < 1:
    return

  var hours = minutes div 60
  minutes = minutes mod 60

  result = (if 0 == minutes: result else: $minutes & "m" & result)
  if hours < 1:
    return

  var days = hours div 24
  hours = hours mod 24

  result = (if 0 == hours: result else: $hours & "h" & result)
  if days < 1:
    return

  let years = days div 365
  days = days mod 365

  result = (if 0 == days: result else: $days & "d" & result)
  if years < 1:
    return

  result = $years & "y" & result

# Combination of strings the proper way, avoid overloading + operator.
proc `&`*(x: Nano, y: string): string = $x & y
proc `&`*(x: string, y: Nano): string = x & $y


# Helper procs to map lists.
proc `*`*(x: Nano, y: Slice[int]): seq[Nano] =
  let total_len = y.b - y.a + 1
  result.new_seq(total_len)
  var pos = 0
  while pos < total_len:
    result[pos] = x * (pos + y.a)
    pos.inc


const
  composed_difference = 1.h + 23.i + 45.s
  composed_string = $composed_difference


proc test_seconds*() =
  echo "Testing second operations:\n"
  echo Nano(500), " = ", 500.ns
  echo u_second, " = ", 1.s
  echo u_minute + u_second + Nano(500), " = ", 1.i + 1.s + 500.ns
  # Replicates swift line to compare speed…
  echo u_minute + u_second + Nano(500) & " = " & 1.i + 1.s + 500.ns
  echo u_hour, " = ", 1.h
  echo 1.h + 23.i + 45.s, " = ", composed_difference, " = ", composed_string
  echo u_day, " = ", 1.d
  echo u_year, " = ", 1.y
  echo u_year - 1.d

  let a = composed_difference + 3.y + 6.m + 4.d + 12_987.ns
  echo "total ", a
  echo "\tyear ", a.year
  echo "\tmonth ", a.month
  echo "\tday ", a.day
  echo "\thour ", a.hour
  echo "\tminute ", a.minute
  echo "\tsecond ", a.second
