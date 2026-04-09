#!/bin/bash

# =============================================================================
#  Spring PetClinic — Docker Lab (Ubuntu)
#  MCA DevOps Workshop
#  Interactive script: runs each step, explains it, waits for your go-ahead
# =============================================================================

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────

# Print a big step banner
step() {
    echo ""
    echo -e "${BLUE}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}${BOLD}║  $1${RESET}"
    echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# Print what command is about to run
cmd_info() {
    echo -e "${CYAN}${BOLD}▶  Running:${RESET}  ${BOLD}$1${RESET}"
    echo ""
}

# Print an explanation block after a command succeeds
explain() {
    echo ""
    echo -e "${GREEN}${BOLD}📘  What just happened?${RESET}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────${RESET}"
    echo -e "$1"
    echo -e "${GREEN}────────────────────────────────────────────────────────────${RESET}"
    echo ""
}

# Print a warning / note
note() {
    echo -e "${YELLOW}${BOLD}⚠   Note:${RESET} $1"
    echo ""
}

# Ask the student if they want to continue; exit gracefully on 'n'
proceed() {
    echo -e "${MAGENTA}${BOLD}─────────────────────────────────────────────────────────────${RESET}"
    echo -e "${MAGENTA}${BOLD}  Ready to move to the next step?${RESET}"
    echo -e "${MAGENTA}  Press ${BOLD}[Enter]${RESET}${MAGENTA} to continue  or  type ${BOLD}n${RESET}${MAGENTA} and press [Enter] to stop.${RESET}"
    echo -e "${MAGENTA}${BOLD}─────────────────────────────────────────────────────────────${RESET}"
    read -r answer
    if [[ "$answer" =~ ^[Nn]$ ]]; then
        echo ""
        echo -e "${RED}${BOLD}  Lab paused. Run the script again whenever you are ready.${RESET}"
        echo ""
        exit 0
    fi
}

# Run a command; abort the whole script if it fails
run() {
    eval "$1"
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo ""
        echo -e "${RED}${BOLD}✗  Command failed (exit code $exit_code):${RESET}  $1"
        echo -e "${RED}   Check the error above, fix the issue, and re-run the script.${RESET}"
        echo ""
        exit $exit_code
    fi
}

# ── Welcome screen ────────────────────────────────────────────────────────────
clear
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║       🐳  Spring PetClinic — Docker Lab (Ubuntu)               ║${RESET}"
echo -e "${BOLD}║       MCA DevOps Workshop                                       ║${RESET}"
echo -e "${BOLD}║                                                                 ║${RESET}"
echo -e "${BOLD}║  This script will:                                              ║${RESET}"
echo -e "${BOLD}║   1. Install Java 17, Maven, Git                               ║${RESET}"
echo -e "${BOLD}║   2. Clone Spring PetClinic                                     ║${RESET}"
echo -e "${BOLD}║   3. Build the app with Maven                                   ║${RESET}"
echo -e "${BOLD}║   4. Create a Dockerfile                                        ║${RESET}"
echo -e "${BOLD}║   5. Build and run a Docker container                           ║${RESET}"
echo -e "${BOLD}║                                                                 ║${RESET}"
echo -e "${BOLD}║  After each command you will see an explanation and be asked    ║${RESET}"
echo -e "${BOLD}║  before the script moves on.                                    ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${YELLOW}  Make sure you are running this on Ubuntu 22.04 with sudo access.${RESET}"
echo ""
proceed

# =============================================================================
# STEP 1 — Update the package list
# =============================================================================
step "STEP 1 of 11 — Update Ubuntu Package List"

cmd_info "sudo apt update"
run "sudo apt update"

explain \
"  ${BOLD}apt${RESET} is Ubuntu's package manager — the tool that installs, removes,
  and updates software on your system.

  ${BOLD}apt update${RESET} does NOT install anything. It only downloads the latest
  list of available packages from Ubuntu's servers so that subsequent
  install commands know where to find the newest versions.

  Think of it like refreshing a shopping catalogue before you order — you
  need the latest catalogue to know what is in stock."

proceed

# =============================================================================
# STEP 2 — Install Git, Java 17, Maven
# =============================================================================
step "STEP 2 of 11 — Install Git, Java 17 and Maven"

cmd_info "sudo apt install -y git openjdk-17-jdk maven curl wget unzip"
run "sudo apt install -y git openjdk-17-jdk maven curl wget unzip"

explain \
"  We just installed four key tools:

  ${BOLD}git${RESET}              — Version control. We use it to download (clone) the
                   PetClinic source code from GitHub.

  ${BOLD}openjdk-17-jdk${RESET}  — Java Development Kit 17. Spring PetClinic is a Java
                   application and needs this to compile and run.

  ${BOLD}maven${RESET}            — Apache Maven is a build tool for Java projects. It
                   reads the project's pom.xml and handles downloading
                   dependencies, compiling code, and packaging the app
                   into a runnable JAR file.

  ${BOLD}curl / wget / unzip${RESET} — Common utilities for downloading files and
                   extracting archives. Often needed during DevOps work.

  The ${BOLD}-y${RESET} flag automatically answers 'yes' to any confirmation prompts
  so the installation is fully automated."

proceed

# =============================================================================
# STEP 3 — Verify installations
# =============================================================================
step "STEP 3 of 11 — Verify All Installations"

cmd_info "java -version"
run "java -version"

explain \
"  ${BOLD}java -version${RESET} prints the version of the Java runtime that is active.
  You should see something like:
      openjdk version \"17.0.x\" ...

  If you see a different version (e.g. Java 11), it means another Java
  was already installed. We can fix that with the 'update-alternatives'
  command — ask your instructor if needed."

proceed

cmd_info "mvn -version"
run "mvn -version"

explain \
"  ${BOLD}mvn -version${RESET} confirms Maven is installed and prints its version along
  with the Java home it is using.

  It is important that Maven points to Java 17. If it shows a different
  Java path, set JAVA_HOME manually:
      export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"

proceed

cmd_info "git --version"
run "git --version"

explain \
"  ${BOLD}git --version${RESET} confirms Git is ready to use.
  Any version 2.x is perfectly fine for this lab."

proceed

# =============================================================================
# STEP 4 — Set JAVA_HOME
# =============================================================================
step "STEP 4 of 11 — Set JAVA_HOME Environment Variable"

cmd_info "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 && export PATH=\$JAVA_HOME/bin:\$PATH"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

explain \
"  ${BOLD}JAVA_HOME${RESET} is an environment variable that tells tools like Maven
  exactly where Java is installed on the system.

  Without it, Maven may pick up the wrong Java version if multiple
  versions are installed, causing confusing build errors.

  ${BOLD}export${RESET} makes the variable available not just in this terminal session
  but also to any child processes (like Maven) that this script launches.

  We also prepend \$JAVA_HOME/bin to ${BOLD}PATH${RESET} so that the 'java' command
  from JDK 17 is found first when you type java in the terminal."

proceed

# =============================================================================
# STEP 5 — Clone Spring PetClinic
# =============================================================================
step "STEP 5 of 11 — Clone Spring PetClinic from GitHub"

# Avoid re-cloning if the directory already exists
if [ -d "spring-petclinic" ]; then
    note "Directory 'spring-petclinic' already exists — skipping clone."
else
    cmd_info "git clone https://github.com/spring-projects/spring-petclinic.git"
    run "git clone https://github.com/spring-projects/spring-petclinic.git"
fi

explain \
"  ${BOLD}git clone${RESET} copies a remote repository from GitHub onto your local
  machine. It creates a folder called 'spring-petclinic' containing the
  full source code, all history, and the project configuration file
  (pom.xml).

  The URL points to the official Spring PetClinic repository — a sample
  Spring Boot web application used widely for training and demos.

  After cloning you will see:
    spring-petclinic/
    ├── pom.xml          ← Maven project descriptor
    ├── src/             ← Java source code
    └── ...              ← other project files"

proceed

cmd_info "cd spring-petclinic"
cd spring-petclinic || { echo -e "${RED}Failed to enter directory${RESET}"; exit 1; }

explain \
"  ${BOLD}cd spring-petclinic${RESET} moves us into the project directory.
  All remaining commands in this lab run from inside this folder."

proceed

# =============================================================================
# STEP 6 — Build with Maven
# =============================================================================
step "STEP 6 of 11 — Build the Application with Maven"

note "This step downloads Maven dependencies from the internet.
   The first run can take 3–5 minutes. Subsequent runs are much faster
   because dependencies are cached in ~/.m2 on your machine."

cmd_info "mvn clean package -DskipTests"
run "mvn clean package -DskipTests"

explain \
"  Maven just compiled the entire Spring PetClinic application and packaged
  it into a single runnable JAR file. Here is what each part of the
  command means:

  ${BOLD}mvn${RESET}              — Invokes Apache Maven.

  ${BOLD}clean${RESET}            — Deletes the 'target/' folder from any previous build
                   so we start with a completely fresh compile.

  ${BOLD}package${RESET}          — Compiles all Java source files, runs processors,
                   and bundles everything into a JAR (Java ARchive).

  ${BOLD}-DskipTests${RESET}      — Skips running unit tests. In a real CI pipeline we
                   would NOT skip tests, but for this lab we skip them
                   to save time.

  The output JAR is placed in the 'target/' directory. It contains the
  compiled application AND all its dependencies — making it completely
  self-contained and ready to run anywhere Java 17 is installed."

proceed

# =============================================================================
# STEP 7 — Show the JAR
# =============================================================================
step "STEP 7 of 11 — Verify the Built JAR File"

cmd_info "ls -lh target/*.jar"
run "ls -lh target/*.jar"

# Capture the JAR filename dynamically
JAR_FILE=$(ls target/*.jar 2>/dev/null | head -n 1)
JAR_NAME=$(basename "$JAR_FILE")

explain \
"  ${BOLD}ls -lh target/*.jar${RESET} lists all JAR files in the target/ directory.

  ${BOLD}-l${RESET} gives a detailed listing (permissions, size, date).
  ${BOLD}-h${RESET} shows the file size in human-readable form (e.g. 48M instead of
  48000000 bytes).

  You should see a file named something like:
      spring-petclinic-3.x.x.jar

  This is the artifact we will now containerise with Docker.
  Detected JAR: ${BOLD}${JAR_NAME}${RESET}"

proceed

# =============================================================================
# STEP 8 — Create the Dockerfile
# =============================================================================
step "STEP 8 of 11 — Create the Dockerfile"

cmd_info "Creating Dockerfile in $(pwd)"

cat > Dockerfile << 'EOF'
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY target/spring-petclinic-*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
EOF

echo -e "${CYAN}${BOLD}▶  Dockerfile contents:${RESET}"
echo ""
cat -n Dockerfile
echo ""

explain \
"  A ${BOLD}Dockerfile${RESET} is a plain-text recipe that tells Docker exactly how to
  build an image for your application. Let us go line by line:

  ${BOLD}FROM eclipse-temurin:17-jre-jammy${RESET}
      Every Docker image starts from a base image. We chose
      'eclipse-temurin:17-jre-jammy' which is an official Ubuntu 22.04
      (Jammy) image with Java 17 JRE pre-installed. Using JRE (not JDK)
      keeps the image smaller — we do not need compilation tools at
      runtime.

  ${BOLD}WORKDIR /app${RESET}
      Creates and sets /app as the working directory inside the container.
      All subsequent COPY and CMD instructions are relative to this path.

  ${BOLD}COPY target/spring-petclinic-*.jar app.jar${RESET}
      Copies the JAR we just built into the container image, renaming it
      'app.jar'. The wildcard * means the exact version number does not
      matter — it always picks up whatever JAR is in target/.

  ${BOLD}EXPOSE 8080${RESET}
      Documents that the application listens on port 8080. This does NOT
      automatically publish the port — that happens when we run the
      container with -p.

  ${BOLD}CMD [\"java\", \"-jar\", \"app.jar\"]${RESET}
      The default command to run when the container starts. This launches
      the Spring Boot application using the Java runtime."

proceed

# =============================================================================
# STEP 9 — Check / Install Docker
# =============================================================================
step "STEP 9 of 11 — Check Docker Installation"

if command -v docker &> /dev/null; then
    cmd_info "docker --version"
    run "docker --version"
    explain \
"  Docker is already installed on this machine. ✓

  ${BOLD}Docker${RESET} is a platform for packaging applications into lightweight,
  portable containers. A container bundles your app together with
  everything it needs to run (runtime, libraries, config) so it behaves
  identically on any machine that has Docker installed."
else
    note "Docker not found. Installing Docker CE now — this may take a minute."

    cmd_info "Installing Docker CE via official apt repository"
    run "sudo apt install -y ca-certificates curl gnupg"
    run "sudo install -m 0755 -d /etc/apt/keyrings"
    run "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
    run "sudo chmod a+r /etc/apt/keyrings/docker.gpg"
    run "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(. /etc/os-release && echo \"\$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
    run "sudo apt update"
    run "sudo apt install -y docker-ce docker-ce-cli containerd.io"
    run "sudo usermod -aG docker \$USER"
    run "sudo chmod 666 /var/run/docker.sock"

    explain \
"  Docker has now been installed from Docker's official apt repository.
  Here is what we did:

  1. Added Docker's GPG key so apt can verify package authenticity.
  2. Added Docker's official apt repository to your package sources.
  3. Installed docker-ce (Community Edition), the CLI, and containerd
     (the low-level container runtime Docker uses under the hood).
  4. Added your user to the 'docker' group so you can run Docker commands
     without sudo in future sessions.
  5. Fixed socket permissions for this current session."
fi

proceed

# =============================================================================
# STEP 10 — Build the Docker image
# =============================================================================
step "STEP 10 of 11 — Build the Docker Image"

cmd_info "docker build -t petclinic-app ."
run "docker build -t petclinic-app ."

explain \
"  ${BOLD}docker build${RESET} reads the Dockerfile in the current directory and
  constructs a layered image from it.

  ${BOLD}-t petclinic-app${RESET}
      Tags the resulting image with the name 'petclinic-app'. Tags are
      how you refer to images when running or sharing them. Without a tag
      you would have to use the image's SHA256 hash (ugly and error-prone).

  ${BOLD}.${RESET} (dot)
      Specifies the build context — the folder Docker sends to the build
      engine. It must contain both the Dockerfile and the target/ folder
      with the JAR. Using '.' means the current directory.

  Docker builds images in ${BOLD}layers${RESET}. Each instruction in the Dockerfile
  creates a new read-only layer. Layers are cached, so if you rebuild
  after only changing your JAR, Docker reuses the cached FROM and WORKDIR
  layers and only re-runs the COPY and CMD layers — making rebuilds fast.

  Run ${BOLD}docker images${RESET} to see the image we just created listed locally."

cmd_info "docker images petclinic-app"
run "docker images petclinic-app"

proceed

# =============================================================================
# STEP 11 — Run the container
# =============================================================================
step "STEP 11 of 11 — Run the PetClinic Container"

# Remove any existing container with the same name to avoid conflicts
if docker ps -a --format '{{.Names}}' | grep -q '^petclinic$'; then
    note "A container named 'petclinic' already exists — removing it first."
    run "docker rm -f petclinic"
fi

cmd_info "docker run -d -p 8080:8080 --name petclinic petclinic-app"
run "docker run -d -p 8080:8080 --name petclinic petclinic-app"

explain \
"  ${BOLD}docker run${RESET} creates and starts a new container from our image.

  ${BOLD}-d${RESET} (detached)
      Runs the container in the background. Without -d the terminal would
      be locked showing container logs until you press Ctrl+C.

  ${BOLD}-p 8080:8080${RESET} (port mapping)
      Maps port 8080 on your host machine to port 8080 inside the
      container. Format is host_port:container_port.
      Without this flag, the app runs inside the container but is
      completely unreachable from your browser.

  ${BOLD}--name petclinic${RESET}
      Gives the container a human-readable name. You can then use
      'docker stop petclinic' or 'docker logs petclinic' instead of
      having to type a random container ID like d3f1a29bc...

  ${BOLD}petclinic-app${RESET}
      The name of the image to instantiate as a container."

proceed

# ── Wait for the app to start ─────────────────────────────────────────────────
step "Waiting for Spring Boot to start..."

echo -e "${CYAN}  Checking container logs — waiting for 'Started PetClinicApplication'...${RESET}"
echo ""

MAX_WAIT=120
ELAPSED=0
while [ $ELAPSED -lt $MAX_WAIT ]; do
    if docker logs petclinic 2>&1 | grep -q "Started PetClinicApplication"; then
        echo -e "${GREEN}${BOLD}  ✓  Application is up!${RESET}"
        break
    fi
    printf "."
    sleep 3
    ELAPSED=$((ELAPSED + 3))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
    echo ""
    note "App did not start within ${MAX_WAIT}s. Check logs: docker logs petclinic"
fi

echo ""
cmd_info "docker logs petclinic --tail 20"
docker logs petclinic --tail 20

explain \
"  ${BOLD}docker logs petclinic${RESET} streams the console output (stdout/stderr)
  of the running container — the same output you would see if you ran
  the application directly in a terminal.

  ${BOLD}--tail 20${RESET} shows only the last 20 lines, which is enough to confirm
  the app started successfully. Look for:
      Started PetClinicApplication in X.XXX seconds

  Spring Boot applications can take 10–30 seconds to start because they
  initialise an embedded Tomcat server, set up the database connection,
  and load all Spring components before accepting requests."

proceed

# ── Quick curl test ───────────────────────────────────────────────────────────
step "Quick Smoke Test — curl localhost:8080"

cmd_info "curl -s -o /dev/null -w 'HTTP Status: %{http_code}' http://localhost:8080"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
echo -e "${BOLD}  HTTP Status: ${HTTP_STATUS}${RESET}"
echo ""

if [ "$HTTP_STATUS" == "200" ]; then
    echo -e "${GREEN}${BOLD}  ✓  App is responding correctly (HTTP 200 OK)!${RESET}"
else
    note "Got HTTP ${HTTP_STATUS} — the app may still be starting. Try again in 10 seconds."
fi

explain \
"  ${BOLD}curl${RESET} is a command-line tool for making HTTP requests.

  ${BOLD}-s${RESET}             — Silent mode: suppresses the progress bar.
  ${BOLD}-o /dev/null${RESET}   — Discards the response body (we only care about the code).
  ${BOLD}-w '%{http_code}'${RESET} — Prints just the HTTP status code.

  An HTTP ${BOLD}200${RESET} means the server received and handled the request
  successfully — the application is alive and serving traffic.

  To see the full response (the HTML page), run:
      curl http://localhost:8080"

proceed

# =============================================================================
#  FINAL SUMMARY
# =============================================================================
clear
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║                                                                  ║${RESET}"
echo -e "${GREEN}${BOLD}║   🎉  Lab Complete!  Spring PetClinic is running in Docker!      ║${RESET}"
echo -e "${GREEN}${BOLD}║                                                                  ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${BOLD}  What you accomplished:${RESET}"
echo ""
echo -e "  ${GREEN}✓${RESET}  Updated Ubuntu packages                   (apt update)"
echo -e "  ${GREEN}✓${RESET}  Installed Java 17, Maven, Git             (apt install)"
echo -e "  ${GREEN}✓${RESET}  Cloned Spring PetClinic                   (git clone)"
echo -e "  ${GREEN}✓${RESET}  Compiled and packaged the app             (mvn clean package)"
echo -e "  ${GREEN}✓${RESET}  Wrote a Dockerfile                        (eclipse-temurin base)"
echo -e "  ${GREEN}✓${RESET}  Built a Docker image                      (docker build)"
echo -e "  ${GREEN}✓${RESET}  Ran the app as a container                (docker run)"
echo -e "  ${GREEN}✓${RESET}  Verified the app is live                  (curl / browser)"
echo ""
echo -e "${BOLD}  Access the app:${RESET}"
echo ""
echo -e "  Browser  →  ${CYAN}http://localhost:8080${RESET}"
HOST_IP=$(hostname -I | awk '{print $1}')
echo -e "  Network  →  ${CYAN}http://${HOST_IP}:8080${RESET}"
echo ""
echo -e "${BOLD}  Useful Docker commands to explore:${RESET}"
echo ""
echo -e "  ${CYAN}docker ps${RESET}                    — list running containers"
echo -e "  ${CYAN}docker logs petclinic${RESET}         — view app logs"
echo -e "  ${CYAN}docker exec -it petclinic bash${RESET} — shell into the container"
echo -e "  ${CYAN}docker stop petclinic${RESET}         — stop the app"
echo -e "  ${CYAN}docker rm petclinic${RESET}           — delete the container"
echo -e "  ${CYAN}docker rmi petclinic-app${RESET}      — delete the image"
echo -e "  ${CYAN}docker system prune -f${RESET}        — clean up everything unused"
echo ""
echo -e "${YELLOW}${BOLD}  Next up:  Automate this entire flow with Ansible across two nodes!${RESET}"
echo ""
