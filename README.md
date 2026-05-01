# 🛡️ Restic Playground

A training simulator for mastering **Restic** through hands-on practice.

This is **not** a backup tool. It is a sandbox designed to help you master Restic commands, retention policies, and disaster recovery scenarios in a safe, controlled environment.

---

## 🏗️ Architecture

- **Restic Service**: Official Restic image running as a sidecar.
- **Data Generator**: Simulates a real workload (application assets, database backups, logs) with continuous churn.
- **Repository**: A local directory (`./repo`) acting as your backup destination.
- **Scenarios**: A series of guided lessons to take you from zero to recovery expert.

---

## 🚀 Getting Started

### 1. Start the Playground
```bash
task up
```
This starts the Restic container and the data generator.

### 2. Enter the Learning Menu
```bash
task menu
```
Follow the interactive menu to progress through the scenarios.

---

## 📚 Learning Path

| Scenario | Goal | Command to Master |
| :--- | :--- | :--- |
| **01** | Initialize Repo | `restic init` |
| **02** | First Backup | `restic backup` |
| **03** | Exploration | `restic snapshots`, `ls`, `diff` |
| **04** | Single File Restore | `restic restore --include` |
| **05** | Full Restore | `restic restore` |
| **06** | Retention | `restic forget --keep-*`, `prune` |
| **07** | Disaster Recovery | Cold restore simulation |

---

## 🛠️ Maintenance & Safety

- **`task status`**: Show current snapshots, repo size, and last logs.
- **`task reset`**: Wipes the `./data` directory (simulates data loss).
- **`task wipe`**: Wipes the `./repo` directory (DANGER: deletes all backups).
- **`task logs`**: Follow logs from the data generator and restic.

---

## 📝 Observability
All restic commands executed by the scenarios are logged to `logs/restic.log` for you to inspect.

---

## 💡 Tips for Learning
- Run `make status` between scenarios to see how the repo changes.
- Inspect the `./repo` directory to see how Restic stores data (it's encrypted and deduplicated!).
- Try to run the commands manually inside the container:
  `docker exec -it restic-playground restic snapshots`