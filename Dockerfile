FROM python:3.9-alpine3.13
LABEL maintanier="collabus"

# No buffer for ouput
ENV PYTHONUNBUFFERED=1

# copy from -> to 
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# default not in development mode
ARG DEV=false 

# create fewer layers this way (upgrade pip , install requirements.tx and only install dev dependencies in devlopment environment , add_user in alpine (so we don't use root user))
# install postgresql dependendies and delete the one that are not need to run postgresql
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .temp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .temp-build-deps && \
    adduser -D -H django-user

# update the path environment variable 
ENV PATH="/py/bin:$PATH"

# user we are switching to
USER django-user