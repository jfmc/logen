:- module(_, [], [ciaobld(bundlehooks)]).

:- doc(title,  "Bundle Hooks for Logen").

'$builder_hook'(desc_name('Logen')).

% ============================================================================

:- use_module(ciaobld(ciaoc_aux), [build_libs/2]).

'$builder_hook'(build_libraries) :-
	build_libs(logen, '.').

'$builder_hook'(build_bin) :-
	bundleitem_do(logencl, logen, build_nodocs).

% TODO: just say cmd('cmds/logencl', [...])
'$builder_hook'(logencl:item_def( 
    cmds_list(logen, bundle_src(logen), [
        'ciao_entry'-[
          output='logen', % (executable will be called 'logen')
	  plexe,
	  final_ciaoc
	]
    ]))).

'$builder_hook'(install) :- bundleitem_do(only_global_ins(~logen_desc), logen, install).

'$builder_hook'(uninstall) :- bundleitem_do(only_global_ins(~logen_desc), logen, uninstall).

logen_desc := [
  logencl,
  lib(logen, '.')
].
