FROM openjdk:8-jdk-alpine AS Builder
ADD target/ProductManager-0.0.1-SNAPSHOT.jar productManager.jar

FROM openjdk:8-jdk-alpine
WORKDIR /JARS
COPY --from=Builder productManager.jar /JARS
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "productManager.jar"]
