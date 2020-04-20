# ![Icon](./.bluemix/secure-lock-kubernetes.png) Tekton CD Pipeline with Compliance automation for Kubernetes

This is the toolchain template for continuous development with Compliance for Kubernetes. It is preconfigured for continuous delivery with inventory integration, change management with Servicenow, evidence collection and deployment to the IBM Kubernetes Service.

The integrated repositories, target cluster and artifactory integrations are configured during the setup process.

The toolchain includes a Tekton delivery pipeline, which can be manually triggered to initiate a new deployment.

The toolchain can use a Key-Protect vault instance to store the required tokens and API keys.
### To get started, click this button:
[![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south)

**For more information about the setup process, check out this guide**

[Setup Guide](/setup.md)

---
### Learn more
* [Getting Started with Continuous Delivery](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-getting-started&pos=2)
* [Continuous Delivery Practices](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-gm_cd_best&pos=2)
* [Creating Toolchains](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-toolchains_getting_started&pos=2)
* [Working with Tekton Pipelines](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-tekton-pipelines)
* [Private Workers](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-install-private-workers)
* Step by step [tutorial](https://www.ibm.com/devops/method/tutorials/tc_secure_kube) with a demo template
* [Artifactory](https://taas.w3ibm.mybluemix.net/guides#artifactory)
