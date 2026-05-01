# 📝 Restic Mastery Cheatsheet

> Use this guide while running the interactive scenarios. All commands can be run via the local wrapper: `restic <command>`

---

## 🚀 Core Commands

| Command | Usage | Quick Tutorial |
| :--- | :--- | :--- |
| **init** | `restic init` | **Initialize** a new repository. Only run once per project. |
| **backup** | `restic backup /data` | **Snapshot** a directory. Restic only sends new/changed data. |
| **snapshots** | `restic snapshots` | **List** all points in time available for restoration. |
| **ls** | `restic ls <id>` | **Peek** inside a snapshot to see the file structure at that time. |
| **dump** | `restic dump latest /path/to/file` | **Read** a single file's content directly to stdout without restoring. |
| **restore** | `restic restore latest --target /` | **Recover** everything from the latest snapshot back to the root. |
| **diff** | `restic diff <id1> <id2>` | **Compare** two snapshots to see exactly what changed between them. |

---

## 🛠️ Maintenance & Optimization

| Command | Usage | Quick Tutorial |
| :--- | :--- | :--- |
| **stats** | `restic stats` | **Audit** the repository size and number of unique blobs. |
| **check** | `restic check` | **Verify** the integrity of your backup data and index. |
| **forget** | `restic forget --keep-last 7` | **Policy**: Mark old snapshots for deletion based on retention rules. |
| **prune** | `restic prune` | **Cleanup**: Physically delete the data blobs unreferenced by 'forget'. |
| **unlock** | `restic unlock` | **Repair**: Remove stale locks if a backup process was killed mid-run. |

---

## 💡 Advanced Tips

### Selective Restore
Don't wait for a full restore if you only need one folder:
```bash
restic restore latest --target / --include /data/database
```

### Dry Run
See what `forget` would do without actually deleting anything:
```bash
restic forget --keep-daily 7 --dry-run
```

### Snapshots Filters
Filter snapshots by path or hostname:
```bash
restic snapshots --path /data/app_data
```
