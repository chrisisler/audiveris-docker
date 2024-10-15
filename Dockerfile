FROM eclipse-temurin:21-alpine

RUN apk update && apk add --no-cache \
        curl \
        wget \
        git \
        tesseract-ocr \
        tesseract-ocr-data-eng \
        tesseract-ocr-data-deu \
        tesseract-ocr-data-fra

RUN git clone --progress --branch development https://github.com/Audiveris/audiveris.git
RUN cd audiveris && ./gradlew build
RUN mkdir /audiveris-extract 
RUN tar -xvf /audiveris/app/build/distributions/app*.tar -C /audiveris-extract 
RUN mv ./audiveris-extract/app*/* ./audiveris-extract
RUN rm -r /audiveris

ENV JAVA_OPTS "-Xmx2G"

CMD ["sh", "-c", "/audiveris-extract/bin/Audiveris -batch -export $(ls /input/*.png /input/*.jpg)"]
