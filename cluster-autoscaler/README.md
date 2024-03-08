# Cluster Autoscaler for AWS EKS Setup Guide

### Creating an IAM OIDC provider for cluster

1. Check whether you have an existing IAM OIDC provider for your cluster. 

```
aws eks describe-cluster --name cluster-Name --region us-west-2 --query "cluster.identity.oidc.issuer" --output text
```
Make sure to replace "cluster-Name" with your cluster name.

2. Create an IAM OIDC identity provider for your cluster with the following command.
   
```
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
```

### Create an IAM Policy

we need to create the IAM policy, which allows CA to increase or decrease the number of nodes in the cluster

To create the policy with the necessary permissions, save the below file as “ca-iam-policy.json” or any.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeImages",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup"
      ],
      "Resource": ["*"]
    }
  ]
}
```
```
 aws iam create-policy   \
   --policy-name YourPolicyName \
   --policy-document file://ca-iam-policy.json
```
Make sure to replace "YourPolicyName" with the desired name for your IAM policy

### Create IAM Role

Create an IAM role for the cluster-autoscaler Service Account in the kube-system namespace.

```
export AWS_ACCOUNT_ID="<Enter your AWS Account ID>"
export AWS_REGION="<your_region_code>"
eksctl create iamserviceaccount \
    --name cluster-autoscaler \
    --namespace kube-system \
    --cluster <your-cluster-name> \
    --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/k8s-cluster-autoscaler-asg-policy" \
    --approve \
    --override-existing-serviceaccounts
```
Make sure to replace "AWS Accoun ID, region code and Cluster Name" with actually name

Follow this link to install the eksctl
```
https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-eksctl.html
```

### Deploy Cluster Autoscaler

Deploy the Cluster Autoscaler to your cluster with the following command:

```
kubectl apply -f ./cluster-autoscaler-auto-discovery.yaml
```
make sure you change the cluster name in the file
