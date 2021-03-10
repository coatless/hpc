# Misc Side notes


Finding different Job ID values under a given user is done with: 

```bash
squeue -l -p <partition> | grep PENDING | grep <USER> | awk ' {print $1}' | xargs | sed 's/ /,/g'
```

where `<partition` is the queue and `<user>` is the username of who submitted the job.
