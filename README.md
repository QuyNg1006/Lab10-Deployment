# SE Lab 10 – Software Deployment (ASP.NET Core + Docker)

`MyWebApp` is a minimal ASP.NET Core Razor Pages app (.NET 8) used as the deployment target.
To deploy your own Lab 7/8 project instead, copy it next to `MyWebApp`, and copy `MyWebApp/Dockerfile`
into it (replace `MyWebApp` with your project name inside the Dockerfile and in the commands/workflow).

## Corrections to the handout
- .NET 8+ images listen on **8080** inside the container -> use `-p 8080:8080` (the handout's `8080:80` is for .NET 6/7).
- `docker build` needs the trailing `.` and, with the VS-style Dockerfile, must be run from the solution folder:
  `docker build -f MyWebApp/Dockerfile -t myaspnetcoreapp .`
- Use a Docker Hub **access token** instead of your password (also for the GitHub/GitLab secrets).
- `docker-compose` v1 is retired: use `docker compose`. The `version:` key is obsolete.
- `aws configure` only stores credentials; the registry login is `aws ecr get-login-password ... | docker login`.

## Exercise map
| Exercise | How |
|---|---|
| 1 & 2 Docker local + Docker Hub | `scripts/01-local-docker.sh <dockerhub_user>` (or run the commands one by one for screenshots) |
| 3 Ubuntu server | `scripts/02-ubuntu-server.sh <dockerhub_user>` on the server, or `docker-compose.yml` |
| 4 CI/CD | `.github/workflows/docker-image.yml` (GitHub) / `.gitlab-ci.yml` (GitLab) + secrets |
| 5 Azure | `scripts/03-azure.sh <unique_registry_name>` |
| 6 AWS | `scripts/04-aws.sh <region> <account_id>` + `Dockerrun.aws.json` |
| Special exercise | Deploy the app to Azure App Service / Render / a VPS and submit the live URL |

## Quick start (Windows PowerShell / any shell)
```bash
docker build -f MyWebApp/Dockerfile -t myaspnetcoreapp .
docker run -d -p 8080:8080 --name myaspnetcoreappcontainer myaspnetcoreapp
# http://localhost:8080   and   http://localhost:8080/health
docker ps
docker stop myaspnetcoreappcontainer
docker rm myaspnetcoreappcontainer
```

## GitHub secrets (Settings > Secrets and variables > Actions)
`DOCKER_USERNAME`, `DOCKER_PASSWORD` (access token). Push to `main` to trigger the pipeline.

## Cost warning
Azure App Service (B1) and AWS Elastic Beanstalk are billed. Use Azure for Students credits and delete resources afterwards
(`az group delete -n rg-lab10 --yes`).
