# Setup Guide for Tekton CD Pipeline with Compliance

## Prerequisites:
* **K8S Cluster**
* **Artifactory access**
* **IBM Cloud CLI**
* **IBM Cloud Api Key**
* (optional) [COS Bucket configured as a Compliance Evidence Locker](https://github.ibm.com/one-pipeline/docs/cos-evidence-locker-buckets.md#bucket-configuration)



## Table of Contents

1. [Create toolchain](#1-create-toolchain)
2. [Set toolchain name and toolchain region](#2-set-toolchain-name-and-toolchain-region)
3. [Set up tool integrations](#3-set-up-tool-integrations)
    - [HashiCorp Vault](#hashicorp-vault)
    - [Key Protect](#key-protect)
    - [Repositories](#repositories)
      - [Tekton definitions](#tekton-definitions)
      - [Application related repositories](#application-related-repositories)
    - [Delivery Pipeline](#delivery-pipeline)
      - [IBM Cloud API Key](#ibm-cloud-api-key)
      - [Inventory target and source branches](#inventory-target-and-source-branches)
    - [Delivery Pipeline Private Worker](#delivery-pipeline-private-worker)
    - [Artifactory](#artifactory)
    - [ServiceNow](#servicenow)
    - [Security and Compliance](#security-and-compliance)
    - [DOI toolchain](#link-doi-toolchain)
    - [Cloud Object Storage](#cloud-object-storage-not-required)
    - [Slack Integration](#slack-integration-not-required)
4. [Create toolchain](#4-create-toolchain)
5. [Run the CD Pipeline](#5-run-the-cd-pipeline)



## 1. Create toolchain:

A toolchain can be created by
* **Create button** in the README

   [![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south)

* **Using the URL**
<https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south&branch=master>

Using the url, modifications can be tried out before merging into master by changing the branch to a feature branch.



## 2. Set toolchain name and toolchain region

| ![Toolchain Name](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/name.png) |
| :--: |

Note: toolchain region can differ from the cluster region



## 3. Set up tool integrations



### HashiCorp Vault

Use HashiCorp Vault to securely store secrets that are needed by your toolchain. Examples of secrets are API keys, user passwords or any other tokens that enable access to sensitive information. Your toolchain stores references to the HashiCorp secrets, not the literal secret values, which enables advanced capabilities like secret rotation.

If your team does not have a HashiCorp Vault set up, you can follow [this documentation](https://pages.github.ibm.com/vault-as-a-service/vault/onboarding/project.html) to request a `Role ID`.

| ![HashiCorp Vault](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/hc-vault.png) |
| :--: |

 - **Name**: A name for this tool integration. This name will be displayed in the toolchain.
 - **Server URL**: The server URL for your HashiCorp Vault Instance. (`https://vserv-us.sos.ibm.com:8200`, `https://vserv-eu.sos.ibm.com:8200`, `https://vserv-test.sos.ibm.com:8200`)
 - **Integration URL**: The URL that you want to navigate to when you click the HashiCorp Vault Integration tile.
 - **Secrets Path**: The mount path where your secrets are stored in your HashiCorp Vault Instance.
 - **Authentication Method**: The Authentication method for your HashiCorp Vault Instance.
 - **Role ID:** Your team's [AppRole Role ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/approle-role-ids.html).
 - **Secret ID:** Your team's [Secret ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/manage-secret-ids.html).

Note: _We advise you to use AppRole authentication method as this method can be used to read secret values._



### Key Protect

Use [Key Protect](https://cloud.ibm.com/catalog/services/key-protect) to securely store and apply secrets like API keys that are part of your toolchain. Literal secret values will be stored, rotation is not yet enabled.

| ![Key Protect](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/key-protect.png) |
| :--: |

A Key Protect tool integration is included in this template to securely manage the HashiCorp `Role ID` and `Secret ID` in accordance with the [best practices for vault](https://pages.github.ibm.com/vault-as-a-service/vault/usage/best-practices.html) recommended  by SOS. Ideally these two HashiCorp secrets should be stored in Key Protect as a prerequisite for users creating toolchains. Doing so will protect access to HashiCorp Vault, which is the default secrets repository for most consumers.



### Repositories

| ![Repositories](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/repositories.png) |
| :--: |

#### Tekton definitions

Tekton definitions can be changed also after the toolchain is created. These repositories can be contributed to or can be forked.
All fields are required.

- **Tekton Catalog repo URL:**
    The common tekton tasks are contained in this repo.
    Default: <https://github.ibm.com/one-pipeline/common-tekton-tasks>

- **Tekton Definition repo URL:**
    The tekton pipeline defintions (pipeline(s), triggers, listeners, etc.) are kept in this repo.
    Default: <https://github.ibm.com/one-pipeline/compliance-cd-toolchain>

#### Application related repositories

If you used the <https://github.ibm.com/one-pipeline/compliance-ci-toolchain> template to set up your CI process, check out your CI toolchain and copy the names of the repositories used there.
If you set up your CI toolchain from scratch, you will still need to add these repositories there, and use the same ones here.

- **Incident issues repo URL:** Issues about incidents that happen during the build and deployment process are stored here.
    Default: `""`
    E.g.: <https://github.ibm.com/myorg/my-compliance-ci-issues>

- **Evidence locker repo URL:** All raw compliance evidence that belongs to the application is collected here.
    Default: `""`
    E.g.: <https://github.ibm.com/myorg/my-compliance-ci-evidence>

- **Inventory repo URL:** Change management is tracked in this repository. CD pipeline creates a new branch named as the created CR number, and merges it to master after deplyment is concluded.
    Default: `""`
    E.g.: <https://github.ibm.com/myorg/my-compliance-ci-inventory>

- **One-Pipeline Configuration repo URL:** The custom scripts used in the CD Pipeline (`.one-pipeline.yaml`) should come from this repository. As a default, we provide a sample repo with some basic configuration and scripts (https://github.ibm.com/one-pipeline/hello-compliance-deployment)



### Delivery Pipeline

The Tekton CD Toolchain with Compliance comes with an integrated Tekton pipeline to manage change requests and deployments.

| ![Delivery Pipeline](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/pipeline.png) |
| :--: |

#### IBM Cloud API Key

The API key is used to interact with the ibmcloud CLI tool in several tasks.

  - An existing key can be copy&pasted
  - An existing key can be imported from an existing Key Protect Instance by clicking the key icon

| ![Import secret](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/import-key.png) |
| :--: |


  - A new key can be created from here by clicking the `New +` button


| ![Create API Key](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/create-api-key.png) |
| :--: |

   Note: The newly generated API key can be immediately saved to an existing Key Protect instance.

| ![Save secret to vault](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/save-to-vault.png) |
| :--: |

   Note: A new Key Protect Instance can be created here: <https://cloud.ibm.com/catalog/services/key-protect>
   Note: An IBM Cloud API key can also be created here: <https://cloud.ibm.com/iam/apikeys>

   Once the API Key field is filled out and cluster related fields will be filled out automatically.

| ![Cluster](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/cluster.png) |
| :--: |

#### Inventory target and source branches

  - **Inventory Source Environment:** The environment from where you want to promote the application
      Default: `master`

  - **Inventory Target Environment:** The environment to where you want to deploy the application
    Default: `prod`



### Delivery Pipeline Private Worker

| ![Private Worker](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/private-worker-tool.png) |
| :--: |

The Delivery Pipeline Private Worker tool integration connects with one or more private workers that are capable of running Delivery Pipeline workloads in isolation. For more information, see [Working with Private Workers](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-private-workers).



### Artifactory

The template comes with an artifactory integration to enable using cocoa compliance custom base image in the tekton tasks.
Note: You can access the Artifactory [here](https://eu.artifactory.swg-devops.com/artifactory/webapp/#/home)
      Further material and guides about the artifactory are available [here](https://taas.w3ibm.mybluemix.net/guides#artifactory)

| ![Artifactory](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/artifactory.png) |
| :--: |

- **Integration name:**  Tool integration name in the toolchain
    Default: `artifactory-{timestamp}`
- **Integration URL:**  The url of the artifactory repository
    Default: `https://wcp-compliance-automation-team-docker-local.artifactory.swg-devops.com`
    This is where the cocoa base image is stored.
- **Repository type:**  The artifactory repository type
    Default: `Docker registry`
    Note: This should not be changed, otherwise the pipeline will break.
- **User ID:** The artifactory user
    Required field.
- **Authentication token:** The artifactory API key
    An artifactory token can be created [here](https://eu.artifactory.swg-devops.com/artifactory/webapp/#/profile) and stored in Key Protect
    When an artifactory API key already exists in Key Protect, it can be imported here.
    Required field.
- **Release URL:**  The url of the artifactory repository
    Default: `wcp-compliance-automation-team-docker-local.artifactory.swg-devops.com`



### ServiceNow

Service Now is used to keep tack of change requests.

| ![ServiceNow](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/servicenow.png) |
| :--: |

- **ServiceNow API token:** To acquire a ServiceNow API token, submit a request on the Service Portal. Make sure the environment you request for matches the ServiceNow instance in the API URL field below.
    - [PROD](https://watson.service-now.com/ess_portal?id=sc_cat_item&sys_id=02594e86db2c83408799327e9d961999)
    - [TEST](https://watsontest.service-now.com/ess_portal?id=sc_cat_item&sys_id=02594e86db2c83408799327e9d961999)
- **ServiceNow Configuration Item:** The name of the service/app to be associated with Change Requests
    A ServiceNow Configuration item can be requested for [production](https://watson.service-now.com/nav_to.do?uri=%2Fx_ibmwc_ssef_app.do%23!%2Fhome) or [test](https://watsontest.service-now.com/nav_to.do?uri=%2Fx_ibmwc_ssef_app.do%23!%2Fhome) environments.
- **ServiceNow API Base URL:** The Base URL of the ServiceNow API, can be changed to target the production environment, default is test environment.
    Default: `https://watsontest.service-now.com`



### Security and Compliance

To integrate the toolchain with the Security and Compliance Service (Project Fortress), you need to provide a project name and the evidence locker repository name for the Fortress data collector.

| ![Security and Compliance](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/fortress.png) |
| :--: |



### Link DOI toolchain

CD toolchain needs a toolchain ID with an existing DevOps Insights instance, so that it is able to publish the deployment records to insights. You can use your CI toolchain since that has DOI integrated.

| ![DOI Toolchain ID](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/doi-toolchain.png) |
| :--: |

You can copy the Toolchain ID from the URL of your toolchain.
A toolchain's URL follows this pattern: `https://cloud.ibm.com/devops/toolchains/<toolchain-ID-comes-here>?env_id=ibm:yp:us-south`

For example, if the URL is: `https://cloud.ibm.com/devops/toolchains/aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee?env_id=ibm:yp:us-south` then the toolchain's ID is: `aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee`.

Note: Make sure to only include the ID here, not the full URL.


You can also set a target environment for the DOI interactions, this parameter is optional. If you provide this parameter, it will be used instead of the target environment from the inventory.



### Cloud Object Storage (Not Required)

Cloud Object Storage is used to store the evidences and artifacts generated by the Compliance Pipelines.
If you wish to use this feature, you must have a Cloud Object Storage instance and a Bucket. [Read the recommendation for configuring a Bucket that can act as a Compliance Evidence Locker](https://github.ibm.com/one-pipeline/docs/cos-evidence-locker-buckets.md#bucket-configuration). 

_**NOTE:** this is currently optional, you can set any kind of COS bucket as a locker, event without a retention policy. The pipeline won't check or enforce settings at the moment._

For help, please visit the [Cloud Object Storage documentation](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage).

You need to provide the following information for the Pipelines to reach the aforementioned bucket:
- Cloud Object Storage Endpoint
- Bucket Name

You can set up the COS locker later, by providing the necessari `cos-bucket-name` and `cos-endpoint`

To get the **Cloud Object Storage Endpoint**, please visit your COS Instance's page and select the _'Endpoints'_ section in the menu. You will need to copy the Public Endpoint matching the Bucket's _region_ and _resiliency_.

| ![COS Endpoint](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/cos-endpoint-menu.png) |
| :--: |

If You decide not to use Cloud Object Storage as an evidence locker, You can also set the required values after the creation of the toolchain by setting the `cos-bucket-name`, `cos-endpoint` environment variables in the CD Pipeline. 



### Slack Integration (Not Required)

If you want to receive notifications about your CD Pipeline events, you can configure the Slack Tool during the setup from the toolchain template, or you can add the Slack Tool later.

In order for a Slack channel to receive notifications from your tools, you need a Slack webhook URL. To get a webhook URL, see the Incoming Webhooks section of the [Slack API website](https://api.slack.com/messaging/webhooks).

| ![Slack Tool](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/slack.png) |
| :--: |

After creating your toolchain, you can toggle sending notifications with the `slack-notifications` Environment Property in your CD Pipeline (0 = off, 1 = on):

| ![Slack Tool Toggle](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/slack-toggle.png) |
| :--: |



## 4. Create toolchain

- Click the create button at the bottom of the page, and wait for the toolchain to be created.

| ![Ready toolchain](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/ready.png) |
| :--: |

 Note: The individual toolchain integrations can be configured also after the pipeline has been created.




## 5. Run the CD Pipeline

- Make sure the PR & CI Pipeline ran successfully before running the `Promotion Pipeline`.
- The Promotion Pipeline creates a `Pull Request` with the content of the inventory on the Inventory Source Environment (eg: `master`) branch targeting the Inventory Target Environment branch (eg: `staging`). An intermediary branch for the PR is created which can be discarded after the PR has been merged. If this `Pull Request` gets merged, you can trigger the `CD Pipeline`. (There is a Git Trigger set up, but disabled, which can be enabled after the first promotion.)
- First, use the `Manual Promotion Trigger` to start the `Promotion Pipeline`.

| ![Running the promotion pipeline](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/run-promotion-pipeline.png) |
| :--: |

- _Optional_: To recieve Slack notifications from this pipeline, turn the `slack-notifications` environment variable to `1`.
- If the `Promotion Pipeline` ran successfully, the `create-promotion-pull-request` Task should provide you a link to the aforementioned `Pull Request`.
- Complete the fields in the `PR`, to generate the `Change Request` for ServiceNow in the `CD Pipeline` run.
- Merge the `Pull Request` from the Github UI. After the merge you have to manually trigger the run of `CD Pipeline`. There is a Git Trigger set up, but disabled, which can be enabled after the first promotion.

Note: You can also trigger the `CD Pipeline` manually any time, but if there is no changes since the last successful deployment, the CD pipeline won't deploy anything new.
