FROM registry.redhat.io/ubi8/ubi:latest
LABEL maintainer="Steffen Froemer <sfroemer@redhat.com>"

USER root

ENV ANSIBLE_VERSION=2.9.14

# Silence annoying subscription messages.
RUN echo "enabled=0" >> /etc/yum/pluginconf.d/subscription-manager.conf

# Install requirements.
RUN yum makecache --timer \
 && yum -y install initscripts \
 && yum -y install \
      sudo \
      which \
      hostname \
      python3 \
      python3-devel \
      libcurl-devel \
      openssl-devel \
      libxml2-devel \
      gcc \
 # Install Ansible via Pip.
 &&  pip3 install ansible==${ANSIBLE_VERSION} \
 # Install ovirt-engine-sdk-python using pip.
 && pip3 install ovirt-engine-sdk-python \
 # Remove for runtime not required packages
 && yum -y remove \
      python3-devel \
      libcurl-devel \
      openssl-devel \
      libxml2-devel \
      gcc \
 && yum clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH ~/.ansible/roles:/ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library
 
# Install ansible collection ovirt.ovirt 
RUN ansible-galaxy collection install ovirt.ovirt

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks
 
ENTRYPOINT ["ansible-playbook"]

