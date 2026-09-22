" vim syntax file
" Language:	Varnish and Vinyl Cache Configuration Language
" Maintainer:	Federico G. Schwindt <fgsch@lodoss.net>
" Last Change:	2026 Sep 22
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn include @C syntax/c.vim
syn include syntax/html.vim

syn region  vclBlock		start="{" end="}"
	\ transparent contains=ALLBUT,vclKeywordTop fold
syn match   vclComment		"#.*$"
syn match   vclComment		"//.*$"
syn region  vclComment		start="/\*" end="\*/" fold
syn keyword vclConditional	elif else elseif elsif if contained
syn keyword vclConstant		true false now contained
syn region  vclInlineC		start="C{" end="}C" contains=@C keepend fold
syn region  vclString		start='"' end='"'
syn region  vclString		start='{"' end='"}' contains=@htmlTop
syn region  vclString		start='"""' end='"""' contains=@htmlTop

" Contextual grammar identifiers.
syn keyword vclContext		as from glob none None default log fold pedantic table report
syn match   vclContext		"\.\zs\(url\|request\|expected_response\|timeout\|interval\|window\|threshold\|initial\|expect_close\|host\|port\|path\|host_header\|connect_timeout\|first_byte_timeout\|between_bytes_timeout\|probe\|max_connections\|proxy_header\|preamble\|via\|authority\|wait_timeout\|wait_limit\)\>"
" Built-in subroutine names from vcl_step.rst and bin/vinyld/builtin.vcl.
syn keyword vclSubroutine	vcl_recv vcl_pipe vcl_pass vcl_hash vcl_purge vcl_hit vcl_miss vcl_deliver vcl_synth
	\ vcl_backend_fetch vcl_backend_refresh vcl_backend_response vcl_backend_error vcl_init vcl_fini
	\ vcl_builtin_recv vcl_builtin_pipe vcl_builtin_pass vcl_builtin_hash vcl_builtin_purge vcl_builtin_hit vcl_builtin_miss vcl_builtin_deliver vcl_builtin_synth
	\ vcl_builtin_backend_fetch vcl_builtin_backend_refresh vcl_builtin_backend_response vcl_builtin_backend_error
	\ vcl_req_host vcl_req_url vcl_req_method vcl_req_authorization vcl_req_cookie vcl_req_range vcl_refresh_valid vcl_refresh_conditions vcl_refresh_status
	\ vcl_beresp_stale vcl_beresp_cookie vcl_beresp_control vcl_beresp_vary vcl_beresp_http10 vcl_beresp_range vcl_beresp_hitmiss

" == Current ============================================================
" Top-level keywords (only valid outside of blocks, hence not 'contained'
" and excluded from vclBlock above via contains=ALLBUT,vclKeywordTop).
syn keyword vclKeywordTop	acl backend import probe sub unused vcl

" Keywords and built-in functions.
syn keyword vclKeyword		include
syn keyword vclKeyword		ban call hash_data new regsub regsuball return set unset contained

" VCL variables.
" Generated from the Vinyl Cache source at revision
" 655c988a2f079ee458bc64f55f4548862946fe3d:
" https://code.vinyl-cache.org/vinyl-cache/vinyl-cache/-/blob/655c988a2f079ee458bc64f55f4548862946fe3d/doc/sphinx/reference/vcl_var.rst
" Run from the source repository root:
"   grep -E '^[a-z][*.0-9<>A-Z_a-z]+($|\s+``VCL)' doc/sphinx/reference/vcl_var.rst | cut -f1 | sort -u
syn match   vclVariable		"\v<(bereq\.backend|bereq\.between_bytes_timeout|bereq\.body|bereq\.connect_timeout|bereq\.filters|bereq\.first_byte_timeout|bereq\.hash|bereq\.http\.[-0-9A-Z_a-z]+|bereq\.is_bgfetch|bereq\.is_hitmiss|bereq\.is_hitpass|bereq\.method|bereq\.proto|bereq\.retries|bereq\.retry_connect|bereq\.task_deadline|bereq\.time|bereq\.trace|bereq\.uncacheable|bereq\.url|bereq\.xid|bereq)>" contained
syn match   vclVariable		"\v<(beresp\.age|beresp\.backend\.ip|beresp\.backend\.name|beresp\.backend|beresp\.body|beresp\.do_esi|beresp\.do_gunzip|beresp\.do_gzip|beresp\.do_stream|beresp\.esi_disable_xml_check|beresp\.esi_ignore_https|beresp\.esi_ignore_other_elements|beresp\.esi_remove_bom|beresp\.filters|beresp\.grace|beresp\.http\.[-0-9A-Z_a-z]+|beresp\.keep|beresp\.proto|beresp\.reason|beresp\.status|beresp\.storage|beresp\.time|beresp\.transit_buffer|beresp\.ttl|beresp\.uncacheable|beresp\.was_304|beresp)>" contained
syn match   vclVariable		"\v<(client\.identity|client\.ip)>" contained
syn match   vclVariable		"\v<(local\.endpoint|local\.ip|local\.socket)>" contained
syn match   vclVariable		"\v<(obj\.age|obj\.can_esi|obj\.grace|obj\.hits|obj\.http\.[-0-9A-Z_a-z]+|obj\.keep|obj\.proto|obj\.reason|obj\.status|obj\.storage|obj\.time|obj\.ttl|obj\.uncacheable|obj)>" contained
syn match   vclVariable		"\v<(obj_stale\.age|obj_stale\.can_esi|obj_stale\.grace|obj_stale\.hits|obj_stale\.http\.[-0-9A-Z_a-z]+|obj_stale\.is_valid|obj_stale\.keep|obj_stale\.proto|obj_stale\.reason|obj_stale\.status|obj_stale\.storage|obj_stale\.time|obj_stale\.ttl|obj_stale\.uncacheable|obj_stale)>" contained
syn match   vclVariable		"\v<(remote\.ip)>" contained
syn match   vclVariable		"\v<(req\.backend_hint|req\.can_gzip|req\.esi|req\.esi_level|req\.filters|req\.grace|req\.hash_always_miss|req\.hash_ignore_busy|req\.hash_ignore_vary|req\.hash|req\.http\.[-0-9A-Z_a-z]+|req\.is_hitmiss|req\.is_hitpass|req\.max_age|req\.method|req\.proto|req\.restarts|req\.storage|req\.time|req\.trace|req\.transport|req\.ttl|req\.url|req\.xid|req)>" contained
syn match   vclVariable		"\v<(req_top\.http\.[-0-9A-Z_a-z]+|req_top\.method|req_top\.proto|req_top\.time|req_top\.url)>" contained
syn match   vclVariable		"\v<(req0\.http\.[-0-9A-Z_a-z]+|req0\.method|req0\.proto|req0\.url)>" contained
syn match   vclVariable		"\v<(resp\.body|resp\.do_esi|resp\.esi_include_onerror|resp\.filters|resp\.http\.[-0-9A-Z_a-z]+|resp\.is_streaming|resp\.proto|resp\.reason|resp\.status|resp\.storage|resp\.time|resp)>" contained
syn match   vclVariable		"\v<(server\.hostname|server\.identity|server\.ip)>" contained
syn match   vclVariable		"\v<(sess\.idle_send_timeout|sess\.send_timeout|sess\.timeout_idle|sess\.timeout_linger|sess\.xid|sess)>" contained
syn match   vclVariable		"\v<(param\.[a-z_]+)>" contained
syn match   vclVariable		"\v<(storage\.[-0-9A-Z_a-z]+\.(free_space|happy|used_space)|storage\.[a-zA-Z0-9_-]+)>" contained

" == Backward compatibility ============================================
" Symbols removed or renamed in newer VCL, kept so legacy configurations
" continue to highlight.
" Legacy keywords / statements (VCL <= 4.0).
syn keyword vclKeyword		synthetic rollback contained
" error() was a top-level statement in VCL <= 4.0; kept as a vclKeyword match
" (not a keyword) so the vclReturn rule below, defined later, wins inside
" return(error(...)) -- last-defined match wins (see :help :syn-priority).
syn match   vclKeyword		"\<error\>" contained
" Legacy variables (removed/renamed).
syn match   vclVariable		"\v<(beresp\.backend\.port|beresp\.saintmode|beresp\.storage_hint)>" contained
syn match   vclVariable		"\v<(obj\.lastuse|obj\.response)>" contained
syn match   vclVariable		"\v<(req\.backend\.healthy|req\.backend|req\.request)>" contained

" == Return actions ====================================================
" Highlight the action name of return(action) as vclReturn. The zero-width
" lookbehind (\@<=) makes the match start at the action name, not at 'return',
" so the 'return' keyword (which has priority over matches) does not shadow it.
" This section is intentionally last: for action names that are also variable
" names (beresp, obj_stale, vcl) and for error (also a legacy keyword match
" above), the match starts at the same position as those items, so the
" last-defined match wins (see :help :syn-priority).
" Current return actions.
syn match   vclReturn		"\%(\<return\s*(\s*\)\@<=\(abandon\|beresp\|deliver\|error\|fail\|fetch\|hash\|lookup\|merge\|obj_stale\|ok\|pass\|pipe\|purge\|restart\|retry\|synth\|vcl\)\>" contained
" Legacy return actions (kept for backward compatibility).
syn match   vclReturn		"\%(\<return\s*(\s*\)\@<=\(hit_for_pass\|miss\)\>" contained

hi def link vclConstant		Constant
hi def link vclComment		Comment
hi def link vclKeyword		Statement
hi def link vclKeywordTop	Statement
hi def link vclString		String
hi def link vclReturn		Identifier
hi def link vclVariable		Type
hi def link vclConditional	Conditional
hi def link vclSubroutine	Function
hi def link vclContext		Identifier

let b:current_syntax = "vcl"

if has("folding") && exists("g:vcl_fold") && g:vcl_fold > 0
  setlocal foldmethod=syntax
endif

" vim:ts=8
