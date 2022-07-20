def podTemplate = """
apiVersion: v1
kind: Pod
metadata:
labels:
  jenkins/jenkins-jenkins-agent: "true"
  jenkins/label: "jenkins-jenkins-agent"
spec:
  securityContext:
    fsGroup: 1950    # Group ID of docker group on k8s nodes.
  serviceAccountName: jenkins
  containers:
  - name: build
    image: human537/inbound-agent:v1
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
    - mountPath: /var/run/docker.sock
      name: docker-sock
      readOnly: true
    workingDir: "/home/jenkins/agent"
  nodeSelector:
    kubernetes.io/os: "linux"
  restartPolicy: "Never"
  volumes:
  - emptyDir:
      medium: ""
    name: "workspace-volume"
  - name: docker-sock
    hostPath:
      path: "/var/run/docker.sock"
"""

pipeline {
    agent {
        kubernetes {
/*          label 'sample-app' */
          yaml podTemplate
          defaultContainer 'jnlp'
        }
    }
    environment {
        DOCKER_IMAGE_NAME = "human537/cicdtest"
    }
    stages {
        stage('Build') {
            steps {
                container('build') {
                  sh """
                    echo 'Running build automation'
                  """
                }
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {    
                /*
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                } 
                */
            echo 'Running Build Docker Image'
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {     
                /*
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                } 
                */
            echo 'Running Push Docker Image'                
            }
        }                
        stage('DeployToProduction') {
            when {
                branch 'master'
            }
            steps {                
                withKubeConfig([credentialsId: 'kubeconfig']) {
                  container('jnlp') {
                      sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'
                      sh 'chmod u+x ./kubectl'
                      sh './kubectl apply -f nginx-kube.yaml -n default'
                  }
                }                
            }
        }
    }
}
