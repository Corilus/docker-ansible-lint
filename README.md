# Corilus Docker Image for [ansible/ansible\-lint](https://github.com/ansible/ansible-lint)

## Supported tags and respective `Dockerfile` links

- [`latest` (python3/Dockerfile)][ansible-lint]

## How to use this image

#### show usage

```console
$ docker run --rm corilus/ansible-lint
```

#### example

with find
```console
$ docker run --rm -v ${PWD}:/work -w /work corilus/ansible-lint sh -c 'find . -name "*.yml" | xargs -r ansible-lint --force-color'
```

with git ls-files
```console
$ docker run --rm -v ${PWD}:/work -w /work corilus/ansible-lint sh -c 'git ls-files -z "*.yml" | xargs -r -0 ansible-lint'
```

[ansible-lint]: https://github.com/corilus/docker-ansible-lint/blob/master/Dockerfile
