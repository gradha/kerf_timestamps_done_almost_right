import nake, os, sequtils

template glob*(pattern: string): expr =
  ## Familiar `os.walkFiles() <http://nim-lang.org/os.html#walkFiles>`_ shortcut
  ## to simplify getting lists of files.
  to_seq(walk_files(pattern))


# Unlikely to work on anybody else's setup… hah, as if they use nim/nake.
let javac = get_env("CHECKERFRAMEWORK")/"checker/bin/javac "
let javac_normal = get_env("CHECKERFRAMEWORK")/"checker/bin/javac " &
  "-source 8 -target 8 "

let javac_checker = javac &
  "-source 8 -target 8 " &
  "-processor org.checkerframework.common.subtyping.SubtypingChecker "
  #"-Aquals=myqual.Encrypted,myqual.PossiblyUnencrypted "

proc run_cpp() =
  with_dir "cpp":
    dire_shell "g++", "*.cpp", "-std=c++1y", "-o", "units.exe"
    dire_shell "./units.exe"

proc run_nim() =
  with_dir "nim": dire_shell  nim_exe, "c", "-o:units.exe", "-r", "units"

proc run_swift() =
  with_dir "swift":
    dire_silent_shell "Compiling swift", "swiftc -o units.exe *.swift"
    dire_shell "./units.exe"

proc run_java() =
  with_dir "java":
    let annotations = glob("myqual/*.java")
    for extra_src in annotations:
      let target = extra_src.change_file_ext("class")
      if target.needs_refresh(extra_src):
        dire_silent_shell "Compiling " & extra_src, javac_normal, extra_src

    let modules = annotations.map_it(string,
      it.change_file_ext("").replace('/', '.'))
    let param = "-Aquals=" & modules.join(",") & " "
    dire_silent_shell "Compiling units…", javac_checker, param, "Units.java"
    dire_shell "java Units"

proc run_all() =
  run_nim()
  run_cpp()
  run_swift()
  run_java()

task "nim", "Compile and run nim version": run_nim()
task "cpp", "Compile and run cpp version": run_cpp()
task "swift", "Compile and run swift version": run_swift()
task "java", "Compile and run java version": run_java()
task "all", "Compile all the thingies": run_all()
