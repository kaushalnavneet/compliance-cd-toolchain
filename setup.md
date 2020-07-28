# Setup Guide for Tekton CD Pipeline with Compliance

### 1. Create toolchain:

A toolchain can be created by
* **Create button** in the README

   [![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south)

* **Using the URL**  
<https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-cd-toolchain&env_id=ibm:yp:us-south&branch=master>

Using the url, modifications can be tried out before merging into master by changing the branch to a feature branch.

### 2. Name toolchain and select a toolchain region

| ![Toolchain Name](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/name.png) |
| :--: | 

Note: toolchain region can differ from cluster

### 3. Tool integrations

#### Repositories

| ![Repositories](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/repositories.png) |
| :--: | 

- **Tekton definitions**

    Tekton definitions can be changed also after the toolchain is created. These repositories can be contributed to or can be forked.  
    All fields are required.

    - **Tekton Catalog repo URL:**
        The common tekton tasks are contained in this repo.  
        Default: <https://github.ibm.com/one-pipeline/common-tekton-tasks>

    - **Tekton Definition repo URL:**
        The tekton pipeline defintions (pipeline(s), triggers, listeners, etc.) are kept in this repo.  
        Default: <https://github.ibm.com/one-pipeline/compliance-cd-toolchain> 

- **Application related repositories**

    If you used the <https://github.ibm.com/one-pipeline/compliance-ci-toolchain> template to set up your CI process, check out your CI toolchain and copy the names of the repositories used there.
    If you set up your CI toolchain from scratch, you will still need to add these repositories there, and use the same ones here.

    - **Application repo URL:** The application to be deployed.  
        Default: `""`  
        E.g.: <https://github.ibm.com/myorg/my-compliance-app>

    - **Incident issues repo URL:** Issues about incidents that happen during the build and deployment process are stored here.    
        Default: `""`  
        E.g.: <https://github.ibm.com/myorg/my-compliance-ci-issues>
        
        Note: This is WIP, cd pipeline currently does not use this repo yet.

    - **Evidence locker repo URL:** All raw compliance evidence that belongs to the application is collected here.  
        Default: `""`     
        E.g.: <https://github.ibm.com/myorg/my-compliance-ci-evidence>  

    - **Inventory repo URL:** Change management is tracked in this repository. CD pipeline creates a new branch named as the created CR number, and merges it to master after deplyment is concluded.
        Default: `""`  
        E.g.: <https://github.ibm.com/myorg/my-compliance-ci-inventory>


#### Delivery Pipeline
The Tekton CD Toolchain with Compliance comes with an integrated Tekton pipeline to manage change requests and deployments.

| ![Delivery Pipeline](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/pipeline.png) |
| :--: | 

- **Application name for Kubernetes deployment:**  
The name of the application. CD pipeline will look for running pods on the target cluster labelled with the application name, to calculate changes from the previously deployed version.
This should be the same as in the `deployment.yaml` file in the application repo.

    Default: `hello-compliance-app`
    
- **IBM Cloud API Key:**  
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
    
- **EMERGENCY Label for PRs and issues:** If the pull request was labelled with an emergency label, e.g. "EMERGENCY", the resulting change request will have its `type` set to that value. You should ensure whatever label you specify here matches the actual label being used to identify the pull request emergency type.
    Default: `EMERGENCY`
    
#### Delivery Pipeline Private Worker

| ![Private Worker](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/private-worker-tool.png) |
| :--: | 

The Delivery Pipeline Private Worker tool integration connects with one or more private workers that are capable of running Delivery Pipeline workloads in isolation. For more information, see [Working with Private Workers](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-private-workers).
    
#### Artifactory

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

#### Service Now

Service Now is used to keep tack of change requests.

| ![ServiceNow](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/servicenow.png) |
| :--: | 
 
- **ServiceNow API token:** To acquire a ServiceNow API token, submit a request on the Service Portal. Make sure the environment you request for matches the ServiceNow instance in the API URL field below.
    - [PROD](https://watson.service-now.com/ess_portal?id=sc_cat_item&sys_id=02594e86db2c83408799327e9d961999)
    - [TEST](https://watsontest.service-now.com/ess_portal?id=sc_cat_item&sys_id=02594e86db2c83408799327e9d961999)
- **ServiceNow Configuration Item:** The name of the service/app to be associated with Change Requests
    A ServiceNow Configuration item can be requested for [production](https://watson.service-now.com/nav_to.do?uri=%2Fx_ibmwc_ssef_app.do%23!%2Fhome) or [test](https://watsontest.service-now.com/nav_to.do?uri=%2Fx_ibmwc_ssef_app.do%23!%2Fhome) environments.
- **ServiceNow Change Request ID:** A manually created Change Request ID can be provided here. Otherwise the pipeline will create a new change request in ServiceNow. This can be changed in environment properties after the toolchain is created.
- **ServiceNow API Base URL:** The Base URL of the ServiceNow API, can be changed to target the production environment, default is test environment.  
    Default: `https://watsontest.service-now.com`
    
#### Link DOI toolchain

CD toolchain needs a toolchain ID with an existing DevOps Insights instance, so that it is able to publish the deployment records to insights. For now, it should be the CI toolchain ID.

| ![DOI Toolchain ID](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/doi-toolchain.png) |
| :--: | 

You can copy the Toolchain ID from the URL of your toolchain.
A toolchain's URL follows this pattern: `https://cloud.ibm.com/devops/toolchains/<toolchain-ID-comes-here>?env_id=ibm:yp:us-south`

For example, if the URL is: `https://cloud.ibm.com/devops/toolchains/aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee?env_id=ibm:yp:us-south` then the toolchain's ID is: `aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee`.

Note: Make sure to only include the ID here, not the full URL.

### 4. Create toolchain and run cd pipeline

- Click the create button at the bottom of the page, and wait for the toolchain to be created.

| ![Ready toolchain](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/ready.png) |
| :--: | 
 
 Note: The individual toolchain integrations can be configured also after the pipeline has been created.
 
- To run the pipeline select the Delivery Pipeline card. 

| ![Config](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/config.png) |
| :--: | 
  
- Provide version to be deployed

| ![Version](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/version.png) |
| :--: | 
 
   - method 1: add it to the trigger parameters (click Run Pipeline button)
   
| ![Trigger](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/trigger.png) |
| :--: | 
 
   - method 2: add it to the pipeline environmental variables (click Configure Pipeline)
   
| ![Environmental variables](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-cd-toolchain/envs.png) |
| :--: | 
     
Note: The pipeline environment variable overrides the trigger parameter if both are provided. Version changes with almost every pipeline run, it is advisable to provide it as a trigger parameter.
 
 - Run the pipeline by using the manual trigger





