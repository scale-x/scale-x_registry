FROM dart:2.18.1-sdk

ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME
ARG PROJECT_DIR
ARG HOME_DIR

ENV APP_DIR=PROJECT_DIR
ENV PUB_CACHE="${APP_DIR}/.pub-cache"

RUN addgroup --gid $GROUP_ID $GROUP_NAME
RUN adduser --system --ingroup $GROUP_NAME $USER_NAME --home $HOME_DIR --uid $USER_ID --disabled-password

USER $USER_NAME

RUN mkdir -p $APP_DIR

WORKDIR $APP_DIR

COPY . .

# ENTRYPOINT ["tail", "-f", "/dev/null"]