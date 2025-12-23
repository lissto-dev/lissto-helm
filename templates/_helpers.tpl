{{/*
Expand the name of the chart.
*/}}
{{- define "lissto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "lissto.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lissto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lissto.labels" -}}
helm.sh/chart: {{ include "lissto.chart" . }}
{{ include "lissto.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lissto.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lissto.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Controller labels
*/}}
{{- define "lissto.controller.labels" -}}
helm.sh/chart: {{ include "lissto.chart" . }}
{{ include "lissto.controller.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: controller
control-plane: controller-manager
{{- end }}

{{/*
Controller selector labels
*/}}
{{- define "lissto.controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lissto.name" . }}-controller
app.kubernetes.io/instance: {{ .Release.Name }}
control-plane: controller-manager
{{- end }}

{{/*
API labels
*/}}
{{- define "lissto.api.labels" -}}
helm.sh/chart: {{ include "lissto.chart" . }}
{{ include "lissto.api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: api
{{- end }}

{{/*
API selector labels
*/}}
{{- define "lissto.api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lissto.name" . }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Bot labels
*/}}
{{- define "lissto.bot.labels" -}}
helm.sh/chart: {{ include "lissto.chart" . }}
{{ include "lissto.bot.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: bot
{{- end }}

{{/*
Bot selector labels
*/}}
{{- define "lissto.bot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lissto.name" . }}-bot
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the controller service account
*/}}
{{- define "lissto.controller.serviceAccountName" -}}
{{- if .Values.controller.serviceAccount.create }}
{{- default (printf "%s-controller" (include "lissto.fullname" .)) .Values.controller.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.controller.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the namespace
*/}}
{{- define "lissto.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Get image registry
*/}}
{{- define "lissto.imageRegistry" -}}
{{- .Values.global.imageRegistry | default "ghcr.io/lissto.dev" }}
{{- end }}

{{/*
Get controller image
*/}}
{{- define "lissto.controller.image" -}}
{{- $registry := include "lissto.imageRegistry" . }}
{{- $repository := .Values.controller.image.repository }}
{{- $tag := .Values.controller.image.tag | default .Chart.AppVersion }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}

{{/*
Get API image
*/}}
{{- define "lissto.api.image" -}}
{{- $registry := include "lissto.imageRegistry" . }}
{{- $repository := .Values.api.image.repository }}
{{- $tag := .Values.api.image.tag | default .Chart.AppVersion }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}

{{/*
Get Bot image
*/}}
{{- define "lissto.bot.image" -}}
{{- $registry := include "lissto.imageRegistry" . }}
{{- $repository := .Values.bot.image.repository }}
{{- $tag := .Values.bot.image.tag | default .Chart.AppVersion }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}

{{/*
Get image pull policy
*/}}
{{- define "lissto.imagePullPolicy" -}}
{{- .Values.global.imagePullPolicy | default "IfNotPresent" }}
{{- end }}

