" vim syntax file
" Language:	Varnish Configuration Language
" Maintainer:	Federico G. Schwindt <fgsch@lodoss.net>
" Last Change:	2016 Jun 15
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn include syntax/html.vim

syn region  vclBlock		start="{" end="}"
	\ transparent contains=ALLBUT,vclKeywordTop
syn match   vclComment		"#.*$"
syn match   vclComment		"//.*$"
syn region  vclComment		start="/\*" end="\*/"
syn keyword vclConditional	elif else elseif elsif if contained
syn keyword vclConstant		true false now contained
syn region  vclInlineC		start="C{" end="}C"
syn keyword vclKeyword		include
syn keyword vclKeyword		ban call error hash_data new contained
syn keyword vclKeyword		regsub regsuball return rollback contained
syn keyword vclKeyword		set synthetic unset contained
syn keyword vclKeywordTop	acl backend import probe sub
syn keyword vclReturn		abandon deliver fail fetch hash contained
syn keyword vclReturn		hit_for_pass lookup miss ok pass contained
syn keyword vclReturn		pipe purge restart retry synth contained
syn region  vclString 		start='"' end='"'
syn region  vclString 		start='{"' end='"}' contains=@htmlTop
syn match   vclVariable		"\v<(bereq\.backend|bereq\.between_bytes_timeout|bereq\.body|bereq\.connect_timeout|bereq\.first_byte_timeout|bereq\.http\.[a-zA-Z0-9_-]+|bereq\.method|bereq\.proto|bereq\.retries|bereq\.uncacheable|bereq\.url|bereq\.xid|bereq|beresp\.age|beresp\.backend|beresp\.backend\.ip|beresp\.backend\.name|beresp\.backend\.port|beresp\.body|beresp\.do_esi|beresp\.do_gunzip|beresp\.do_gzip|beresp\.do_stream|beresp\.grace|beresp\.http\.[a-zA-Z0-9_-]+|beresp\.keep|beresp\.proto|beresp\.reason|beresp\.saintmode|beresp\.status|beresp\.storage|beresp\.storage_hint|beresp\.ttl|beresp\.uncacheable|beresp\.was_304|beresp|client\.identity|client\.ip|local\.ip|obj\.age|obj\.grace|obj\.hits|obj\.http\.[a-zA-Z0-9_-]+|obj\.keep|obj\.lastuse|obj\.proto|obj\.reason|obj\.response|obj\.status|obj\.ttl|obj\.uncacheable|remote\.ip|req\.backend|req\.backend\.healthy|req\.backend_hint|req\.can_gzip|req\.esi|req\.esi_level|req\.grace|req\.hash_always_miss|req\.hash_ignore_busy|req\.http\.[a-zA-Z0-9_-]+|req\.method|req\.proto|req\.request|req\.restarts|req\.ttl|req\.url|req\.xid|req|req_top\.http\.[a-zA-Z0-9_-]+|req_top\.method|req_top\.proto|req_top\.url|resp\.body|resp\.http\.[a-zA-Z0-9_-]+|resp\.is_streaming|resp\.proto|resp\.reason|resp\.status|resp|server\.hostname|server\.identity|server\.ip|server\.port)>" contained
syn match   vclVariable		"\v<(storage\.[a-zA-Z0-9_-]+\.(free_space|used_space|happy)|storage\.[a-zA-Z0-9_-]+)>" contained

hi def link vclConstant		Constant
hi def link vclComment		Comment
hi def link vclKeyword		Statement
hi def link vclKeywordTop	Statement
hi def link vclString		Constant
hi def link vclReturn		Identifier
hi def link vclVariable		Type

let b:current_syntax = "vcl"

" vim:ts=8
