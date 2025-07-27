Here’s your updated `README.md` content. Replace the existing one with this:

---

````markdown
# PlayBooks — Strategy Library

This repository holds a collection of discretionary trading playbooks, each focused on a specific strategy.

## 📂 Current Playbooks

- [${Name}_Playbook](./TestRun_Playbook/README.md): Playbook for the TestRun strategy.
- [`PMCC_Playbook`](./PMCC_Playbook/PMCC_Playbook.md): Comprehensive guide for the Poor Man’s Covered Call strategy.

## ➕ Adding New Playbooks

To add a new strategy playbook:

1. **Create a new folder** under the root directory with a descriptive name:
   ```powershell
   mkdir NewStrategy_Playbook
````

2. **Inside that folder**, include at minimum:

   * A main markdown file (e.g., `NewStrategy_Playbook.md`)
   * Any supporting files like `.csv`, `.ipynb`, `.png`, etc.

3. **Update this README**:

   * Add a new bullet under `Current Playbooks` linking to the new strategy’s markdown file.

4. **Commit and push your changes**:

   ```bash
   git add .
   git commit -m "Added NewStrategy_Playbook"
   git push
   ```

---

Maintained by JK McCain — *Delta Moves Capital*

````

---

📌 You can save and overwrite your current `README.md` with the content above, then commit:

```bash
git add README.md
git commit -m "Updated README with multi-playbook support instructions"
git push
````
