# Kubernetes Boilerplate

This repository contains useful boilerplate scripts and configuration files used for the setup and management of a kubernetes cluster on the AWS cloud platform using KOPS. Please email me at "ericdobyns@gmail.com" for any questions.

## Getting Started

- Find and replace "projectname" in versions.json with your desired name
- Find and replace "projectname" in relevant config-application files and config-kubernetes files
- Add AWS ssl certificate arn to kubernetes/ingress-nginx/ingress-service.yaml
- Edit and deploy desired /config-application files using "kubectl create" or "kubectl apply" commands

## Ingress

On the AWS platform I prefer to route traffic through the kubernetes cluster using ingress-nginx. To setup an AWS loadbalancer to distribute traffic use the ingress-nginx deployment and service scripts to get started. Please make sure to add an AWS ECM SSL ARN to the ingress-service.yaml.

## Helm Packages

Find and install any desired helm packages using "helm search" command.

I prefer to use:
- EFK or LogDNA (Logging platforms)
- Prometheus/Grafana (Monitoring, Alarms)

## Auto Scaling

- Use the "kubectl autoscale" command to configure any horizontal pod autoscalers. 
- Use AWS autoscaling to handle any vertical node autoscaling 

## CI/CD

This repository is used alongside a CI/CD service that builds, uploads and deploys new application images. Node/NPM is used to run bash scripts and deliver slack notifications upon completion. Please view the scripts directory and package.json for more details.