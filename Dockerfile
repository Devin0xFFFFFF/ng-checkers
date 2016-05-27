FROM google/dart

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app/
RUN pub get --offline

RUN pub build --mode=release

RUN mkdir -p /usr/share/nginx/angular2

RUN cp -r ./build/web/. /usr/share/nginx/angular2

ENTRYPOINT ["true"]