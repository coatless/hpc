# Storage

## Storing Data & Code

- Home Directory `~/`
    - Up to **~2GB** (Soft cap^[Soft caps gently warn the user to lower their storage size.])
      / **~4GB** (Hard cap^[Hard caps prevent the user from adding new files.]) with **nightly backups**.
    - Storage is **private**.
- Project Spaces `/projects/stat/shared/$USER`
    - **~21TB** of shared space with **nightly backups**.
    - Storage is **shared** among `stat` members.
- Temporary Networked Storage `/scratch`
    - **~10TB** of space purged after **30 days** with **no backup**.
    - Storage is **private**.

## Backups

### Backup Info

- **Daily** night time backups.
- **30 days** of backups exist.
- **No off-site backups for disaster recovery.**

### Location of Backups

- Home Directory `~/`

```bash
/gpfs/iccp/home/.snapshots/home_YYYYMMDD*/$USER
```

- Project Directory `/projects/stat/shared/$USER`

```bash
/gpfs/iccp/projects/stat/.snapshots/statistics_YYYYMMDD*
```
