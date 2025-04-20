# Pobierz bazowy obraz Ubuntu
FROM ubuntu:24.04

# Ustawienia środowiska - nie pytaj o interakcję przy instalacji
ENV DEBIAN_FRONTEND=noninteractive

# Ustaw powłokę na bash dla wszystkich RUN
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y gradle

# Instalacja podstawowych pakietów
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    unzip \
    zip \
    openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalacja Pythona 3.10
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalacja SDKMAN!
RUN curl -s "https://get.sdkman.io" | bash

# Dodanie SDKMAN! do ścieżki
RUN echo "source $HOME/.sdkman/bin/sdkman-init.sh" >> ~/.bashrc

# Sprawdzenie, czy SDKMAN! został poprawnie zainstalowany
RUN ls -l $HOME/.sdkman/bin/sdkman-init.sh

# Instalacja Kotlina przez SDKMAN!
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install kotlin && sdk install gradle"


# Ustawienie katalogu roboczego
WORKDIR /app

COPY build.gradle ./
COPY src /src



# Domyślnie otwieraj bash po uruchomieniu kontenera
CMD ["gradle", "run"]
