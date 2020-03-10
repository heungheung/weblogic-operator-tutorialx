# Lab 6: Deploy WebLogic domain  #

## Preparing the Kubernetes cluster to run WebLogic domains ##

Create the domain namespace:
```
kubectl create namespace sample-domain1-ns
```
Create a Kubernetes secret containing the Administration Server boot credentials:
```
kubectl -n sample-domain1-ns create secret generic sample-domain1-weblogic-credentials \
  --from-literal=username=weblogic \
  --from-literal=password=welcome1
```

## Update Traefik loadbalancer and WebLogic Operator configuration ##

Once you have your domain namespace (WebLogic domain not yet deployed) you have to update loadbalancer's and operator's configuration about where the domain will be deployed.

Make sure before execute domain `helm` install you are in the WebLogic Operator's local Git repository folder.
```
cd /u01/content/weblogic-kubernetes-operator/
```
To update operator execute the following `helm upgrade` command:
```
helm upgrade \
  --reuse-values \
  --set "domainNamespaces={sample-domain1-ns}" \
  --wait \
  sample-weblogic-operator \
  kubernetes/charts/weblogic-operator
```

To update Traefik execute the following `helm upgrade` command:
```
helm upgrade \
  --reuse-values \
  --set "kubernetes.namespaces={traefik,sample-domain1-ns}" \
  --wait \
  traefik-operator \
  stable/traefik
```
Please note the only updated parameter in both cases is the domain namespace.

## Deploy WebLogic domain on Kubernetes ##

To deploy WebLogic domain you need to create a domain resource definition which contains the necessary parameters for the operator to start the WebLogic domain properly.

We provided for you domain.yaml file that contains yaml representation of the custom resource object. Please copy it locally
```
curl -LSs https://raw.githubusercontent.com/kwanwan/weblogic-operator-tutorial/master/k8s/domain_short_apac.yaml >/u01/domain.yaml
```
Please review it with your favourite editor.

Create Domain custom resource object by applying the following command:
```
kubectl apply -f /u01/domain.yaml
```
Check the introspector job which needs to be run first:
```
$ kubectl get pod -n sample-domain1-ns
NAME                                         READY     STATUS              RESTARTS   AGE
sample-domain1-introspect-domain-job-kcn4n   0/1       ContainerCreating   0          7s
```
Check periodically the pods in the domain namespace and soon you will see the servers are starting:
```
$ kubectl get po -n sample-domain1-ns -o wide
NAME                             READY     STATUS    RESTARTS   AGE       IP            NODE            NOMINATED NODE
sample-domain1-admin-server      1/1       Running   0          2m        10.244.2.10   130.61.84.41    <none>
sample-domain1-managed-server1   1/1       Running   0          1m        10.244.2.11   130.61.84.41    <none>
sample-domain1-managed-server2   0/1       Running   0          1m        10.244.1.4    130.61.52.240   <none>
```
You have to see three running pods similar to the result above. If you don't see all the running pods please wait and check periodically. The whole domain deployment may take up to 2-3 minutes depending on the compute shapes.


---

**Note**: If you do not see the three running pods similar to the result above and instead you see a `DeadlineExceeded` status for the pod that is running your deployment job similar to below then your deployment job is probably stuck.

```
$ kubectl get po -n sample-domain1-ns -o wide -w
NAME                                         READY   STATUS              RESTARTS   AGE   IP       NODE        NOMINATED NODE   READINESS GATES
sample-domain1-introspect-domain-job-lnfz7   0/1     ContainerCreating   0          17s   <none>   10.0.10.2   <none>           <none>
sample-domain1-introspect-domain-job-lnfz7   0/1     DeadlineExceeded    0          70s   10.244.1.4   10.0.10.2   <none>           <none>
```

To resolve this, you will first need to undo the deployment by running:

```
$ kubectl delete -f ~/content/domain.yaml
domain.weblogic.oracle "sample-domain1" deleted
```
Then, delete the stuck pod that is running your stuck deployment job.  

```
$ kubectl delete --all pods --namespace sample-domain1-ns
pod "sample-domain1-introspect-domain-job-lnfz7" deleted
```

Check if the stuck job is still running by running:

```
$ kubectl get pod -n sample-domain1-ns
No resources found.
```

You can now retry the deployment again by running:

```
kubectl apply -f ~/content/domain.yaml
```

And follow its progress.

```
kubectl get po -n sample-domain1-ns -o wide -w
```

**End of Note**

---


In order to access any application or admin console deployed on WebLogic you have to configure *Traefik* ingress. OCI Load balancer is already assigned during *Traefik* install in the previous step.

As a simple solution the best is to configure path routing which will route the external traffic through *Traefik* to domain cluster address or admin server's console.

Execute the following ingress resource definition:
```
cat << EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: traefik-pathrouting-1
  namespace: sample-domain1-ns
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host:
    http:
      paths:
      - path: /
        backend:
          serviceName: sample-domain1-cluster-cluster-1
          servicePort: 8001
      - path: /console
        backend:
          serviceName: sample-domain1-admin-server
          servicePort: 7001          
EOF
```


Please note the two backends and the namespace, serviceName, servicePort definitions. The first backend is the domain cluster service to reach the application at the root context path. The second is for the admin console which is a different service.

Once the Ingress has been created construct the URL of the admin console based on the following pattern:

`http://EXTERNAL-IP/console`

The EXTERNAL-IP was determined during Traefik install. If you forgot to note the execute the following command to get the public IP address:
```
$ kubectl describe svc traefik-operator --namespace traefik | grep Ingress | awk '{print $3}'
129.213.172.44
```
Construct the Administration Console's url and open in a browser:

Enter admin user credentials (weblogic/welcome1) and click **Login**

![](images/deploy.domain/weblogic.console.login.png)

!Please note in this use case the use of Administration Console is just for demo/test purposes because domain configuration persisted in pod which means after the restart the original values (baked into the image) will be used again. To override certain configuration parameters - to ensure image portability - follow the override part of this tutorial.

## Test the demo Web Application ##

The URL pattern of the sample application is the following:

`http://EXTERNAL-IP/opdemo/?dsname=testDatasource`

![](images/deploy.domain/webapp.png)

Refresh the page and notice the hostname changes. It reflects the managed server's name which responds to the request. You should see the load balancing between the two managed servers.

You can ignore the database error as the datasource has not be set up yet. We will configure the datasource in the Override JDBC Datasource Parameters lab.


### You are now ready to move to the next lab - [Lab 7: Scaling WebLogic Cluster](scale.weblogic.md) ###
