# GREP Basics

`grep` is a powerful command-line utility used for searching text patterns in files or standard input. Below, we cover the basics of `grep`, including its syntax, options, and practical examples.

## Basic Syntax
The basic syntax for `grep` is:

```bash
grep [options] pattern [file...]
```
- **`pattern`**: The text or regular expression to search for.
- **`file`**: The file(s) to search.

If no file is specified, `grep` reads from standard input.

## Commonly Used Options
- `-i`: Ignore case distinctions in the pattern.
- `-v`: Invert the match to select non-matching lines.
- `-r` or `-R`: Recursively search files in a directory.
- `-l`: Print only the names of files with matches.
- `-c`: Count the number of matching lines.
- `-n`: Prefix each line of output with its line number.
- `-H`: Print the filename for each match (useful when searching multiple files).
- `-E`: Interpret the pattern as an extended regular expression (ERE).
- `--color`: Highlight matching strings in the output.

## Examples

### Basic Search
Search for lines containing the word "error":
```bash
grep "error" file.txt
```

### Ignore Case
Search for "error" regardless of case:
```bash
grep -i "error" file.txt
```

### Invert Match
Display lines that do not contain "error":
```bash
grep -v "error" file.txt
```

### Recursive Search
Search for "TODO" in all files in the current directory and subdirectories:
```bash
grep -r "TODO" .
```

### Show Line Numbers
Print matching lines with their line numbers:
```bash
grep -n "error" file.txt
```

### Search Multiple Files
Search for "error" in multiple files:
```bash
grep "error" file1.txt file2.txt
```

### Count Matches
Count the number of lines containing "error":
```bash
grep -c "error" file.txt
```

### Show Only Filenames
List filenames containing matches:
```bash
grep -l "error" *.log
```

### Use Regular Expressions
Search for lines that start with "ERROR":
```bash
grep "^ERROR" file.txt
```

Search for lines ending with ".log":
```bash
grep "\.log$" file.txt
```

### Highlight Matches
Highlight the matching text:
```bash
grep --color "error" file.txt
```

### Combine Options
Search recursively, ignore case, and show line numbers:
```bash
grep -rin "error" .
```

## Advanced Examples

### Search for Whole Words
Match the whole word "error" (not substrings like "errors"):
```bash
grep -w "error" file.txt
```

### Search with Extended Regular Expressions
Use extended regex to search for "error" or "warning":
```bash
grep -E "error|warning" file.txt
```

### Search Specific File Types
Search for "TODO" only in `.c` files:
```bash
grep -r --include="*.c" "TODO" .
```

### Exclude Specific Files
Search for "TODO" but exclude `.log` files:
```bash
grep -r --exclude="*.log" "TODO" .
```

## Summary
`grep` is an essential tool for text processing, offering versatile options for searching patterns efficiently. By combining its features with regular expressions and options, you can perform complex searches and analyze data effectively.

