# mojos-render: RunPod's official Ubuntu image + Blender 5.2.2 (blender.org, checksum pinned) + our render loop.
# Holds no assets of ours: only Blender and the 15-line loop that renders the packed .blend files sent to it.
FROM runpod/base:1.0.2-ubuntu2404
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libxi6 libxxf86vm1 libxfixes3 libxrender1 libgl1 libegl1 libxkbcommon0 libsm6 libice6 xz-utils curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*
RUN cd /opt && curl -fsSL -o b.tar.xz https://download.blender.org/release/Blender5.2/blender-5.2.2-linux-x64.tar.xz \
 && echo "84098912789dc450e95697c4184fb8a90acbe5111c2ba4aede3fecb57806a168  b.tar.xz" | sha256sum -c - \
 && tar xf b.tar.xz && mv blender-5.2.2-linux-x64 blender && rm b.tar.xz && ln -s /opt/blender/blender /usr/local/bin/blender
COPY render_all.py /opt/render_all.py
ENV NVIDIA_DRIVER_CAPABILITIES=all
