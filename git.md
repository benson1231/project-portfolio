# Git Cheat Sheet

**Reference:** [GeekHour youtube video](https://www.youtube.com/watch?v=PN1k1CLXtlw&t=5s)  


## Table of Contents
1. [Basic Git Settings](#1-basic-git-settings)
2. [Git Areas and File Status](#2-git-areas-and-file-status)
3. [Basic Git Commands](#3-basic-git-commands)
4. [Branch Commands](#4-branch-commands)
5. [Remote Commands](#5-remote-commands)
6. [Advanced Commands](#6-advanced-commands)
7. [Git Workflow and GitFlow](#7-git-workflow-and-gitflow)
8. [Git Rebase and References](#8-git-rebase-and-references)

---

## 1. Basic Git Settings

### Get Git Version
```bash
git --version
```

### Initialize a Git Repository
```bash
git init
```

### Set Author Name and Email
```bash
git config --global user.name "USER_NAME"
git config --global user.email "USER_EMAIL"
```

### List Git Configurations
```bash
git config --list
```

### Add a Git Alias
```bash
git config --global alias.glop "log --pretty=format:'%h %s' --graph"
# Use alias to view commit history:
git glop
```

---

## 2. Git Areas and File Status

### Git Areas
- **Working Directory**: The actual files on your local system that you edit.
- **Staging Area (Index)**: A place where changes are staged before committing.
- **Local Repository**: The committed changes stored on your local machine.
- **Remote Repository**: A repository hosted on a remote server (e.g., GitHub, GitLab).

### File Status
- **Untracked**: New files that are not yet being tracked by Git.
- **Modified**: Files that have been edited but not yet staged.
- **Staged**: Changes that are added to the staging area and ready to commit.
- **Committed**: Changes that have been saved to the local repository.

### Commands to Check Status
```bash
git status              # Check file status
```

## 3. Basic Git Commands

### Stage Files
```bash
git add FILE_NAME        # Add a specific file
git add *.md             # Add all Markdown files
git add .                # Add all files
```

### Commit Changes
```bash
git commit -m "UPDATE_MESSAGE"   # Commit with a message
git commit --amend               # Amend the last commit
```

### View Commit History
```bash
git log                     # Show detailed commit history
git log --oneline           # Show each commit in one line
git log --oneline --graph   # Show commit history as a graph
```

### View Changes
```bash
git diff FILE_NAME                  # View changes in a file
git diff COMMIT_SHA -- FILE_NAME    # Compare a specific commit with a file
```

### Restore File to Last Commit
```bash
git restore FILE_NAME
```

### Reset Changes
```bash
git reset --hard COMMIT_SHA    # Completely undo a commit and delete changes
git reset --soft COMMIT_SHA    # Undo the last commit but keep changes
git reset --mixed COMMIT_SHA   # Undo the commit but retain changes (unstaged)
git reset HEAD FILE_NAME       # Unstage a file
```

### Discard Local Changes
```bash
git checkout COMMIT_SHA -- FILE_NAME
```

### Use `.gitignore` to Ignore Files
```bash
*.png   # Ignore all .png files
```

---

## 4. Branch Commands

### List and Create Branches
```bash
git branch                     # List branches
git branch BRANCH_NAME         # Create a branch
git branch -d BRANCH_NAME      # Delete a branch
git branch -M main             # Rename the branch to 'main'
```

### Switch Branches
```bash
git checkout -b BRANCH_NAME    # Create and switch to a branch
git checkout main              # Switch to 'main' branch
git checkout HEAD FILE_NAME    # Restore a file from the current branch
```

### Merge Branches
```bash
git merge BRANCH_NAME
```

---

## 5. Remote Commands

### Clone a Repository
```bash
git clone https://github.com/benson1231/git_test.git
```

### Remote Repository Management
```bash
git remote -v                       # View remote repositories
git remote add origin REPO_NAME     # Add a remote repository
git remote remove REPO_NAME         # Remove a remote repository
```

### Push Changes
```bash
git push origin BRANCH_NAME         # Push to a remote branch
git push origin --tags              # Push local tags to remote
```

### Pull Changes
```bash
git pull origin BRANCH_NAME         # Pull the latest changes and merge
```

### Fetch Changes
```bash
git fetch                           # Fetch updates without merging
```

---

## 6. Advanced Commands

### Save Changes Temporarily
```bash
git stash save "message"       # Save changes with a description
git stash save -u "message"     # Save tracked and untracked files
git stash save -a "message"     # Save all files, including ignored ones
```

### List Stashed Changes
```bash
git stash list                   # View all stashes
```

### Restore Stashed Changes
```bash
git stash apply                  # Restore the most recent stash without removing it
git stash pop                    # Restore and remove the most recent stash
git stash pop stash@{2}          # Restore and remove a specific stash
```

### Drop Stashed Changes
```bash
git stash drop stash@{2}         # Remove a specific stash
git stash clear                  # Remove all stashes
```

### Garbage Collection
```bash
git gc
```

### Remove Untracked Files
```bash
git clean -f
```

---

## 7. Git Workflow and GitFlow

### GitFlow Overview
- **Main Branch (`main/master`)**: Represents the stable version of the project.
- **Development Branch (`develop`)**: Used for ongoing development.
- **Feature Branches (`feature`)**: For developing individual features.
- **Release Branches (`release`)**: Used for preparing releases.
- **Hotfix Branches (`hotfix`)**: For emergency fixes on the main branch.

---

## 8. Git Rebase and References

### Git Rebase
```bash
git rebase BASE_BRANCH
```
- **Rebase**: Moves or combines commits from one branch to another to maintain a linear history.
- **Interactive Rebase**: Allows editing, squashing, or reordering commits.
  ```bash
  git rebase -i BASE_BRANCH
  ```

### Git References Table
| Reference  | Description                           |
|------------|---------------------------------------|
| `HEAD`     | Points to the current commit          |
| `HEAD~4`   | Refers to the 4th commit before HEAD  |
| `HEAD^`    | Refers to the parent of HEAD          |
| `main`     | The default primary branch            |
| `origin`   | The default name for the remote repo  |

---

### Summary
This cheat sheet provides essential Git commands and concepts to help manage repositories effectively. Use it as a quick reference to streamline your Git workflow.
