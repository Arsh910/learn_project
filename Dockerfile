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
# create fewer layers this way (upgrade pip , install requirements.tx and only install dev dependencies in devlopment environment , add_user in alpine (so we don't use root user))
ARG DEV=false 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser -D -H django-user

# update the path environment variable 
ENV PATH="/py/bin:$PATH"

# user we are switching to
USER django-user