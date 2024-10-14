FROM eclipse-temurin:21
# RUN mkdir /opt/app
# COPY japp.jar /opt/app
# CMD ["java", "-jar", "/opt/app/japp.jar"]

RUN apk update && apk install -y  \
        curl \
        wget \
        git \
        tesseract-ocr \
        tesseract-ocr-eng \
        tesseract-ocr-deu \
        tesseract-ocr-fra

# ENV JAVA_HOME=/usr/lib/jvm/jdk-17/ 
ENV PATH=$PATH:$JAVA_HOME/bin 

RUN  git clone --branch development https://github.com/Audiveris/audiveris.git && \
        cd audiveris && \
        ./gradlew build && \
        mkdir /audiveris-extract && \
        tar -xvf /audiveris/build/distributions/Audiveris*.tar -C /audiveris-extract && \
        mv /audiveris-extract/Audiveris*/* /audiveris-extract/ &&\
        rm -r /audiveris

CMD ["sh", "-c", "/audiveris-extract/bin/Audiveris -batch -export -output /output/ $(ls /input/*.jpg /input/*.png /input/*.pdf)"]
