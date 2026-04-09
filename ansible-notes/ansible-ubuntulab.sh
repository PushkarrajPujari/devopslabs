#!/bin/bash

clear

pause() {
  echo ""
  read -p "👉 Press ENTER to continue..." temp
}

section() {
  echo ""
  echo "=============================================="
  echo "$1"
  echo "=============================================="
}

step() {
  echo ""
  echo "➡️  $1"
}

run_cmd() {
  echo ""
  echo "💻 Command:"
  echo "----------------------------------------------"
  echo "$1"
  echo "----------------------------------------------"
  read -p "👉 Press ENTER to execute..." temp

  echo ""
  echo "📤 Output:"
  echo "----------------------------------------------"
  eval "$1"
  echo "----------------------------------------------"

  echo ""
  echo "📘 Explanation:"
  echo "$2"
  echo "----------------------------------------------"

  pause
}

section "🛠️ Ansible Interactive Lab (Ubuntu - Single Node)"

echo "Welcome! This is a guided Ansible tutorial."
echo "You will SEE → RUN → UNDERSTAND each step."
pause

# STEP 1
section "🔧 Step 1: Install Ansible"

run_cmd "sudo apt update -y" \
"Updates package list from Ubuntu repositories so we get latest versions."

run_cmd "sudo apt install -y ansible" \
"Installs Ansible automation tool. '-y' auto-confirms installation."

run_cmd "ansible --version" \
"Shows installed version and confirms Ansible is working."

# STEP 2
section "📁 Step 2: Inventory Setup"

step "Creating inventory file for localhost"

echo ""
echo "💻 Command:"
echo "----------------------------------------------"
echo "cat <<EOF > hosts
[local]
localhost ansible_connection=local
EOF"
echo "----------------------------------------------"
read -p "👉 Press ENTER to execute..." temp

cat <<EOF > hosts
[local]
localhost ansible_connection=local
EOF

echo ""
echo "📄 Output:"
cat hosts

echo ""
echo "📘 Explanation:"
echo "Inventory defines target systems. Here we use localhost."
echo "'ansible_connection=local' means no SSH, run locally."
pause

# LAB 1
section "⚡ Lab 1: Ad-Hoc Commands"

run_cmd "ansible -i hosts local -m ping" \
"Tests connectivity using Ansible ping module (not ICMP)."

run_cmd "ansible -i hosts local -m shell -a \"uptime\"" \
"Runs shell command 'uptime' on target."

run_cmd "ansible -i hosts local -m shell -a \"df -h\"" \
"Shows disk usage in human-readable format."

run_cmd "ansible -i hosts local -m file -a \"path=/tmp/mca.txt state=touch\"" \
"Creates a file using file module."

run_cmd "ls -l /tmp/mca.txt" \
"Verifies that the file was created."

# PACKAGE
section "📦 Install Package"

run_cmd "ansible -i hosts local -m apt -a \"name=tree state=present update_cache=yes\" --become" \
"Installs 'tree' package using apt module with sudo privileges."

# LAB 2
section "📜 Lab 2: Playbook"

step "Creating playbook file"

echo ""
echo "💻 Command:"
echo "----------------------------------------------"
echo "cat <<EOF > mca_demo.yml
- name: MCA Ansible Playbook Demo (Localhost)
  hosts: local
  become: yes

  tasks:
    - name: Create a welcome file
      copy:
        content: \"Welcome MCA Students to Ansible Lab!\n\"
        dest: /tmp/welcome.txt

    - name: Ensure directory exists
      file:
        path: /opt/mca-lab
        state: directory

    - name: Install tree
      apt:
        name: tree
        state: present
        update_cache: yes
EOF"
echo "----------------------------------------------"
read -p "👉 Press ENTER to execute..." temp

cat <<EOF > mca_demo.yml
- name: MCA Ansible Playbook Demo (Localhost)
  hosts: local
  become: yes

  tasks:
    - name: Create a welcome file
      copy:
        content: "Welcome MCA Students to Ansible Lab!\n"
        dest: /tmp/welcome.txt

    - name: Ensure directory exists
      file:
        path: /opt/mca-lab
        state: directory

    - name: Install tree
      apt:
        name: tree
        state: present
        update_cache: yes
EOF

echo ""
echo "📄 Output:"
cat mca_demo.yml

echo ""
echo "📘 Detailed Playbook Explanation:"
echo ""
echo "- name: MCA Ansible Playbook Demo (Localhost)"
echo "  👉 This is the name of the play. Used for readability in output."
echo ""
echo "hosts: local"
echo "  👉 Defines which group from inventory to run on."
echo ""
echo "become: yes"
echo "  👉 Enables sudo/root privileges for all tasks."
echo ""
echo "tasks:"
echo "  👉 List of actions to perform."
echo ""
echo "  - name: Create a welcome file"
echo "    👉 Task description."
echo "    copy:"
echo "      👉 Module used to copy/create file."
echo "      content:"
echo "        👉 Inline content to write into file."
echo "      dest:"
echo "        👉 Destination path."
echo ""
echo "  - name: Ensure directory exists"
echo "    file:"
echo "      path:"
echo "        👉 Directory location."
echo "      state: directory"
echo "        👉 Ensures directory exists."
echo ""
echo "  - name: Install tree"
echo "    apt:"
echo "      name:"
echo "        👉 Package name."
echo "      state: present"
echo "        👉 Ensures it is installed."
echo "      update_cache: yes"
echo "        👉 Updates package list before install."
echo ""
echo "👉 IMPORTANT: Playbooks are declarative, not procedural."
echo "   You define WHAT state you want, not HOW to do it."
pause

# RUN PLAYBOOK
run_cmd "ansible-playbook -i hosts mca_demo.yml" \
"Executes the playbook. Tasks run sequentially and ensure desired state."

# VERIFY
section "✅ Verification"

run_cmd "cat /tmp/welcome.txt" \
"Verifies file content."

run_cmd "ls -ld /opt/mca-lab" \
"Checks directory creation."

run_cmd "tree /opt || echo 'tree not installed'" \
"Displays directory structure."

# IDEMPOTENCY
section "🧪 Idempotency"

run_cmd "ansible-playbook -i hosts mca_demo.yml" \
"Second run should show no changes. This proves idempotency."

# END
section "🎉 Lab Completed"

echo "✔ You understood Ansible basics"
echo "✔ You learned playbook structure deeply"
echo "✔ You executed real automation"

echo ""
echo "🚀 You are now ready for advanced DevOps concepts!"
