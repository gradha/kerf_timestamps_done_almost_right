# Implementation of seconds, used for time differences.
import time_nanos, time_stamp, sequtils

proc test_blog_examples() =
  echo "Showing blog examples.\n"

  let a = "2012.01.01".date
  echo "Example 1: ", a
  echo "Example 2:"
  echo "\t", a + 1.d
  echo "\t", "2012.01.01".date + 1.d
  echo "Example 3: ", "2012.01.01".date + 1.m + 1.d + 1.h + 15.i + 17.s

  let
    r = to_seq(0 .. <10)
    offsets = r.map_it(Nano, (1.m + 1.d + 1.h + 15.i + 17.s) * it)
    values = offsets.map_it(Stamp, "2012.01.01".date + it)

  echo "Example 4: ", values

  echo "…again but compressed… ", to_seq(0 .. <10)
      .map_it(Nano, (1.m + 1.d + 1.h + 15.i + 17.s) * it)
      .map_it(Stamp, "2012.01.01".date + it)

  echo "…using helper procs… ",
    "2012.01.01".date + (1.m + 1.d + 1.h + 15.i + 17.s) * (0 .. <10)

  echo "Example 5 b[week]: ", values.map_it(int, it.week)
  echo "Example 5 b[second]: ", values.map_it(int, it.second)

  echo "\nDid all examples."

proc main() =
  test_seconds()
  test_stamps()
  test_blog_examples()

when isMainModule: main()
