"""URL configuration for the module devserver."""

from django.urls import path

from views import preview

urlpatterns = [
    path("", preview, name="preview"),
]
