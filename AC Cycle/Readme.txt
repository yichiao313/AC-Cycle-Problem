Reboot/AC/DC Cycle Counter Issue Explanation
This README explains a common issue encountered when using batch scripts to track cycle counts (e.g., AC Cycle, DC Cycle, Reboot Cycle) on Windows servers. Specifically, it discusses why the counter may fail to increment correctly during AC Cycle, while it works fine during DC or Reboot Cycles, and how to resolve it using EnableDelayedExpansion.

Problem Description
DC / Reboot Cycle:
In most cases, your batch script runs continuously without rebooting the entire system. This means:

The script executes in a single CMD session.

Variables such as CYCLE_COUNT remain in memory.

Counter increments (set /a CYCLE_COUNT+=1) work normally.

AC Cycle:
AC Cycle cuts off power completely, causing:

A full system reboot.

All environment variables in memory are lost.

When the script re-launches, it starts from scratch, re-initializing variables like CYCLE_COUNT=0.

To persist the cycle count across AC Cycles, you need to store it in a file (e.g., Counter.txt), and read/write it during every execution.

Hidden Trap: Delayed Variable Expansion
When reading values from Counter.txt using a for /f loop, many users forget that variable expansion in batch scripts is evaluated at parse time, not at run time unless you use delayed expansion.

Incorrect Example:
bat

for /f %%X in (Counter.txt) do (
    set /a CYCLE_COUNT=%%X
)
set /a CYCLE_COUNT+=1
echo %CYCLE_COUNT%
%CYCLE_COUNT% is evaluated before the for loop executes.

Even though set /a CYCLE_COUNT=%%X runs, the echo still prints an outdated value.

Corrected Version Using Delayed Expansion
bat

@echo off
setlocal EnableDelayedExpansion

:: Initialize Counter.txt if not exist
if not exist Counter.txt echo 0 > Counter.txt

:: Read and update counter
for /f %%X in (Counter.txt) do (
    set /a CYCLE_COUNT=%%X
)

set /a CYCLE_COUNT+=1
echo !CYCLE_COUNT! > Counter.txt

:: Optional: Display the updated count
echo Current Cycle: !CYCLE_COUNT!
setlocal EnableDelayedExpansion enables runtime evaluation of variables.

!CYCLE_COUNT! reflects the updated value inside loops or after changes.

Summary
Scenario		Behavior							Fix Needed?
Reboot Cycle	Variables persist, counter updates	No
DC Cycle		Same CMD session, no reset			No
AC Cycle		Power loss resets variables			Yes — use file + EnableDelayedExpansion

Best Practices
Always persist your counter using a file (Counter.txt) if power loss is expected.

Use EnableDelayedExpansion when manipulating or displaying variables updated inside loops.

Use !VAR! instead of %VAR% to avoid referencing stale values.