## General 
# goto the development base folder
alias gdev='cd ~/Work/pf/dev'
# run docker compose
alias dc='docker compose'
alias docker-compose='docker compose'
# run pnpm
alias pn='pnpm'
# Show ~/.bash_aliases definition, call 'ali' for a simpler version
alias sa='cat ~/.bash_aliases'
# Show functions defined in ~/.bash_func
alias sf='cat ~/.bash_func'
# Show ~/.bashrc definition
alias sb='cat ~/.bashrc'
alias le='idea -e'
# open files
alias files='nautilus'

## DoD
# goto DoD project
alias gdod='cd; cd Private/dod/'
# execute dod command
alias dod='gdod; ./dod.sh'

alias redo_db='gradle clean liquibaseDiffChangeLog'
alias build_backend='gdod; gradle clean :b:build :b:jDB -x test -x asciidoctor'
alias test_backend='build_backend; gradle :b:test jacocoTestCoverageVerification -DincludeTests="any()" -DexcludeTests="none()"'
alias test_backend_quick='gradle :b:test jacocoTestCoverageVerification'
alias test_integration='gdod; gradle :b:test -DincludeTests="integration" -DexcludeTests="all()"'
alias run_backend='gdod && dc stop api && dc rm -f api && dc up -d api && dc logs -f'
alias redo_backend='redo_db && build_backend && run_backend'

## PF
### docs
# goto docs base folder
alias gdoc='cd ~/Desktop/CO+/docs'
# goto pant docs
alias gdpant='gdoc; cd pant'
# goto opsigelses docs
alias gdcan='gdoc; cd opsigelse'

### Projects
# goto the source checkout folder
alias gsrc='cd ~/source'
# goto the wip source
alias gwip='gsrc; cd wip'
# goto the release source
alias grel='gsrc; cd release'
# goto the cancellation project
alias gcan='gwip; cd cancellation'
# goto the claim-history project
alias gskh='gwip; cd claim-history'
# goto the connectorplus core project
alias gcore='gwip; cd connectorplus-core'
# goto the common-lib project
alias glcom='gwip; cd lib-common'
# goto the unified dev project
alias gud='gdev; cd cpl-dev'
# goto PRs
alias gpr='gsrc; cd PR'
# goto scripts folder
alias gsp='gdev; cd scripts'
# goto sync folder
alias gsync='gsrc; cd sync'

alias sjr='jrnl -on today'
alias drm='docker rm $(docker stop $(docker ps -qa))'
alias vpn='gdev; cd scripts/; ./vpn.sh'
# Call the Co+ dev script, call 'cpl' for more info
alias cpl='gud; ./cp.sh'

## Shortcuts
# goto current project
alias gpro='cd $CURRENT_PROJECT'

## Watson Command aliases
# aliases for Watson https://github.com/jazzband/Watson
alias wat='watson'
# Show Watson status and when last task ended
alias wstatus='wat status; wl=$(watson log -Gd | tail -n 1 | cut -d " " -f 5); echo "Previous task ended: ${wl}"'
# Show Watson log
alias wlog='wat log -Gc'
# Start Watson project, stop running Watson project first
alias wstart='wat stop; wat start'
# Get now as Watson time
alias wnow='date "+%Y-%m-%d %H:%M:%S"'
# Get now as Watson time
alias wday='date "+%Y-%m-%d"'
# Show watson today aggregated
alias wtoday='watson aggregate --from $(wday) --to $(wday) -Gc'

## Git aliases
# Show the most used git commands
alias fqgit='history | cut -c 8- | grep git | sort | uniq -c  | sort -n -r | head -n 10'
# Git log
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
# Git log with a graph 
alias glg='glog --graph'
# Git pull
alias gp='git pull'
# Git commit work in progress
alias gcwip='git commit -am"WIP"'

## Util scripts
# Update stuff software
alias update='update.sh'
# Guess Base Branch
alias gbb='guess-base-branch.sh'
