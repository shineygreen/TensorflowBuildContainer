# TensorflowBuildContainer
This repository holds the configuration files to build a Docker container and deploy it as a pod in a Kubernetes cluster.
## Details
This repository contains a Dockerfile, a build script and a Kubernetes pod definition. Together they create a container
that can be used to build a Tensorflow 1.4.2 Python wheel. It should be fairly easy to update the dockerfile to build a different release. The dockerfile currently specifies a particular release of Bazel because the 1.4.2 Tensorflow release requires it. I believe later releases can work with the latest version of Bazel, but I have not tested to be sure.


Breifly the instructions are, 

* Build the container.
* Start the pod.
* Connect to the pod with kubectl exec -it tensorbuild -- /bin/bash
* cd tensorflow
* ./configure (answer the questions)
* bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
* bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

The tensorflow 1.4.2 wheel file will be stored in /tmp/tensorflow_pkg when the build is completed.