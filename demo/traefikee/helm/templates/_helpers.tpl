
{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 40 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Cluster name is limited to 30 chars.
If release name contains chart name it will be used as a full name.
*/}}
{{- define "traefikee.fullname" -}}
    {{- $clusterName := .Release.Name | trunc 30 -}}
    {{/*Modifying template variables via assignments is not permitted via the = token in helm v1.11*/}}
    {{- if contains .Chart.Name .Release.Name -}}
        {{- printf "%s" .Release.Name | trunc 40 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s-%s" .Chart.Name $clusterName | trunc 40 | trimSuffix "-" -}}
    {{- end -}}

{{- end -}}

{{/*
Determine the Service Account name
*/}}
{{- define "traefikee.serviceAccountName" -}}
    {{- .Values.customServiceAccountName | default (printf "%s" (include "traefikee.fullname" .)) -}}
{{- end -}}

{{/*
Determine the Service Account Bootstrap name
*/}}
{{- define "traefikee.serviceAccountBootstrapName" -}}
    {{- .Values.customServiceAccountBootstrapName | default (printf "%s-bootstrap" (include "traefikee.fullname" .)) -}}
{{- end -}}

{{/*
Define the Chart version Label
*/}}
{{- define "traefikee.chartLabel" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{/*
Define the templated image with tag
*/}}
{{- define "traefikee.image" -}}
    {{- printf "%s:%s" .Values.image.name ( .Values.image.tag | default .Chart.AppVersion ) -}}
{{- end -}}

{{/*
Create a password hash from the random password
*/}}
{{- define "traefikee.randomPasswordHash" -}}
    {{- (sha1sum .Values.dashboard.password) | b64enc -}}
{{- end -}}

{{/*
Returns the cluster internal API service name.
*/}}
{{- define "traefikee.clusterInternalAPIServiceName" -}}
    {{- printf "%s-api-svc" (include "traefikee.fullname" .) -}}
{{- end -}}

{{/*
Returns the control nodes service name.
*/}}
{{- define "traefikee.controlNodesServiceName" -}}
    {{- printf "%s-ctrl-svc" (include "traefikee.fullname" .) -}}
{{- end -}}

{{/*
Returns the dashboard service name.
*/}}
{{- define "traefikee.dashboardServiceName" -}}
    {{- printf "%s-web-svc" (include "traefikee.fullname" .) -}}
{{- end -}}

{{/*
Returns the data node external service name.
*/}}
{{- define "traefikee.dataNodeExternalServiceName" -}}
    {{- printf "%s-data-svc" (include "traefikee.fullname" .) -}}
{{- end -}}
