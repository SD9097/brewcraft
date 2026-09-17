# Git Workflow — BrewCraft

**Project path:** `E:\brewcraft`

## Branch strategy

| Branch | Purpose |
|---|---|
| `main` | Production only — **you approve merges** |
| `feature/<name>` | One feature per branch |

## First-time GitHub setup

```powershell
cd E:\brewcraft
git init -b main
git add .
git commit -m "Initial commit: BrewCraft scaffold and docs"
gh auth login
gh repo create brewcraft --public --source=. --remote=origin --push
```

## Typical flow

```powershell
git checkout main
git pull origin main
git checkout -b feature/my-feature
# ... work ...
git add .
git commit -m "Describe change"
git push -u origin feature/my-feature
# Open PR → you review → merge to main
```
