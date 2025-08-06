# Bash-Scripting Setting

Bash is a powerful shell language for automating tasks on Unix-like systems. Below, we cover essential topics including permissions, configuration files, variables, conditionals, loops, aliases, and practical examples.

## File Permissions
To execute a script, you need to add executable permissions to it. Use the following command for a file named `script.sh`:

```bash
chmod +x script.sh
```

The script file should start with the shebang line to specify the interpreter:

```bash
#!/bin/bash
```

## PATH Configuration
To ensure that scripts in `~/bin/` are available, add this directory to your `PATH`. On Linux-style shells, modify `~/.bashrc`, and on macOS (Catalina and later, which uses Zsh by default), modify `~/.zshrc`.

```bash
# Edit the configuration file
nano ~/.zshrc

# Add the following line to the end of the file
export PATH=~/bin:$PATH

# Reload the configuration
source ~/.zshrc
```

## Simple Commands
### Output Text
```bash
echo "Hello World!"
```

### Using Variables
Variables are defined without a `$` and accessed with a `$`.

```bash
greeting="Hello"
echo $greeting
```

## Conditionals
Use conditionals to make decisions in scripts.

```bash
if [ $index -lt 5 ]
then
  echo $index
else
  echo 5
fi
```

Comparison operators:
- Equal: `-eq`
- Not equal: `-ne`
- Less than: `-lt`
- Greater than: `-gt`
- Null check: `-z`

String comparison:
- Equal: `==`
- Not equal: `!=`

## Loops
### For Loop
```bash
for word in $paragraph
do
  echo $word
done
```

### While Loop
```bash
while [ $index -lt 5 ]
do
  echo $index
  index=$((index + 1))
done
```

### Until Loop
```bash
until [ $index -eq 5 ]
do
  echo $index
  index=$((index + 1))
done
```

## Inputs
Read input from the user and use it in your script.

```bash
read number
echo "You guessed $number"
```

## Aliases
Aliases are shortcuts for commands. Define them in your configuration file.

```bash
alias saycolors='./saycolors.sh'
alias saycolors='./saycolors.sh "green"'
```