{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "lescinskas.lt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lescinskas.lt.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lescinskas.lt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "lescinskas.lt.labels" -}}
helm.sh/chart: {{ include "lescinskas.lt.chart" . }}
{{ include "lescinskas.lt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "lescinskas.lt.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lescinskas.lt.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "lescinskas.lt.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "lescinskas.lt.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Deployment strategy
*/}}
{{- define "lescinskas.lt.deploymentStrategy" -}}
type: RollingUpdate
rollingUpdate:
  maxSurge: {{ .Values.maxSurge | default 1 }}
  maxUnavailable: {{ .Values.maxUnavailable | default 1 }}
{{- end -}}

{{- define "lescinskas.lt.podAntiAffinity" -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchExpressions:
      - key: "app.kubernetes.io/name"
        operator: In
        values:
          - {{ include "lescinskas.lt.name" . | quote}}
      - key: "app.kubernetes.io/instance"
        operator: In
        values:
          - {{ .Release.Name |quote }}
    topologyKey: "kubernetes.io/hostname"
{{- end -}}
