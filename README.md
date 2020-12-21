# ovirt-tools - a collection of different tools for oVirt

## ansible-playbook-ovirt - a containerbased wrapper for ansible `ovirt.ovirt`-collection 
A tool for running playbooks based on [ovirt.ovirt](https://github.com/oVirt/ovirt-ansible-collection) collection directly from a container image

### prerequisites
* System prepared for running rootless container (e.g. [Rootless containers with Podman: The basics](https://developers.redhat.com/blog/2020/09/25/rootless-containers-with-podman-the-basics/))
* Internet connection (build process will download and install some files)

### build the appropriate container image

```
$ podman build -t sfroemer/ansible-ovirtsdk4-playbook:latest .
```

### Installation and configuration
1. Copy the `ansible-playbook-ovirt` executable to a location which is propagated in `$PATH`
   ```
   $ cp ansible-playbook-ovirt ~/bin
   $ export PATH=~/bin:$PATH
   ```
   
2. Tune variables inside of the script
   ```
   ANSIBLE_SDK_CONTAINER=sfroemer/ansible-ovirtsdk4-playbook
   SSH_PRIVATE_KEY=~/.ssh/id_rsa
   SSH_PUBLIC_KEY=~/.ssh/id_rsa.pub
   ```

### run a playbook
The command `ansible-playbook-ovirt` can be used the same way like `ansible-playbook`

```
$ ansible-playbook-ovirt --version
ansible-playbook 2.9.14
  config file = None
  configured module search path = ['/ansible/library']
  ansible python module location = /usr/local/lib/python3.6/site-packages/ansible
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.6.8 (default, Aug 18 2020, 08:33:21) [GCC 8.3.1 20191121 (Red Hat 8.3.1-5)]
```

