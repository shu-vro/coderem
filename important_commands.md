## main -> release (exact)

```sh
# Step 1: Checkout the release branch
git checkout release

# Step 2: Reset release branch to match main branch
git reset --hard main

# Step 3: Push the updated release branch to the remote repository
git push origin release --force
```
