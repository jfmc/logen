:- bundle(logen).
version('1.0').
depends([core]).
alias_paths([
    logen = '.'
]).
lib('.'). % TODO: '.' is not a good idea
cmd('logen', [main='ciao_entry']).
