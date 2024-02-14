# Implementing Argo Rollout Canary Deployment with Istio for Host-Level Traffic And Subset-Level Traffic Splitting

1. Setup Argo Rollouts Controller
Create a namespace and install the Argo Rollouts controller into it.
```
kubectl create namespace argo-rollouts
```
Install the latest version of Argo Rollouts controller:

```
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```
Ensure that all the components and pods for Argo Rollouts are in the running state. You can check it by running the following command:

```
kubectl get all -n argo-rollouts
```

2. To  interact with Argo Rollouts controller is using the kubectl plugin. You can install it by executing the following commands:

```
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
kubectl argo rollouts version
```
```
kubectl get all -n argo-rollouts
```
3. Configure the ArgoCD

4. Use the following command to check the status of the rollout:

```
kubectl argo rollouts get rollout rollout-istio
```
 5. The next step is to promote a canary version of the app using the following command:
```
kubectl argo rollouts set image your-istio-rollout-name your-stio-rollout-containers-name=your-image-name-with-new_version
```

Make sure to replace your-istio-rollout-name, your-stio-rollout-containers-name, and your-image-name-with-new_version with their actual deployment name, container name, and the new image version they want to deploy.

6. Simple Bash loop to check the Canary deployment and argo rollout

```
while true; do curl http://<your-url>; sleep 1; done

```
### Conclusion

This README provides a step-by-step guide to implement Argo Rollout canary deployments with Istio for host-level traffic splitting. By following these instructions, you can efficiently manage and promote different versions of your application while leveraging the features of Argo Rollouts and Istio. Remember to adapt the commands and configurations to your specific environment and deployment needs.
