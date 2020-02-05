# Oracle WebLogic Operator Tutorial #

### Deploy Oracle WebLogic Domain (*Domain-home-in-image*) on Kubernetes using Oracle WebLogic Operator  ###

This lab demonstrates how to deploy and run Weblogic Domain container packaged Web Application on Kubernetes Cluster using [Oracle WebLogic Server Kubernetes Operator 2.0](https://github.com/oracle/weblogic-kubernetes-operator).

The demo Web Application is a simple JSP page which shows WebLogic Domain's MBean attributes to demonstrate WebLogic Operator features.

**Architecture**

WebLogic domain can be located either in a persistent volume (PV) or in a Docker image. [There are advantages to both approaches, and there are sometimes technical limitations](https://github.com/oracle/weblogic-kubernetes-operator/blob/2.0/site/domains.md#create-and-manage-weblogic-domains) of various cloud providers that may make one approach better suited to your needs.

This tutorial implements the Docker image with the WebLogic domain inside the image deployment. This means all the artefacts, domain related files are stored within the image. There is no central, shared domain folder from the pods. This is similar to the standard installation topology where you distribute your domain to different host to scale out Managed servers. The main difference is that using container packaged WebLogic Domain you don't need to use pack/unpack mechanism to distribute domain binaries and configuration files between multiple host.

![](images/wlsonk8s.domain-home-in-image.png)

In Kubernetes environment WebLogic Operator ensures that only one Admin and multiple Managed servers will run in the domain. An operator is an application-specific controller that extends Kubernetes to create, configure, and manage instances of complex applications. The Oracle WebLogic Server Kubernetes Operator (the "operator") simplifies the management and operation of WebLogic domains and deployments.

Helm is a framework that helps you manage Kubernetes applications, and helm charts help you define and install Helm applications into a Kubernetes cluster. Helm has two parts: a client (Helm) and a server (Tiller). Tiller runs inside of your Kubernetes cluster, and manages releases (installations) of your charts.

This tutorial has been tested on Oracle Cloud Infrastructure Container Engine for Kubernetes (OKE).

### Prerequisites ###

The following labs require an Oracle Public Cloud account. You may use your own cloud account, or a cloud account that you obtained through a trial. However, if you do not have an account, please navigate to the following page to acquire an Oracle Cloud Trial Account [Acquire a Trial Account](trial.account.md).



### The topics to be covered in this hands-on session are: ###

 1. [Setup Oracle Kubernetes Engine instance on Oracle Cloud Infrastructure](setup.oke.md)
 2. [Create Developer Compute VM on Oracle Cloud Infrastructure](setup.dev.compute.instance.md)
 3. [Install WebLogic Operator](install.operator.md)
 4. [Install Traefik Software Loadbalancer](install.traefik.md)
 5. [Deploy WebLogic Domain](deploy.weblogic_short.md)
 6. [Scaling WebLogic Cluster](scale.weblogic.md)
 7. [Override JDBC Datasource parameters](override.jdbc.md)
 8. [Updating deployed application by rolling restart to the new image](update.application_short.md)
 9. [Assigning WebLogic Pods to Nodes (scenario simulating cluster spanning 2 data center)](node.selector.md)
 10. [Assigning WebLogic Pods to Nodes (scenario simulating licensing only the subset of the cluster)](node.selector.license.md)
