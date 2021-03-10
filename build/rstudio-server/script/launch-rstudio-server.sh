#!/bin/sh

# Generate a one-time password that lacks special characters
export PASSWORD=$(openssl rand -base64 20 | tr -d "=+/")

# Find an empty socket on the node
# c.f. https://unix.stackexchange.com/a/132524
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

# Display startup instructions
cat 1>&2 <<END
=================================================
RStudio Server instance is now available at:

http://${HOSTNAME}.campuscluster.illinois.edu:${PORT}

>> Warning: Must be on Campus VPN to connect! <<

For SSH access, please type in terminal:

ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@cc-login.campuscluster.illinois.edu

Then, on your local computer open in a web browser: http://localhost:8787

To login use:

Username: ${USER}
Password: ${PASSWORD}
=================================================
END

mkdir -p /scratch/users/$USER/tmp

PASSWORD="${PASSWORD}" RSTUDIO_SESSION_TIMEOUT='0' singularity exec \
--bind /scratch/users/$USER/tmp:/tmp \
${singularity_img_root}/rstudio.simg rserver \
--www-port ${PORT} \
--auth-none 0 \
--auth-pam-helper-path=pam-helper
