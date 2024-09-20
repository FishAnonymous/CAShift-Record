# Cloud Attack Record Framework

Recording Framework for CAShift Dataset

## Normal Log Collection

* Random Walk
- Admin Page Walk
- Random Form Submission (Comment, User Login, Update)

## Cloud Arch

### cri-o 
+ minikube start --Kubernetes-version=v1.18.12 --driver=docker --container-runtime=crio

### containerd
+ minikube start --Kubernetes-version=v1.18.12 --driver=docker --container-runtime=containerd

### gvisor
+ minikube start --Kubernetes-version=v1.18.12 --driver=docker --container-runtime=containerd --docker-opt containerd=/var/run/containerd/containerd.sock

+ **minikube addons enable gvisor**

## Attack Collection

**Application**
|Index|CVE ID|Applization|Version|Type|POC|Collection|
|:----:|------|---------|------|------|---|---|
| 1 | CVE-2016-10033 | WordPress | < 5.2.18 | RCE | √ | √ |
| 2 | CVE-2016-4029 | WordPress | < 4.5 | SSRF | √ | √ |
| 3 | CVE-2017-5487 | WordPress | 4.7.1 | CWE-200 | √ | √ |
| 4 | CVE-2019-17671 | WordPress | < 5.2.3 | CWE-200 | √ | √ |
| 5 | CWE-400 | WordPress | < 5.3 | DoS | √ | √ |
| 6 | CVE-2015-8562 | Joomla | < 3.4.6 | CWE-20 | √ | √ |
| 7 | CVE-2017-8917 | Joomla | < 3.7.1 | SQL Injection | √ | √ |
| 8 | CVE-2021-23132 | Joomla | 3.0.0 - 3.9.24 | Directory Traversal RCE | √ | √ |
| 9 | CVE-2023-23752 | Joomla | 4.0.0 - 4.2.7 | Information Leak | √ | √ |
| 10 | CVE-2019-8341 | Jinja2 | 2.10 | CWE-94 | √ | √ |


**Cloud**
|Index|CVE ID|Cloud Arch|Version|Type|POC|Collection|
|----|------|---------|------|------|---|---|
| 1 | CVE-2019-5736 | runc | 1.0-rc6 | Container Breakout | √ | √ |
| 2 | CVE-2021-30465 | runc | < 1.0.0-rc95 | Race Container Breakout | √ | √ |
| 3 | CVE-2024-21626 | runc | < 1.1.11 | CWE-403 | √ | √ |
| 4 | CVE-2020-15257 | containerd | < 1.3.9 | Privilege Escalation | √ | √ |
| 5 | CVE-2022-1708 | cri-o | < 1.19.7 | Resource Exhaustion | √ | √ |
| 6 | CVE-2020-14386 | gVisor | < 5.9-rc4 | Memory Corruption | √ | √ |
| 7 | CVE-2024-1086 | kernel | 5.14 - 6.6 | UAF | √ | √ |
| 8 | CVE-2021-25743 | Kubernetes | Secret Stealth | v1.0.0 | √ | √ |
| 9 | CVE-2021-25742 | Kubernetes ingress | ANSI Escape | < 1.26.0-alpha.3 | √ | √ |
| 10 | CWE-200 | Kubernetes | Service Spoofing | 1.25 | √ | √ |

## Quick Replay and Collection

1. source activate python3.9
2. minikube start from init
3. get docker id and refine record.sh
4. bash record.sh & kubectl create service
5. get service ip & refine normal-performance.py & open serivce ip for completing installation
6. run normal-performance.py

## Data Process

`log_path`: contain three directory `normal`, `attack`, `test`

assemble .scap files into all.scap, then run `parse_dataset.py`

## Collect Normal Logs

1. Start services
2. Start Normal Behavior Operator
python daemon.py {SERVICE_IP}
3. Start Record
bash record/record.sh {CONTAINER_ID} {OUTPUT_DIR} {Collect Number}

**Shift Log Collection**
|Index| Application | Cloud Arch | Application Version | Shift Type | Collection |
|----|------|---------|------|------|---|
| 1 | WordPress | containerd-runc | 6.2 | Base | √ |
| 2 | WordPress | containerd-runc | 5.6 | Version-2 | √ |
| 3 | WordPress | containerd-runc | 4.8 | Version-1 | √ |
| 4 | WordPress | containerd-gvisor | 6.2 | Arch-1 | √ |
| 5 | WordPress | cri-o-runc | 6.2 | Arch-2 | √ |
| 6 | Joomla | containerd-runc | 3 | App-2 | √ |
| 9 | Jinja | containerd-runc | 2 | App-1 | √ |