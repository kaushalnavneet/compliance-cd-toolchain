# ![Icon](./.bluemix/secure-lock-kubernetes.png) Tekton CD Pipeline with Compliance automation for Kubernetes

TODO: documentation

### To get started, click this button:
[![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south)


## Inputs

The following `Secret` and `ConfigMap` resources are created for the tasks in the pipeline.
Each name for these resources will be passed on for the tasks in the following parameters

- `configurationContext`
- `configurationSecrets`

### Context

 - Type: `ConfigMap`
 - Default name: `cd-context`

Content: 

 - **CR_NAMESPACE**: Container Registry namespace
 - **CR_REGION**: Container Registry region
 - **CLUSTER_NAME**: Cluster Name
 - **CLUSTER_REGION**: Cluster region
 - **CLUSTER_NAMESPACE**: Cluster namespace
 - **EMERGENCY_LABEL**: Label used for your Emergency releases, issues and PRs on GitHub
 - **APPLICATION**: the application/service name for images and ServiceNow
 - **INCIDENT_ISSUE_REPO**: Repo URL to manage Compliance Incident issues
 - **EVIDENCE_LOCKER_REPO**: Repo URL as an Evidence Locker

### Secrets

 - Type: `Secret`
 - Default name: `cd-secrets`

Content: 

 - **API_KEY**: IBM Cloud API key
 - **GHE_USER**: GitHub Enterprise user
 - **GHE_TOKEN**: GitHub Enterprise API token
 - **SERVICENOW_TOKEN**: ServiceNow Change Management console API token

---
### Learn more 

* Blog [Continuously deliver your app to Kubernetes with Bluemix](https://www.ibm.com/blogs/bluemix/2017/07/continuously-deliver-your-app-to-kubernetes-with-bluemix/)
* Step by step [tutorial](https://www.ibm.com/devops/method/tutorials/tc_secure_kube)
* [Getting started with Bluemix clusters](https://console.bluemix.net/docs/containers/container_index.html?pos=2)
* [Getting started with toolchains](https://bluemix.net/devops/getting-started)
* [Documentation](https://console.bluemix.net/docs/services/ContinuousDelivery/index.html?pos=2)
