#!/bin/bash

set -e

REPO_URL="https://github.com/mohammed-saifuddin/headout-task"
CLONE_DIR="java_app"

echo "[*] Cloning repo from $REPO_URL..."
git clone "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"


if [ -f "pom.xml" ]; then
  echo "[*] Maven project detected. Building..."
  mvn package -DskipTests
  JAR_PATH=$(find target -name "*.jar" | head -n 1)
elif [ -f "build.gradle" ]; then
  echo "[*] Gradle project detected. Building..."
  ./gradlew build -x test
  JAR_PATH=$(find build/libs -name "*.jar" | head -n 1)
else
  echo "[!] Unknown build system. Exiting."
  exit 1
fi


if [ -f "$JAR_PATH" ]; then
  echo "[*] Running: java -jar $JAR_PATH"
  java -jar "$JAR_PATH"
else
  echo "[!] JAR file not found after build."
  exit 1
fi
