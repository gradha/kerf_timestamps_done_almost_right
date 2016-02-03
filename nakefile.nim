import
  bb_nake, bb_os, bb_system


proc run_cpp() =
  with_dir "cpp":
    dire_shell "g++", "*.cpp", "-std=c++1y", "-o", "units.exe"
    dire_shell "./units.exe"

proc run_nim() =
  with_dir "nim": dire_shell  nim_exe, "c", "-o:units.exe", "-r", "units"

proc run_all() =
  run_nim()
  run_cpp()

task "nim", "Compile and run nim version": run_nim()
task "cpp", "Compile and run cpp version": run_cpp()
task defaultTask, "Compile all the thingies": run_all()
