# Data-Science Repository

This repository contains data science projects, including datasets, scripts, and analyses, maintained by Oluwaseun Adeniran.

## Setup Instructions

### GitHub Authentication
GitHub no longer supports password authentication for HTTPS. Use a Personal Access Token (PAT) for authentication.

1. **Generate a PAT:**
   - Go to GitHub > Settings > Developer settings > Personal access tokens > Generate new token.
   - Select scopes: `repo`, `workflow`.
   - Copy the token.

2. **Configure Git:**
   - Update the remote URL:
     ```bash
     git remote set-url origin https://Seunelvis1:<your-pat>@github.com/Seunelvis1/Data-Science.git
     ```
   - Cache credentials:
     ```bash
     git config --global credential.helper cache
     ```

3. **Test Push:**
   ```bash
   git push origin master
