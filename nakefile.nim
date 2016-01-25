import
  bb_nake, bb_os, bb_system


proc run_nim() =
  with_dir "nim": direShell nim_exe, "c", "-o:units.exe", "-r", "units"

proc run_all() =
  run_nim()

task "nim", "Compile and run nim version": run_nim()
task defaultTask, "Compile all the thingies": run_all()
