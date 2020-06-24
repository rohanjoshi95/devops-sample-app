FROM openjdk:8 
ADD target/ProductManager-0.0.1-SNAPSHOT.jar productManager.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "productManager.jar"]