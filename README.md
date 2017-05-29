## Intro

When running apps in Openshift we want to have bigger insigts to the apps itself. So we want to deploy monitoring agents toggether with our apps. 
Where is 3 ways to do so.

## PreRequisisted 

You will need Openshift Environment running somewhere. [Minishift](https://github.com/minishift/minishift) is your friend in this case :)

## AllInOne: Make monitoring agent part of the image

If we chose to make monitoring agent part of the image itself. This patern is one of the most common, and its fine to use it sometimes. It became popular in the early staged of K8S/OCP. Now there is other features available for us to consume within platform. So there is few better way to do so. But if you still chose to go "one image way" this is how its best to do it within openshift environment:

Have base images from Red Hat or other third party created in project of your chosing. As example we will use WebServer 3.0 image as our hosting platform.

In this example we take existing image from project and add one more layer. This method does not create need to have version control repository or have any other depencies. You will be consuming newly created image and when third party updated base image, you will get your layer rebuilt and available almost imidiatly, 

Build example:
```
cat allinone-pattern/template.yaml
```

## SIDECAR New Relic Server Monitoring Agent Example for Openshift

This example shows how to run a New Relic server monitoring agent as a sidecar in the openshift deployment with your app server.
Benefit or running it as [sidecar](http://blog.kubernetes.io/2015/06/the-distributed-system-toolkit-patterns.html) is that you lifecycle those components separatly and avoid bigbang changes.

This allows to maintain each and every app componet separatly. 

Downside for this that you need to run 2 container at all times, even if second container does not do anthing apart providing libraries. 
This make sence when 2 processes runs independently and need to comunicate via API or filesystem. 

1. We will build newrelic monitoring agent container:
```
cd cidecar-pattern/container
#download newrelic binaries to newrelic folder. Including jars, certificates, configfiles. If you feel bad baking some of this stuff to container (you should be), you can provide them via configMaps.
docker build -t mangirdas/newrelic-sidecar .
```

2. We deploy secrets, and configs needed for this deployment. 
In the first example we would use same patterns, but for simplicity we didnt do this in first example, so we doing now.

Lets generate secrets:
```
cd cidecar-pattern/template/secrets
#update nrcofig.env secret with your app details
./config-to-secret.sh
oc create -f newrelic-config.yaml 
oc create -f newrelic-secret.yaml 
#This will create secrets and configMaps
#create and deploy this app from UI or CLI and we will see 2 containers running together.
oc process -f template.yaml -p APPLICATION_NAME=cidecar | oc create -f -
oc start-build cidecar
oc rollout latest dc/sidecar
```

## InitContainer New Relic Server Monitoring Agent Example for Openshift

Init containers are perfect when we need to deliver static content or do main container pre-configuration. This can be abused so make sure you not doing something which would brake 12 factor app development principals.

In this scenario we will deploy same application, but our init container will deploy newrelic monitoring agent directly to the main container. In this way we will not be running second container all the time. It will be used only to provide required artifacts. 

```
#lets build similar container for mon agent.
cd init-pattern/container
docker build -t mangirdas/newrelic-init .
#create same secrets and configs as in case 2
cd init-pattern/template/secret
#update nrconfig.env file and create config
./config-to-secret.sh
oc create -f newrelic-config.yaml
oc create -f newrelic-secret.yaml
#we deploy same as we did in case 2. 
oc process -f template.yaml -p APPLICATION_NAME=init | oc create -f -
oc start-build init
oc rollout latest dc/init
```
