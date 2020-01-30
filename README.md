# Docker Lab
### this is a small project to present how to run a sample application with Docker

### Some background:
- running on a **virtualbox**, with **two** vms
- **Swarm** used for clustering
- **HAProxy** for load balancing, running from the **manager**
- webstatic and webui are **replicated**
- **local registry** to store images
- **visualizer** for better user experience
- **not using alpine images [don't ask me why...]**

### Prerequisites:
- local registry and visualizer both are running as docker services
- images built locally [with docker compose], and pushed to local registry
- swarm is up and running [with two nodes]

## Deploy
use below command to deploy your stack:
```sh
docker stack deploy --compose-file docker-compose.yml dockermrx
```
