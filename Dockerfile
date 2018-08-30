#
#   Create an image that can be used to build Tensorflow 1.4.1
#
#   Sid Stuart 8/28/2018
#
#   Nvidia image tags are at https://hub.docker.com/r/nvidia/cuda/tags/
#   Bazel releases are at https://github.com/bazelbuild/bazel/releases?after=0.6.0
#
#   Note that this uses Bazel 0.5.4 because later releases break on Tensorflow 1.4.2
#		(Even though the 1.4.2 change notes say they fixed that.)
#
FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

# The version of Tensorflow being built
ENV tensorflow_release r1.4

# The version of Bazel to use for building
ENV bazel_release 0.5.4

# Pick up the (old) bazel install script.
ADD https://github.com/bazelbuild/bazel/releases/download/${bazel_release}/bazel-${bazel_release}-installer-linux-x86_64.sh \
    /tmp

WORKDIR /root

# The first apt-get install line is for the Bazel requirements.
# The second apt-get install line is for the Tensorflow requirements.
# Separate installs for maintainability.
# Then we run the Bazel script we downloaded.
RUN env DEBIAN_FRONTEND=noninteractive && apt-get update  &&\
    apt-get -y install pkg-config zip g++ zlib1g-dev unzip python openjdk-8-jdk &&\
    apt-get -y install git python-numpy python-dev python-pip python-wheel  &&\
    chmod +x /tmp/bazel-${bazel_release}-installer-linux-x86_64.sh &&\
    mkdir -p /root/bin
# Split the run to get around a chmod race condition.
# Run bazel install script and then download Tensorflow and select branch of Tensorflow.
RUN /tmp/bazel-${bazel_release}-installer-linux-x86_64.sh --user    &&\
    echo export PATH="$PATH:$HOME/bin" >>/root/.bashrc  &&\
    git clone https://github.com/tensorflow/tensorflow  &&\
    cd tensorflow && git checkout ${tensorflow_release}

