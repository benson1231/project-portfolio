# SED Basics

`sed` (Stream Editor) is a powerful command-line tool used for text manipulation and transformation. It processes text files line by line and applies specified operations, such as searching, replacing, and deleting.

## Basic Syntax
The basic syntax for `sed` is:

```bash
sed [options] 'command' file
```
- **`options`**: Additional flags to modify `sed` behavior.
- **`command`**: The editing operation(s) to perform.
- **`file`**: The input file to process.

If no file is specified, `sed` reads from standard input.

## Common Commands
- `s`: Substitution command (search and replace).
- `d`: Delete lines.
- `p`: Print lines.
- `a`: Append text after a line.
- `i`: Insert text before a line.

## Useful Options
- `-i`: Edit the file in place (without creating a backup).
- `-n`: Suppress automatic printing of lines (useful with `p` command).
- `-e`: Allows multiple commands.
- `-f`: Execute commands from a file.

## Examples

### Substitution (Search and Replace)
Replace the first occurrence of "foo" with "bar" on each line:
```bash
sed 's/foo/bar/' file.txt
```

Replace all occurrences of "foo" with "bar":
```bash
sed 's/foo/bar/g' file.txt
```

Case-insensitive replacement:
```bash
sed 's/foo/bar/gi' file.txt
```

### Delete Lines
Delete lines containing "error":
```bash
sed '/error/d' file.txt
```

Delete the 5th line:
```bash
sed '5d' file.txt
```

Delete lines from 10 to 20:
```bash
sed '10,20d' file.txt
```

### Print Lines
Print only lines containing "error":
```bash
sed -n '/error/p' file.txt
```

Print lines 5 to 10:
```bash
sed -n '5,10p' file.txt
```

### Insert and Append Text
Insert "Header" before the first line:
```bash
sed '1i Header' file.txt
```

Append "Footer" after the last line:
```bash
sed '$a Footer' file.txt
```

### Modify File In-Place
Replace "foo" with "bar" and save changes to the file:
```bash
sed -i 's/foo/bar/g' file.txt
```

Create a backup of the file before editing:
```bash
sed -i.bak 's/foo/bar/g' file.txt
```

### Combine Multiple Commands
Replace "foo" with "bar" and delete lines containing "baz":
```bash
sed -e 's/foo/bar/g' -e '/baz/d' file.txt
```

### Use a File for Commands
Store commands in a file (`commands.sed`):
```bash
s/foo/bar/g
/baz/d
```
Apply the commands:
```bash
sed -f commands.sed file.txt
```

### Advanced Examples

#### Replace Only Specific Lines
Replace "foo" with "bar" on lines 2 to 5:
```bash
sed '2,5s/foo/bar/' file.txt
```

#### Remove Blank Lines
```bash
sed '/^$/d' file.txt
```

#### Add Line Numbers
```bash
sed = file.txt | sed 'N;s/\n/ /'
```

## Summary
`sed` is a versatile tool for stream editing, offering powerful features for text processing. By mastering its commands and options, you can efficiently manipulate text files and automate complex editing tasks.

