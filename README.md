# TORNADO POC

A proof of concept of the Python framework [Tornado](https://www.tornadoweb.org/en/stable/).

---

## Prerequisite
- Perl _`(Used in the bash at the scripts)`_
- Make _`(Entry point for the scripts calls)`_
- Docker

---

## Usage
<!-- The devops container is guided to the different environments via the following env vars: -->
1. Build the docker image:
```bash
make do_build_devops_docker_image
```
2. Instantiate a container:
```bash
docker run -d -v $(pwd):/opt/tornado-poc \
   -v $HOME/.aws:/home/ubuntu/.aws \
   -v $HOME/.kube:/home/ubuntu/.kube \
   tornado-poc-devops-img
```
3. Run the tornado `hello world`:
```bash
container_id=$(docker container ls | grep tornado-poc-devops-img | awk 'NR==1 {print $1}')
docker exec -it $container_id /opt/tornado-poc/tornado-poc -a run-hello-world
```
