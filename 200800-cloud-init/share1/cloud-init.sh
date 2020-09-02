#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y \
        mosh

sudo tee -a /home/azureuser/.bash_aliases > /dev/null <<'EOT'
function d-run-dev {
        docker run --rm \
                -v ~/.ssh/:/root/.ssh/ \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v ${PWD}:/pwd/ \
                -w /pwd/ \
                --name 'dev' \
                -it aaronmsft/dev
}

function d-exec-dev {
        docker exec -it dev bash
}
EOT

docker pull aaronmsft/dev

[[ -z "${HELLO:-}" ]] && HELLO='...'
echo "HELLO: ${HELLO}" | tee output.txt
