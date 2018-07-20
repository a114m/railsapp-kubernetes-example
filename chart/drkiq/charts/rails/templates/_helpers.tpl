{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rails.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rails.unicornName" -}}
{{- default "unicorn" .Values.unicornNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rails.sidekiqName" -}}
{{- default "sidekiq" .Values.sidekiqNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rails.fullname" -}}
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

{{- define "rails.unicornFullname" -}}
{{- if .Values.unicornFullnameOverride -}}
{{- .Values.unicornFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "unicorn" .Values.unicornNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "rails.sidekiqFullname" -}}
{{- if .Values.sidekiqFullnameOverride -}}
{{- .Values.sidekiqFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "sidekiq" .Values.sidekiqNameOverride -}}
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
{{- define "rails.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create service name.
*/}}
{{- define "rails.svcName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $perfix := .Release.Namespace -}}
{{- printf "%s-%s" $perfix $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Read env from global values.
*/}}
{{- define "rails.env" -}}
{{- range $global_cm := .Values.global.env_cm -}}
{{- range $name, $key := $global_cm.data -}}
- name: {{ $name }}
  valueFrom:
    configMapKeyRef:
      key: {{ $key | quote }}
      name: {{ $global_cm.cm_name | replace "<local>" (printf "%s-drkiq" $.Release.Namespace) | quote -}}
{{- end -}}
{{- end -}}
{{- range $cm := .Values.env_cm -}}
{{- range $name, $key := $cm.data }}
- name: {{ $name }}
  valueFrom:
    configMapKeyRef:
      key: {{ $key }}
      name: {{ $cm.cm_name | replace "<local>" (printf "%s-drkiq" $.Release.Namespace) | quote -}}
{{- end -}}
{{- end -}}
{{- range $key, $value := .Values.global.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- range $key, $value := .Values.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}
