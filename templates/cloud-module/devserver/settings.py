"""Minimal Django settings for the module devserver."""

import os
from pathlib import Path

BASE_DIR = Path(__file__).parent

SECRET_KEY = "devserver-local-only-not-for-production"
DEBUG = True
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.staticfiles",
]

ROOT_URLCONF = "urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
            ],
        },
    },
]

STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "static"]

# No database needed
DATABASES = {}
