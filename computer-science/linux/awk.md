# AWK Basics

`awk` is a powerful text-processing tool in Unix-like systems. It is used for pattern scanning and processing. Below, we cover the basics of `awk`, including its syntax, common use cases, and practical examples.

## Basic Syntax
The basic syntax for `awk` is as follows:

```bash
awk 'pattern { action }' file
```
- **`pattern`**: Defines the condition to match lines.
- **`action`**: Specifies what to do with the matched lines.
- **`file`**: The input file to process.

If the `pattern` is omitted, `awk` applies the `action` to all lines. If the `action` is omitted, `awk` prints all lines matching the `pattern`.

## Common Patterns and Variables
- **`NR`**: The current line number.
- **`NF`**: The number of fields in the current line.
- **`$n`**: The nth field in the current line (e.g., `$1` for the first field).
- **`FS`**: Field separator (default is whitespace).
- **`OFS`**: Output field separator.

## Examples
### Print All Lines
```bash
awk '{ print }' file.txt
```

### Print Specific Fields
Print the first and second fields of each line:
```bash
awk '{ print $1, $2 }' file.txt
```

### Filter Lines by Pattern
Print lines containing the word "error":
```bash
awk '/error/ { print }' file.txt
```

### Count Lines in a File
```bash
awk 'END { print NR }' file.txt
```

### Sum a Column of Numbers
If the file contains numbers in the first column, sum them:
```bash
awk '{ sum += $1 } END { print sum }' file.txt
```

### Use Custom Field Separators
Process a CSV file (comma-separated):
```bash
awk -F, '{ print $1, $2 }' file.csv
```

### Replace Fields
Modify the second field in a file:
```bash
awk '{$2 = "modified"; print}' file.txt
```

### Conditional Processing
Print lines where the second field is greater than 100:
```bash
awk '$2 > 100 { print }' file.txt
```

### Format Output
Print formatted output:
```bash
awk '{ printf("%-10s %s\n", $1, $2) }' file.txt
```

## Advanced Examples
### Find Unique Values in a Column
```bash
awk '{ seen[$1]++ } END { for (key in seen) print key }' file.txt
```

### Extract Specific Lines
Print lines 5 through 10:
```bash
awk 'NR>=5 && NR<=10 { print }' file.txt
```

### Use External Variables
Pass a shell variable to `awk`:
```bash
value=100
awk -v threshold=$value '$1 > threshold { print }' file.txt
```

## Summary
`awk` is a versatile tool for text processing, offering functionality ranging from simple printing to complex pattern matching and data manipulation. Mastering `awk` can significantly enhance your scripting and automation capabilities.

