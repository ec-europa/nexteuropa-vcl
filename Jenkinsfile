node('master') {
  checkout scm
  stage('Validate VCL') {
    sh 'varnishd -C -f nexteuropa.vcl -n /tmp'
  }
  stage('Deploy configuration') {
    if( env.BRANCH_NAME != 'acceptance' ) {
      input('Proceed with deployment to ' + env.BRANCH_NAME + '?')
    }
    sh 'git remote | grep -q ^deploy$ || git remote add deploy git@' + env.DEPLOY_SERVER + ':nexteuropa-vcl/' + env.BRANCH_NAME + '.git'
    sh 'git fetch deploy master'
    sh 'git push deploy HEAD:master'
  }
}
