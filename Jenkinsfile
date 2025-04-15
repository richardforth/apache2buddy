pipeline { 
    agent none
    
    // We skip the default checkout SCM as we are running the tests in docker containers.
    // We only want to keep the last 3 builds on the Jenkins Controller to save diskspace.
    options {
      skipDefaultCheckout true
      buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '3')
    }    
 
    stages { 
        stage('Docker RockyLinux8 Staging') { 
            agent { 
                docker {
                    image 'forric/rockylinux8:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker RockyLinux9 Staging') { 
            agent { 
                docker {
                    image 'forric/rockylinux9:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker AlmaLinux8 Staging') { 
            agent { 
                docker {
                    image 'forric/almalinux8:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux-8'
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker AlmaLinux9 Staging') { 
            agent { 
                docker {
                    image 'forric/almalinux9:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux-8'
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker AmazonLinux 2 Staging') { 
            agent { 
                docker {
                    image 'forric/amazonlinux2:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker AmazonLinux 2023 Staging') { 
            agent { 
                docker {
                    image 'forric/amazonlinux2023:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'yum -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'source apache2buddy/a2bchk.sh'
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Ubuntu2004 Staging') { 
            agent { 
                docker {
                    image 'forric/ubuntu2004:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'apt-get update'
                sh 'apt -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'bash -c "source apache2buddy/a2bchk.sh"'
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Ubuntu2204 Staging') { 
            agent { 
                docker {
                    image 'forric/ubuntu2204:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'apt-get update'
                sh 'apt -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'bash -c "source apache2buddy/a2bchk.sh"'
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Ubuntu2404 Staging') { 
            agent { 
                docker {
                    image 'forric/ubuntu2404:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'apt-get update'
                sh 'apt -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'bash -c "source apache2buddy/a2bchk.sh"'
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Debian 12 Staging') { 
            agent { 
                docker {
                    image 'forric/debian12:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'apt-get update'
                sh 'apt -y install git'
                sh 'rm -rf apache2buddy'
                sh 'git clone  http://github.com/richardforth/apache2buddy.git'
                sh 'bash -c "source apache2buddy/a2bchk.sh"'
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
    } 
}
