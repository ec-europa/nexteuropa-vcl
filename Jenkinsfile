node('master') {
  checkout scm
  stage('Test VCL') {
    sh '[ -L nexteuropa ] || ln -s . nexteuropa'
    sh 'varnishtest -v -p vcl_dir=$(pwd) test/*.vtc'
    sh 'rm nexteuropa'
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
