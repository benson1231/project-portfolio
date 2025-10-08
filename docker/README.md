docker images
docker ps 
docker ps -a
docker build .
docker build -t <name:tag> .
docker start <>
docker stop <>
docker attach <>
docker logs <>
docker logs -f <>
docker run <>
docker run -it <>
docker run --rm <>
docker rm <>
docker image prune
docker image inspect <>
docker cp <> <img:path>
docker run -name <name> <>
docker tag <repo:tag> <hub-user:hub-repo>
docker login
docker volume ls
docker volume create <>
docker volume rm <>
docker volume prune
docker volume inspect <>
docker run -v <>
docker run -v </app:/app>
docker run -v </app:/app:ro>
docker history <image>
docker network create <>