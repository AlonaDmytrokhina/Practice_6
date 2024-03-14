# Project README

**Author:** Dmytrokhina Alona

**Variant:** 1

## Variant Details:

Read N lines from stdin until EOF (max line length 255 characters, max 100 lines), into an array of lines. 
Lines are separated EITHER by a sequence of bytes 0x0D and 0x0A (CR LF), or by a single character - 0x0D or 0x0A.

Find all occurrences of the specified substring (1st argument of the command line) in each of the lines. There can be more than one occurrence per line.
The occurrences must not overlap, for example the number of occurrences of substring "aa" in "aaa" = 1.

Sort the found results by the bubble sort algorithm (if merge sort - there will be an additional point) by the number of occurrences (asc), and output to the console (stdout)
"<number of occurrences> <line index in text file starting at 0>".
