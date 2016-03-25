# Jenkins

This is a prototype for making jenkins work in docker container.

# What is this
This image is suppose to be run anywhere with all the necessary plugins installed (github & ghprb) as a jenkins master.
Since it does not have any built-in build environment, it only distributes jobs to the slaves using ssh.

# How to configure ghprb with webhook
It is kind of tricky to set this up and only limited or outdated documentations could be found. The goal is to set up a
jenkins cluster which used github webhook to receive events & do build on pull requests. Following are the set up steps:
1. Go to github repo and set up a webhook with pull request and issue comment. The webhook url should be something like
http://\<jenkins-server-url\>:\<jenkins-server-port\>/ghprbhook/

2. Go to github: `settings -> personal access token -> generate new token` and then check `repo admin:org admin:public_key admin:repo_hook`

3. Go to jenkins: `Manage Jenkins -> GitHub Plugin Configuration -> Manage hooks -> Credentials -> add personal access token`

4. On the same page: `GitHub Pull Request Builder -> Credentials -> use token or user & passwd`

5. Create a FreeStyle job.

6. On job configuration page fill in the following:
   - GitHub project (e.g. https://github.com/Pendoragon/jenkins)
   - SCM: Repo URL, Credential, Name, Refspec(+refs/pull/\*:refs/remotes/origin/pr/\*), Branch Specifier(${sha1})
   - Build Triggers: Use github hooks for build triggering, Only use trigger phrase for build triggering.
*Note: Be careful about admin list. If you ever set one admin, then only that guy has the permission to trigger builds.*

7. Set the rest.

# Pitfalls on Jenkins ssh slaves
If you are using ssh to launch jenkins slaves, then there's one thing you need to pay attention. `~/.bashrc` will just return at the very beginning if it is a non-interactive shell. So if you are trying to source it to have some environment variables set, you will have to place them at the VERY BEGINNING or else it would not get set.

