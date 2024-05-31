FROM python:3.11.3
WORKDIR /code
RUN pip install --upgrade pip
RUN pip install setuptools
RUN pip install -U setuptools

RUN echo "Django==4.2" >> requirements.txt
RUN echo "uWSGI==2.0.25" >> requirements.txt
RUN pip install -r requirements.txt

RUN django-admin startproject helloworlddjango
WORKDIR /code/helloworlddjango
RUN echo "ALLOWED_HOSTS = ['127.0.0.1', 'localhost', 'helpabodessltest.shahadathossain.com']" >> helloworlddjango/settings.py

RUN echo "from django.urls import path" > helloworlddjango/urls.py
RUN echo "from django.shortcuts import HttpResponse" >> helloworlddjango/urls.py
RUN echo "def home_page_view_hello_world(request):" >> helloworlddjango/urls.py
RUN echo "    return HttpResponse('Hello World')" >> helloworlddjango/urls.py
RUN echo "urlpatterns = [path('', home_page_view_hello_world, name='helloworld'),]" >> helloworlddjango/urls.py

RUN adduser --disabled-password --no-create-home django
USER django

ENTRYPOINT ["uwsgi", "--http", ":9000", "--workers", "4", "--master", "--enable-threads", "--module", "helloworlddjango.wsgi"]
