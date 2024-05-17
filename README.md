# github-migration

See https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository

Check also for large files (from https://stackoverflow.com/questions/10622179/how-to-find-identify-large-commits-in-git-history):
```
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
```

Remove files with 3rd party tool filter-repo (from https://stackoverflow.com/questions/43762338/how-to-remove-file-from-git-history):
```
git filter-repo --invert-paths --path <path to the file or directory>
```