" vim syntax file
" Language:	Varnish Configuration Language
" Maintainer:	Federico G. Schwindt <fgsch@lodoss.net>
" Last Change:	2020 May 23
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn include syntax/html.vim

syn region  vclBlock		start="{" end="}"
	\ transparent contains=ALLBUT,vclKeywordTop fold
syn match   vclComment		"#.*$"
syn match   vclComment		"//.*$"
syn region  vclComment		start="/\*" end="\*/" fold
syn keyword vclConditional	elif else elseif elsif if contained
syn keyword vclConstant		true false now contained
syn region  vclInlineC		start="C{" end="}C" fold
syn keyword vclKeyword		include
syn keyword vclKeyword		ban call error hash_data new contained
syn keyword vclKeyword		regsub regsuball return rollback contained
syn keyword vclKeyword		set synthetic unset contained
syn keyword vclKeywordTop	acl backend import probe sub vcl
syn keyword vclReturn		abandon deliver fail fetch hash contained
syn keyword vclReturn		hit_for_pass lookup miss ok pass contained
syn keyword vclReturn		pipe purge restart retry synth contained
syn region  vclString		start='"' end='"'
syn region  vclString		start='{"' end='"}' contains=@htmlTop
syn match   vclVariable		"\v<(client\.identity|client\.ip|local\.endpoint|local\.ip|local\.socket|remote\.ip|server\.hostname|server\.identity|server\.ip)>" contained
syn match   vclVariable		"\v<(req\.backend\.healthy|req\.backend_hint|req\.backend|req\.can_gzip|req\.esi|req\.esi_level|req\.grace|req\.hash_always_miss|req\.hash_ignore_busy|req\.hash|req\.http\.[a-zA-Z0-9_-]+|req\.is_hitmiss|req\.is_hitpass|req\.method|req\.proto|req\.request|req\.restarts|req\.storage|req\.ttl|req\.url|req\.xid|req|req_top\.http\.[a-zA-Z0-9_-]+|req_top\.method|req_top\.proto|req_top\.url)>" contained
syn match   vclVariable		"\v<(resp\.body|resp\.do_esi|resp\.filters|resp\.http\.[a-zA-Z0-9_-]+|resp\.is_streaming|resp\.proto|resp\.reason|resp\.status|resp)>" contained
syn match   vclVariable		"\v<(bereq\.backend|bereq\.between_bytes_timeout|bereq\.body|bereq\.connect_timeout|bereq\.first_byte_timeout|bereq\.hash|bereq\.http\.[a-zA-Z0-9_-]+|bereq\.is_bgfetch|bereq\.method|bereq\.proto|bereq\.retries|bereq\.uncacheable|bereq\.url|bereq\.xid|bereq)" contained
syn match   vclVariable		"\v<(beresp\.age|beresp\.backend\.ip|beresp\.backend\.name|beresp\.backend\.port|beresp\.backend|beresp\.body|beresp\.do_esi|beresp\.do_gunzip|beresp\.do_gzip|beresp\.do_stream|beresp\.filters|beresp\.grace|beresp\.http\.[a-zA-Z0-9_-]+|beresp\.keep|beresp\.proto|beresp\.reason|beresp\.stainmode|beresp\.status|beresp\.storage|beresp\.storage_hint|beresp\.ttl|beresp\.uncacheable|beresp\.was_304|beresp)>" contained
syn match   vclVariable		"\v<(obj\.age|obj\.can_esi|obj\.grace|obj\.hits|obj\.http\.[a-zA-Z0-9_-]+|obj\.keep|obj\.lastuse|obj\.proto|obj\.reason|obj\.response|obj\.status|obj\.storage|obj\.ttl|obj\.uncacheable|obj)>" contained
syn match   vclVariable		"\v<(sess\.idle_send_timeout|sess\.send_timeout|sess\.timeout_idle|sess\.timeout_linger|sess\.xid)>" contained
syn match   vclVariable		"\v<(storage\.[a-zA-Z0-9_-]+\.(free_space|happy|used_space)|storage\.[a-zA-Z0-9_-]+)>" contained

hi def link vclConstant		Constant
hi def link vclComment		Comment
hi def link vclKeyword		Statement
hi def link vclKeywordTop	Statement
hi def link vclString		Constant
hi def link vclReturn		Identifier
hi def link vclVariable		Type
hi def link vclConditional      Conditional

let b:current_syntax = "vcl"

if has("folding") && exists("g:vcl_fold") && g:vcl_fold > 0
  setlocal foldmethod=syntax
endif

" vim:ts=8
