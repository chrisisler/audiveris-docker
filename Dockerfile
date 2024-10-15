FROM eclipse-temurin:21-alpine
# RUN mkdir /opt/app
# COPY japp.jar /opt/app
# CMD ["java", "-jar", "/opt/app/japp.jar"]

RUN apk update && apk add --no-cache \
        curl \
        wget \
        git \
        tesseract-ocr \
        tesseract-ocr-data-eng \
        tesseract-ocr-data-deu \
        tesseract-ocr-data-fra

# ENV JAVA_HOME=/usr/lib/jvm/jdk-17/ 
ENV PATH=$PATH:$JAVA_HOME/bin 

RUN  git clone --progress --branch development https://github.com/Audiveris/audiveris.git

RUN cd audiveris && ./gradlew build

RUN mkdir /audiveris-extract 

RUN tar -xvf /audiveris/app/build/distributions/app*.tar -C /audiveris-extract 

# RUN ls -la /audiveris-extract/app*/bin
RUN find ./audiveris-extract/  -type f -name "Audiveris" -exec mv {} /audiveris-extract/ \;
# RUN /audiveris-extract/Audiveris

# RUN mv /audiveris-extract/app*/* /audiveris-extract

# RUN apk add --no-cache file
# RUN cat ./audiveris-extract/Audiveris

# RUN rm -r /audiveris

# RUN ls -la /audiveris-extract
# VOLUME ["/input"]
# VOLUME ["/output"]

# # CMD ["/usr/bin/true"]
# CMD ["sh", "-c", "java -jar /audiveris-extract/audiveris.jar -batch -export -output /output/ $(ls /input/*.jpg /input/*.png /input/*.pdf)"]
CMD ["/audiveris-extract/Audiveris -batch -export -output /output/ $(ls /input/*.jpg /input/*.png /input/*.pdf)"]
