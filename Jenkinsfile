pipeline { 
    agent none
    // Pre-Seed tzdata for php install on the ubuntu docker containers
    environment {
        DEBIAN_FRONTEND = 'noninteractive'
        TZ = 'Europe/London'
    }    
    // We skip the default checkout SCM as we are running the tests in docker containers.
    // We only want to keep the last 3 builds on the Jenkins Controller to save diskspace.
    options {
      skipDefaultCheckout true
      buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '3')
    }    
 
    stages {
        stage('Mandatory 2min Sleep') {
            steps {
                echo 'Sleeping for 2 minutes...'
                sleep time: 2, unit: 'MINUTES'
            }
        }
        stage('Docker BitnamiApache Staging') { 
            agent { 
                docker {
                    image 'forric/bitnamiapache:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
                script {
                    sh 'install_packages php'
                    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/opt/bitnami/apache/bin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
                    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "installing iproute2 which contains ss..."'
		    sh 'install_packages iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/opt/bitnami/apache/bin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
                    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
            }
	}
        stage('Docker OracleLinux8 Staging') { 
            agent { 
                docker {
                    image 'forric/oraclelinux8:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
	        script {
                    sh 'yum -y install hostname'
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Oracle Linux defaults to ss"'
		    sh 'echo "Checking with  ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
                    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Removing iproute which contained ss command"'
                    sh 'yum -y remove iproute'
		    sh 'echo "installing net-tools" which includes netstat'
                    sh 'yum -y install net-tools'
		    sh 'echo "Testing with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
                    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
            }
	}
        stage('Docker OracleLinux9 Staging') { 
            agent { 
                docker {
                    image 'forric/oraclelinux9:latest'
                    args '-u root:root --cap-add SYS_PTRACE'
                    reuseNode true
                } 
            }
            steps {
	        script {
                    sh 'yum -y install hostname'
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Oracle Linux defaults to ss"'
		    sh 'echo "Checking with  ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
                    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Removing iproute which contained ss command"'
                    sh 'yum -y remove iproute'
		    sh 'echo "installing net-tools" which includes netstat'
                    sh 'yum -y install net-tools'
		    sh 'echo "Testing with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
                    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }    
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux-8'
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux-9'
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'yum -y install php'
		    sh 'php -v'
                    sh 'sed -i \'s/^LoadModule mpm_event_module/#LoadModule mpm_event_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'sed -i \'s/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/\' /etc/httpd/conf.modules.d/00-mpm.conf'
		    sh 'apachectl configtest'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute which contains ss command"'
		    sh 'yum -y install iproute'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "/usr/sbin/httpd -k start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'apt-get update'
                    sh 'apt -y install php'
		    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute2 which contains ss command"'
                    sh 'apt -y install iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'apt-get update'
                    sh 'apt -y install php'
		    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute2 which contains ss command"'
                    sh 'apt -y install iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'apt-get update'
                    sh 'apt -y install php'
		    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute2 which contains ss command"'
                    sh 'apt -y install iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'apt-get update'
                    sh 'apt -y install php'
		    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute2 which contains ss command"'
                    sh 'apt -y install iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
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
	        script {
                    sh 'apt-get update'
                    sh 'apt -y install php'
		    sh 'php -v'
		    sh 'cat /etc/os-release'
		    sh 'echo "Checking with netstat..."'
                    def output_netstat = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_netstat}"
		    if (!output_netstat.contains("[ OK ] Using 'netstat' for socket statistics.")) {
                        error "Output validation failed"
                    }
		    sh 'echo "Installing iproute2 which contains ss command"'
                    sh 'apt -y install iproute2'
		    sh 'echo "Checking with ss..."'
                    def output_ss = sh(script: "service apache2 start && curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/staging/apache2buddy.pl | perl - -n", returnStdout: true).trim()
		    echo "Command output:\n${output_ss}"
		    if (!output_ss.contains("[ OK ] Using 'ss' for socket statistics.")) {
                        error "Output validation failed"
                    }
                }
            }
        } 
    }
}