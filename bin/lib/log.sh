#!/bin/sh

set -e

C_RST="\e[0m"

C_INF="\e[34m"
C_OKK="\e[32m"
C_ERR="\e[31m"
C_WRN="\e[33m"

function log_task_start()   { local TASK="$1"; shift; echo -e "${C_INF}[BEGIN] [$TASK] $@${C_RST}"; }
function log_task_error()   { local TASK="$1"; shift; echo -e "${C_ERR}[ERROR] [$TASK] $@${C_RST}"; }
function log_task_success() { local TASK="$1"; shift; echo -e "${C_OKK}[SUCCESS] [$TASK] $@${C_RST}"; }
function log_task_warning() { local TASK="$1"; shift; echo -e "${C_WRN}[WARNING] [$TASK] $@${C_RST}"; }

function log_info()         { echo -e "${C_INF}[INFO] $@${C_RST}"; }
function log_ok()           { echo -e "${C_OKK}[OK] $@${C_RST}"; }
function log_error()        { echo -e "${C_ERR}[ERROR] $@${C_RST}" >&2; }
function log_warning()      { echo -e "${C_WRN}[WARNING] $@${C_RST}"; }
