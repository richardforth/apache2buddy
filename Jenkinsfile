pipeline { 
    agent { label 'docker' }
    
    stages { 
        stage('Docker CentOS7 Staging') { 
            agent { 
                docker {
                    image 'forric/centos7:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Scientific7 Staging') { 
            agent { 
                docker {
                    image 'forric/scientific7:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker CentOS8 Staging') { 
            agent { 
                docker {
                    image 'forric/centos8:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker RockyLinux8 Staging') { 
            agent { 
                docker {
                    image 'forric/rockylinux8:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
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
                sh '/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Debian9 Staging') { 
            agent { 
                docker {
                    image 'forric/debian9:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Debian10 Staging') { 
            agent { 
                docker {
                    image 'forric/debian10:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
        stage('Docker Ubuntu1804 Staging') { 
            agent { 
                docker {
                    image 'forric/ubuntu1804:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
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
                sh 'service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n'
            }
        }
    } 
}
