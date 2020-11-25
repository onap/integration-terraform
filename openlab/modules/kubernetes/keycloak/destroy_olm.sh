#!/bin/bash

delete_all(){
    kubectl delete deployment -n olm --all

    # Delete OLM
    #kubectl delete catalogsources.operators.coreos.com operatorhubio-catalog.operators.coreos.com
    #kubectl delete clusterserviceversions.operators.coreos.com packageserve.operators.coreos.com
    kubectl delete installplans.operators.coreos.com
    kubectl delete operatorgroups.operators.coreos.com subscriptions.operators.coreos.com
    kubectl delete apiservices.apiregistration.k8s.io v1.packages.operators.coreos.com

    kubectl delete namespace olm
    kubectl delete customresourcedefinition -n operators
    kubectl delete namespace operators

    # Delete cluster roles
    kubectl delete clusterrole.rbac.authorization.k8s.io/aggregate-olm-edit
    kubectl delete clusterrole.rbac.authorization.k8s.io/aggregate-olm-view
    kubectl delete clusterrole.rbac.authorization.k8s.io/system:controller:operator-lifecycle-manager
    kubectl delete clusterrolebindings.rbac.authorization.k8s.io "olm-operator-binding-olm"
}

# This script should always return 'true' to prevent Terraform fails to destroy OLM
delete_all || true
