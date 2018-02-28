{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scylladb.name" -}}
{{- default "scylladb" .Values.scylladbNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scylladb.fullname" -}}
{{- $name := default "scylladb" .Values.scylladbNameOverride -}}
{{- $release := default .Release.Name .Values.scylladbReleaseOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate an image path.
Conditionally render repositoryUrl IFF artifact doesn't include a path component (/)
*/}}
{{- define "scylladb.imageId" -}}
{{- if .Values.global.image.repositoryPrefix -}}
{{- if contains "/" .Values.image.repository -}}
{{- else -}}
{{- .Values.global.image.repositoryPrefix -}}/
{{- end -}}
{{- end -}}
{{- .Values.image.repository -}}:{{- .Values.global.image.tag | default "latest" -}}
{{- end -}}
