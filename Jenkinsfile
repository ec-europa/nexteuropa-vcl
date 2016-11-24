node('master') {
  checkout scm
  if( env.BRANCH_NAME != 'acceptance' ) {
    input('Proceed with deployment to ' + env.BRANCH_NAME + '?')
  }
  stage('Deploy configuration') {
    sh 'git remote | grep -q ^deploy$ || git remote add deploy git@' + env.DEPLOY_SERVER + ':nexteuropa-vcl/' + env.BRANCH_NAME + '.git'
    sh 'git push deploy ' + env.BRANCH_NAME + ':master'
  }
}
