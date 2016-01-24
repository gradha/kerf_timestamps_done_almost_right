import
  bb_nake, bb_os, bb_system

proc run() =
  direShell nim_exe, "c", "-o:units.exe", "-r", "units"

task defaultTask, "run":
  run()
