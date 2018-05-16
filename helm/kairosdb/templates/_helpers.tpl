{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kairosdb.name" -}}
{{- default "kairosdb" .Values.kairosdbNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kairosdb.scyllaName" -}}
{{- default "scylladb" .Values.scylladbNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kairosdb.fullname" -}}
{{- $name := default "kairosdb" .Values.kairosdbNameOverride -}}
{{- $release := default .Release.Name .Values.kairosdbReleaseOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kairosdb.scyllaFullname" -}}
{{- $name := default "scylladb" .Values.scylladbNameOverride -}}
{{- $release := default .Release.Name .Values.scylladbReleaseOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate an image path.
Conditionally render repositoryUrl IFF artifact doesn't include a path component (/)
*/}}
{{- define "kairosdb.kairosImageId" -}}
{{- if .Values.global.image.repositoryPrefix -}}
{{- if contains "/" .Values.kairosdb.image.repository -}}
{{- else -}}
{{- .Values.global.image.repositoryPrefix -}}/
{{- end -}}
{{- end -}}
{{- .Values.kairosdb.image.repository -}}:{{- .Values.kairosdb.image.tag | default "latest" -}}
{{- end -}}

{{- define "kairosdb.scyllaImageId" -}}
{{- if .Values.global.image.repositoryPrefix -}}
{{- if contains "/" .Values.scylladb.image.repository -}}
{{- else -}}
{{- .Values.global.image.repositoryPrefix -}}/
{{- end -}}
{{- end -}}
{{- .Values.scylladb.image.repository -}}:{{- .Values.scylladb.image.tag | default "latest" -}}
{{- end -}}