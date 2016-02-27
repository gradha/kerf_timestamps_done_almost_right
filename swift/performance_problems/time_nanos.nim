type Nano* = distinct int64

proc `+`*(x, y: Nano): Nano {.borrow.}
proc `*`*(x: Nano, y: int64): Nano = Nano(int64(x) * y)
proc `*`*(x: int64, y: Nano): Nano = Nano(x * int64(y))

const
  u_nano* = Nano(1)
  u_second* = Nano(1_000_000_000)
  u_minute* = u_second * 60

proc ns*(x: int64): Nano {.inline.} = Nano(x)
proc s*(x: int64): Nano {.inline.} = x * u_second
proc i*(x: int64): Nano {.inline.} = x * u_minute

proc `$`*(x: Nano): string = $(int64(x))
proc `&`*(x: Nano, y: string): string = $x & y
proc `&`*(x: string, y: Nano): string = x & $y


proc test_seconds*() =
  echo "Testing second operations:\n"
  echo u_minute + u_second + Nano(500), " = ", 1.i + 1.s + 500.ns
  echo u_minute + u_second + Nano(500) & " = " & 1.i + 1.s + 500.ns

test_seconds()
