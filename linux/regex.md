# Regular Expressions (Regex) Cheat Sheet

Regular expressions (regex) are sequences of characters that define search patterns. They are widely used in text processing, searching, and validation.

**Reference:** [GeekHour youtube video](https://www.youtube.com/watch?v=uPBtum7QRvw)  
**Practice:** [Regexr](https://regexr.com/)

---

## Table of Contents
1. [Basic and Quantifier Syntax](#1-basic-and-quantifier-syntax)
2. [Greedy vs. Non-Greedy Matching](#2-greedy-vs-non-greedy-matching)
3. [Character Classes](#3-character-classes)
4. [Grouping and Backreferences](#4-grouping-and-backreferences)
5. [Flags](#5-flags)
6. [Common Use Cases](#6-common-use-cases)

---

## 1. Basic and Quantifier Syntax

| Symbol | Description | Example | Matches |
|--------|------------|---------|---------|
| `.` | Matches any single character (except newline) | `c.t` | `cat`, `cut`, `cot` |
| `^` | Matches the start of a line | `^Hello` | Matches "Hello" only at the beginning of a line |
| `$` | Matches the end of a line | `world$` | Matches "world" only at the end of a line |
| `*` | Matches 0 or more occurrences of the previous character | `ba*` | `b`, `ba`, `baa`, `baaa` |
| `+` | Matches 1 or more occurrences of the previous character | `ba+` | `ba`, `baa`, `baaa` |
| `?` | Matches 0 or 1 occurrence of the previous character | `ba?` | `b`, `ba` |
| `{n}` | Matches exactly `n` occurrences | `a{3}` | `aaa` |
| `{n,}` | Matches `n` or more occurrences | `a{2,}` | `aa`, `aaa`, `aaaa` |
| `{n,m}` | Matches between `n` and `m` occurrences | `a{2,4}` | `aa`, `aaa`, `aaaa` |
| `\|` | OR operator (matches either pattern) | `cat\|dog` | `cat`, `dog` |
| `()` | Groups expressions | `(ab)+` | `ab`, `abab`, `ababab` |

## 2. Greedy vs. Non-Greedy Matching

| Type | Symbol | Description | Example | Matches |
|------|--------|------------|---------|---------|
| Greedy | `.*` | Matches as much text as possible | `a.*b` on `axxxxb` | `axxxxb` |
| Non-Greedy | `.*?` | Matches the shortest possible text | `a.*?b` on `axxxxb` | `axb` |

## 3. Character Classes

| Character Class | Description | Example | Matches |
|----------------|------------|---------|---------|
| `[abc]` | Matches any one of the specified characters | `[abc]` | `a`, `b`, `c` |
| `[^abc]` | Matches any character except those specified | `[^abc]` | Any character except `a`, `b`, `c` |
| `[a-z]` | Matches any lowercase letter | `[a-z]` | `a`, `b`, ..., `z` |
| `[A-Z]` | Matches any uppercase letter | `[A-Z]` | `A`, `B`, ..., `Z` |
| `[0-9]` | Matches any digit | `[0-9]` | `0`, `1`, ..., `9` |
| `[a-zA-Z0-9]` | Matches any alphanumeric character | `[a-zA-Z0-9]` | `a`, `B`, `3` |
| `.` | Matches any character except newline | `.` | `a`, `1`, `@` |

## 4. Grouping and Backreferences

| Symbol | Description | Example | Matches |
|--------|------------|---------|---------|
| `(...)` | Capturing group | `(abc)` | Matches `abc` and stores it in memory |
| `(?:...)` | Non-capturing group | `(?:abc)` | Matches `abc` but does not store it |
| `\1, \2, ... ($1, $2, ...)` | Backreference to captured group | `(\w+) \1` | Matches `hello hello`, `abc abc` |

### Example Usage of Backreferences

```regex
(\d{3})-(\d{3})-(\d{4})
```
- Matches phone numbers formatted as `123-456-7890`
- `\1`, `\2`, and `\3` refer to the first, second, and third captured groups respectively.

## 5. Flags

| Flag | Description |
|------|------------|
| `i` | Case-insensitive match |
| `g` | Global match (find all matches) |
| `m` | Multi-line mode (`^` and `$` match start and end of lines) |
| `s` | Dotall mode (`.` matches newline) |
| `x` | Ignore whitespace for readability |

## 6. Common Use Cases

### Matching Email Addresses
```regex
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
```

### Matching Phone Numbers (US Format)
```regex
\(\d{3}\) \d{3}-\d{4}
```

### Extracting URLs
```regex
https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/[a-zA-Z0-9._%+-]*)*
```

### Matching Hex Colors
```regex
#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})
```

### Matching Dates (YYYY-MM-DD)
```regex
\d{4}-\d{2}-\d{2}
```

## Summary
Regular expressions are a powerful tool for searching, matching, and manipulating text. By mastering regex patterns, you can efficiently handle complex text-processing tasks in various programming languages and command-line tools.

