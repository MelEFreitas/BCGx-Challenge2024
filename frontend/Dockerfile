FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y \
  libxi6 \
  libgtk-3-0 \
  libxrender1 \
  libxtst6 \
  libxslt1.1 \
  curl \
  git \
  wget \
  unzip \
  libgconf-2-4 \
  gdb \
  libstdc++6 \
  libglu1-mesa \
  fonts-droid-fallback \
  lib32stdc++6 \
  python3 \
  && apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY . /app/
WORKDIR /app/

RUN flutter pub get
RUN flutter gen-l10n

RUN flutter build web --release --web-renderer html

FROM nginx:1.27.2-alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]