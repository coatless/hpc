# Learn about own job progress
alias jobs_info='sacct -u $USER'
alias jobs_user='squeue -u $USER'
alias jobs_active='squeue -u $USER --states=RUNNING'
alias jobs_waiting='squeue -u $USER --states=PENDING'
alias jobs_n='squeue -u $USER --states=RUNNING | wc -l'

# Learn about cluster work
alias jobs_stat='squeue -o "%8i %12j %4t %10u %20q %20a %10g %20P %10Q %5D %11l %11L %R" -p "stat"'
alias node_config='sinfo -o "%20P %5D %14F %8z %10m %10d %11l %16f %N"'

# Quick action job manipulations
alias jobs_hold='scontrol hold'
alias jobs_release='scontrol release'
alias jobs_kill_all='scancel -u $USER'
alias jobs_kill='scancel'

# Run an interactive job
alias si='srun --cpus-per-task=5 --pty bash'
