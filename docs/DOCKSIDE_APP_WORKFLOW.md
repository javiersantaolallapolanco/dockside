# Dockside Application Workflow

Esta es la plantilla oficial para cualquier aplicación gestionada por Dockside.

## Copiar

Copiar:

templates/github/workflows/dockside-app.yml

a:

.github/workflows/build-image.yml

## Cambiar únicamente

APP_NAME

IMAGE_NAME

Ejemplo:

APP_NAME=inventario

IMAGE_NAME=inventario

## Flujo

git push

↓

GitHub Actions

↓

Build Docker

↓

Push GHCR

↓

Runner QNAP

↓

Dockside

↓

dockside deploy APP_NAME

## Requisitos

La aplicación debe estar instalada previamente:

bin/dockside install /ruta/al/repositorio

bin/dockside use APP_NAME

A partir de ese momento cualquier push en main desplegará automáticamente la nueva imagen.
