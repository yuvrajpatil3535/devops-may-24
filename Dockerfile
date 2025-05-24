# Stage 1: Build React frontend
FROM node:18 AS frontend-build

WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Stage 2: Build Java backend
FROM eclipse-temurin:17 AS backend-build

WORKDIR /app
COPY backend/ .
RUN ./mvnw clean package -DskipTests

# Stage 3: Final image
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy backend jar
COPY --from=backend-build /app/target/*.jar app.jar

# Copy frontend build files
COPY --from=frontend-build /app/build ./frontend-build

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

