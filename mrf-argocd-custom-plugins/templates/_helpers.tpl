{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "mrf-base-chart.name" -}}
    {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mrf-base-chart.fullname" -}}
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
{{- define "mrf-base-chart.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden
*/}}
{{- define "mrf-base-chart.namespace" -}}
    {{- if .Values.namespaceOverride -}}
        {{- .Values.namespaceOverride -}}
    {{- else -}}
        {{- .Release.Namespace -}}
    {{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mrf-base-chart.labels" -}}
helm.sh/chart: {{ include "mrf-base-chart.chart" . }}
{{ include "mrf-base-chart.selectorLabels" . }}
{{- if ( or .Chart.AppVersion .Values.AppVersion ) }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "mrf-base-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mrf-base-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
    {{- if .Values.cluster }}
cluster: {{ .Values.cluster | quote }}
    {{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mrf-base-chart.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "mrf-base-chart.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}
