# Rails App Kubernetes Example

This is an example of Kubernetes deployable empty Rails project, containerizing the app using Docker. Using Helm charts to deploy the app and dependencies (postgres, redis).

## Building rails image

This image will be used by `unicorn` and `sidekiq`.

```shell
# Build the image
docker build -t <some-public-repo>/<some-tag> .

# and push it
docker push <some-public-repo>/<some-tag>
```

## Building nginx image (planned, but not implemented yet)

Use nginx to serve the assets as the following:
- Build 2 step dockerfile, first step is rails image to collect assets, the second is nginx to copy assets to it
- On helm chart add new deployment for nginx with service and ingress rule to the direct requests to assets path to nginx

## Install to Kubernetes

- Make sure helm client and tiller are installed on the local machine and the cluster
- Update the [values file](./chart/drkiq/values.yaml) for the following changes and any others needed (instead you can pass values adding `--set k=v` to helm install command)
  - Change rails.image.repository and rails.image.tag to the image/tag you pushed earlier (default values should work since set them to image i already pushed)
  - Change rails.ingress.hosts to a list of your hosts ex: ["insta-app.com"] since I'm using nginx-ingress

Now we're ready to install the chart

```shell
# supposing the CD is project root
helm install --namespace <kube-namespace> --name <release-name: ex. staging-drkiq> ./chart/drkiq
```
