# Implementation of seconds, used for time differences.
type
  Second* = distinct int

proc `<`*(x: Second, y: int): bool {.borrow.}
proc `<`*(x: int, y: Second): bool {.borrow.}
proc `<=`*(x: Second, y: int): bool {.borrow.}
proc `<=`*(x: int, y: Second): bool {.borrow.}
proc `mod`*(x: Second, y: int): int {.borrow.}
proc `mod`*(x: int, y: Second): int {.borrow.}
proc `div`*(x: Second, y: int): int {.borrow.}
proc `div`*(x: int, y: Second): int {.borrow.}
proc `+`*(x, y: Second): Second {.borrow.}
proc `-`*(x, y: Second): Second {.borrow.}

proc `*`*(x: Second, y: int): Second = Second(int(x) * y)
proc `*`*(x: int, y: Second): Second = Second(x * int(y))


const
  second* = Second(1)
  minute* = Second(60)
  hour* = minute * 60
  day* = 24 * hour
  year* = day * 365


# Conversion procs to the Second distinct type.
proc s*(x: int): Second {.inline.} = Second(x)
proc m*(x: int): Second {.inline.} = x * minute
proc h*(x: int): Second {.inline.} = x * hour
proc d*(x: int): Second {.inline.} = x * day
proc y*(x: int): Second {.inline.} = x * year

proc `$`*(x: Second): string =
  ## Represents the time difference as a human readable string.
  ##
  ## The proc tries to be optimal in size, so it won't display zeroed units.
  assert x >= 0
  if x < 1:
    return "0s"

  var
    seconds = x mod 60
    minutes = x div 60

  result = (if 0 == seconds: "" else: $seconds & "s")
  if minutes < 1:
    return

  var hours = minutes div 60
  minutes = minutes mod 60

  result = (if 0 == minutes: result else: $minutes & "m" & result)
  if hours < 1:
    return

  let days = hours div 24
  hours = hours mod 24

  result = (if 0 == hours: result else: $hours & "h" & result)
  if days < 1:
    return

  result = $days & "d" & result


const
  composed_difference = 1.h + 23.m + 45.s
  composed_string = $composed_difference


proc test_seconds*() =
  # Just some tests for the blog, should output:
  #
  # 1s = 1s
  # 1m1s = 1m1s
  # 1h = 1h
  # 1h23m45s = 1h23m45s = 1h23m45s
  # 1d = 1d
  # 365d = 365d
  echo "Testing second operations:"
  echo second, " = ", 1.s
  echo minute + second, " = ", 1.m + 1.s
  echo hour, " = ", 1.h
  echo 1.h + 23.m + 45.s, " = ", composed_difference, " = ", composed_string
  echo day, " = ", 1.d
  echo year, " = ", 1.y
