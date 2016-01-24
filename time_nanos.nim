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
const
  second* = Nano(1_000_000_000)
  minute* = second * 60
  hour* = minute * 60
  day* = 24 * hour
  month* = 30 * day
  year* = day * 365


# Conversion procs to the Nano distinct type.
proc ns*(x: int64): Nano {.inline.} = Nano(x)
proc s*(x: int64): Nano {.inline.} = Nano(x * 1_000_000_000)
proc i*(x: int64): Nano {.inline.} = x * minute
proc h*(x: int64): Nano {.inline.} = x * hour
proc d*(x: int64): Nano {.inline.} = x * day
proc m*(x: int64): Nano {.inline.} = x * month
proc y*(x: int64): Nano {.inline.} = x * year

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


const
  composed_difference = 1.h + 23.i + 45.s
  composed_string = $composed_difference


proc test_seconds*() =
  # Just some tests for the blog, should output:
  #
  # 500ns = 500ns
  # 1s = 1s
  # 1m1s500s = 1m1s500s
  # 1h = 1h
  # 1h23m45s = 1h23m45s = 1h23m45s
  # 1d = 1d
  # 1y = 1y
  # 364d
  echo "Testing second operations:"
  echo Nano(500), " = ", 500.ns
  echo second, " = ", 1.s
  echo minute + second + Nano(500), " = ", 1.i + 1.s + 500.ns
  echo hour, " = ", 1.h
  echo 1.h + 23.i + 45.s, " = ", composed_difference, " = ", composed_string
  echo day, " = ", 1.d
  echo year, " = ", 1.y
  echo year - 1.d
