FROM maven:3.9.9-eclipse-temurin-17

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B -DskipTests clean package

EXPOSE 10000

CMD ["mvn", "-B", "-DskipTests", "exec:java"]
