" Test runner for Varnish and Vinyl Cache VCL syntax highlighting.
"
" Expects: the fixture buffer test/fixtures/sample.vcl is loaded and
" syntax/vcl.vim has been sourced. Writes PASS/FAIL lines to g:vcl_test_out
" and exits non-zero (:cq) on any failure.
"
" Each case is [marker, token, want, desc]:
"   marker  - unique substring identifying the fixture line (a #t:<id> comment)
"   token   - the exact substring on that line to probe (its first occurrence)
"   want    - expected syntax group name at that position
"   desc    - human-readable description

let s:out = g:vcl_test_out
let s:fail = 0

function! s:record(kind, msg) abort
  call writefile([a:kind . ': ' . a:msg], s:out, 'a')
  if a:kind ==# 'FAIL'
    let s:fail += 1
  endif
endfunction

function! s:findline(marker) abort
  for i in range(1, line('$'))
    if stridx(getline(i), a:marker) >= 0
      return i
    endif
  endfor
  return 0
endfunction

function! s:check(marker, token, want, desc) abort
  let ln = s:findline(a:marker)
  if ln == 0
    call s:record('FAIL', a:desc . ' [marker not found: ' . a:marker . ']')
    return
  endif
  let col = stridx(getline(ln), a:token) + 1
  if col == 0
    call s:record('FAIL', a:desc . ' [token not found on L' . ln . ': ' . a:token . ']')
    return
  endif
  let got = synIDattr(synID(ln, col, 1), 'name')
  if got ==# a:want
    call s:record('PASS', a:desc)
  else
    call s:record('FAIL', a:desc . ' [L' . ln . 'C' . col . ' want ' . a:want . ' got ' . got . ']')
  endif
endfunction

" Sentinels: prove that the (renamed) syntax under test is actually loaded.
" 'unused' and the param.*/obj_stale.* variables are repo-only (no system
" vcl syntax defines them), so if any of these is wrong the whole suite is
" meaningless -- we would be testing the wrong file (or none). Fail fast.
let s:syn = get(b:, 'current_syntax', '')
if s:syn !=# 'vclvarnish-test'
  call s:record('FAIL', 'SENTINEL: b:current_syntax=' . string(s:syn) . ' (expected vclvarnish-test -- wrong/no syntax loaded)')
  cq
endif
call s:check('#t:kw_unused', 'unused', 'vclKeywordTop', 'SENTINEL: repo syntax loaded (unused is repo-only)')
call s:check('#t:var_obj_stale_is_valid', 'obj_stale.is_valid', 'vclVariable', 'SENTINEL: repo syntax loaded (obj_stale is repo-only)')
call s:check('#t:var_param_default_ttl', 'param.default_ttl', 'vclVariable', 'SENTINEL: repo syntax loaded (param.* is repo-only)')

" --- current return actions (must be vclReturn) ---
call s:check('#t:ret_abandon',   'abandon',      'vclReturn', 'return(abandon)')
call s:check('#t:ret_beresp',    'beresp',       'vclReturn', 'return(beresp) action, not vclVariable')
call s:check('#t:ret_deliver',   'deliver',      'vclReturn', 'return(deliver)')
call s:check('#t:ret_deliver_2', 'deliver',      'vclReturn', 'return(deliver) in vcl_deliver')
call s:check('#t:ret_error',     'error',        'vclReturn', 'return(error(...)) action, not vclKeyword')
call s:check('#t:ret_fail',      'fail',         'vclReturn', 'return(fail)')
call s:check('#t:ret_fetch',     'fetch',        'vclReturn', 'return(fetch)')
call s:check('#t:ret_hash',      'hash',         'vclReturn', 'return(hash)')
call s:check('#t:ret_lookup',    'lookup',       'vclReturn', 'return(lookup)')
call s:check('#t:ret_merge',     'merge',        'vclReturn', 'return(merge) [new]')
call s:check('#t:ret_obj_stale', 'obj_stale',    'vclReturn', 'return(obj_stale) action, not vclVariable')
call s:check('#t:ret_ok',        'ok',           'vclReturn', 'return(ok)')
call s:check('#t:ret_pass',      'pass',         'vclReturn', 'return(pass)')
call s:check('#t:ret_pass_dur',  'pass',         'vclReturn', 'return(pass(30s))')
call s:check('#t:ret_pipe',      'pipe',         'vclReturn', 'return(pipe)')
call s:check('#t:ret_purge',     'purge',        'vclReturn', 'return(purge)')
call s:check('#t:ret_restart',   'restart',      'vclReturn', 'return(restart)')
call s:check('#t:ret_retry',     'retry',        'vclReturn', 'return(retry)')
call s:check('#t:ret_synth',     'synth',        'vclReturn', 'return(synth(...))')
call s:check('#t:ret_vcl',       'vcl',          'vclReturn', 'return(vcl(label)) action')

" Return-action names must not match prefixes of longer words.
call s:check('#t:ret_prefix_delivery',  'delivery',  '', 'return(delivery) is not a return action')
call s:check('#t:ret_prefix_passenger', 'passenger', '', 'return(passenger) is not a return action')
call s:check('#t:ret_prefix_missed',    'missed',    '', 'return(missed) is not a return action')

" --- legacy return actions (kept, still vclReturn) ---
call s:check('#t:ret_hit_for_pass', 'hit_for_pass', 'vclReturn', 'return(hit_for_pass) [legacy]')
call s:check('#t:ret_miss',         'miss',         'vclReturn', 'return(miss) [legacy]')

" --- error dual handling ---
call s:check('#t:err_legacy', 'error', 'vclKeyword', 'legacy error(...) statement')

" --- 'return' itself and bare return; ---
call s:check('#t:kw_return_bare', 'return', 'vclKeyword', 'bare return; statement')

" --- top-level keywords (vclKeywordTop) ---
call s:check('#t:kw_vcl_top', 'vcl',     'vclKeywordTop', 'vcl <version>; at top level')
call s:check('#t:kw_acl',     'acl',     'vclKeywordTop', 'acl declaration')
call s:check('#t:kw_backend', 'backend', 'vclKeywordTop', 'backend declaration')
call s:check('#t:kw_backend', 'host', 'vclContext', 'backend .host field')
call s:check('#t:kw_backend', 'port', 'vclContext', 'backend .port field')
call s:check('#t:kw_backend', 'path', 'vclContext', 'backend .path field')
call s:check('#t:kw_backend', 'host_header', 'vclContext', 'backend .host_header field')
call s:check('#t:kw_backend', 'connect_timeout', 'vclContext', 'backend .connect_timeout field')
call s:check('#t:kw_backend', 'first_byte_timeout', 'vclContext', 'backend .first_byte_timeout field')
call s:check('#t:kw_backend', 'between_bytes_timeout', 'vclContext', 'backend .between_bytes_timeout field')
call s:check('#t:ctx_backend_probe', 'probe', 'vclContext', 'backend .probe field')
call s:check('#t:kw_backend', 'max_connections', 'vclContext', 'backend .max_connections field')
call s:check('#t:kw_backend', 'proxy_header', 'vclContext', 'backend .proxy_header field')
call s:check('#t:kw_backend', 'preamble', 'vclContext', 'backend .preamble field')
call s:check('#t:kw_backend', 'via', 'vclContext', 'backend .via field')
call s:check('#t:kw_backend', 'authority', 'vclContext', 'backend .authority field')
call s:check('#t:kw_backend', 'wait_timeout', 'vclContext', 'backend .wait_timeout field')
call s:check('#t:kw_backend', 'wait_limit', 'vclContext', 'backend .wait_limit field')
call s:check('#t:kw_import',  'import',  'vclKeywordTop', 'import statement')
call s:check('#t:kw_probe',   'probe',   'vclKeywordTop', 'probe declaration')
call s:check('#t:kw_probe', 'url', 'vclContext', 'probe .url field')
call s:check('#t:ctx_probe_request', 'request', 'vclContext', 'probe .request field')
call s:check('#t:ctx_probe_expected', 'expected_response', 'vclContext', 'probe .expected_response field')
call s:check('#t:ctx_probe_timeout', 'timeout', 'vclContext', 'probe .timeout field')
call s:check('#t:ctx_probe_interval', 'interval', 'vclContext', 'probe .interval field')
call s:check('#t:ctx_probe_window', 'window', 'vclContext', 'probe .window field')
call s:check('#t:ctx_probe_threshold', 'threshold', 'vclContext', 'probe .threshold field')
call s:check('#t:ctx_probe_initial', 'initial', 'vclContext', 'probe .initial field')
call s:check('#t:ctx_probe_expect_close', 'expect_close', 'vclContext', 'probe .expect_close field')
call s:check('#t:ctx_none', 'none', 'vclContext', 'empty backend none')
call s:check('#t:ctx_None', 'None', 'vclContext', 'empty backend None')
call s:check('#t:ctx_default', 'default', 'vclContext', 'default pseudo-symbol')
call s:check('#t:ctx_acl_flags', 'log', 'vclContext', 'ACL log flag')
call s:check('#t:ctx_acl_flags', 'fold', 'vclContext', 'ACL fold flag')
call s:check('#t:ctx_acl_flags', 'pedantic', 'vclContext', 'ACL pedantic flag')
call s:check('#t:ctx_acl_flags', 'table', 'vclContext', 'ACL table flag')
call s:check('#t:ctx_acl_flags', 'report', 'vclContext', 'ACL fold report subflag')
call s:check('#t:kw_unused',  'unused',  'vclKeywordTop', 'unused keyword [new]')

" --- keywords / functions (vclKeyword) ---
call s:check('#t:kw_ban',        'ban',        'vclKeyword', 'ban() function')
call s:check('#t:kw_call',       'call',       'vclKeyword', 'call statement')
call s:check('#t:kw_hash_data',  'hash_data',  'vclKeyword', 'hash_data() function')
call s:check('#t:kw_include',    'include',    'vclKeyword', 'include statement')
call s:check('#t:ctx_as_from', 'as', 'vclContext', 'VMOD import as')
call s:check('#t:ctx_as_from', 'from', 'vclContext', 'VMOD import from')
call s:check('#t:ctx_glob', 'glob', 'vclContext', 'include +glob flag')
call s:check('#t:kw_new',        'new',        'vclKeyword', 'new statement')
call s:check('#t:kw_regsub',     'regsub',     'vclKeyword', 'regsub() function')
call s:check('#t:kw_regsuball',  'regsuball',  'vclKeyword', 'regsuball() function')
call s:check('#t:kw_set',        'set',        'vclKeyword', 'set statement')
call s:check('#t:kw_unset',      'unset',      'vclKeyword', 'unset statement')

" --- legacy keywords (kept, vclKeyword) ---
call s:check('#t:kw_synthetic', 'synthetic', 'vclKeyword', 'synthetic() [legacy]')
call s:check('#t:kw_rollback',  'rollback',  'vclKeyword', 'rollback() [legacy]')

" --- conditionals ---
call s:check('#t:cond_if',      'if',      'vclConditional', 'if')
call s:check('#t:cond_elseif',  'elseif',  'vclConditional', 'elseif')
call s:check('#t:cond_elsif',   'elsif',   'vclConditional', 'elsif')
call s:check('#t:cond_elif',    'elif',    'vclConditional', 'elif')
call s:check('#t:cond_else',    'else',    'vclConditional', 'else')

" --- constants ---
call s:check('#t:const_true',  'true',  'vclConstant', 'true')
call s:check('#t:const_false', 'false', 'vclConstant', 'false')
call s:check('#t:const_now',   'now',   'vclConstant', 'now')

" --- current variables (vclVariable) ---
call s:check('#t:var_bereq_filters',              'bereq.filters',              'vclVariable', 'bereq.filters [new]')
call s:check('#t:var_bereq_retry_connect',        'bereq.retry_connect',        'vclVariable', 'bereq.retry_connect [new]')
call s:check('#t:var_beresp_esi_disable_xml_check',  'beresp.esi_disable_xml_check',  'vclVariable', 'beresp.esi_disable_xml_check [new]')
call s:check('#t:var_beresp_esi_ignore_https',       'beresp.esi_ignore_https',       'vclVariable', 'beresp.esi_ignore_https [new]')
call s:check('#t:var_beresp_esi_ignore_other_elements', 'beresp.esi_ignore_other_elements', 'vclVariable', 'beresp.esi_ignore_other_elements [new]')
call s:check('#t:var_beresp_esi_remove_bom',         'beresp.esi_remove_bom',         'vclVariable', 'beresp.esi_remove_bom [new]')
call s:check('#t:var_beresp_ttl',                 'beresp.ttl',                 'vclVariable', 'beresp.ttl')
call s:check('#t:var_beresp_grace',               'beresp.grace',               'vclVariable', 'beresp.grace')
call s:check('#t:var_obj_stale_age',              'obj_stale.age',              'vclVariable', 'obj_stale.age [new]')
call s:check('#t:var_obj_stale_is_valid',         'obj_stale.is_valid',         'vclVariable', 'obj_stale.is_valid [new]')
call s:check('#t:var_obj_ttl',                    'obj.ttl',                    'vclVariable', 'obj.ttl')
call s:check('#t:var_req_filters',                'req.filters',                'vclVariable', 'req.filters [new]')
call s:check('#t:var_req_max_age',                'req.max_age',                'vclVariable', 'req.max_age [new]')
call s:check('#t:var_req_backend_hint',           'req.backend_hint',           'vclVariable', 'req.backend_hint')
call s:check('#t:var_resp_esi_include_onerror',   'resp.esi_include_onerror',   'vclVariable', 'resp.esi_include_onerror [new]')
call s:check('#t:var_resp_storage',               'resp.storage',               'vclVariable', 'resp.storage [new]')
call s:check('#t:var_param_default_ttl',          'param.default_ttl',          'vclVariable', 'param.default_ttl [new]')
call s:check('#t:var_param_transit_buffer',       'param.transit_buffer',       'vclVariable', 'param.transit_buffer [new]')
call s:check('#t:var_sess_xid',                   'sess.xid',                   'vclVariable', 'sess.xid')
call s:check('#t:var_req0_method',           'req0.method',           'vclVariable', 'req0.method [new]')
call s:check('#t:var_req0_proto',            'req0.proto',            'vclVariable', 'req0.proto [new]')
call s:check('#t:var_req0_url',              'req0.url',              'vclVariable', 'req0.url [new]')
call s:check('#t:var_req0_http',             'req0.http.Original',     'vclVariable', 'req0.http.* [new]')

" --- legacy variables (kept, still vclVariable) ---
call s:check('#t:var_beresp_backend_port', 'beresp.backend.port', 'vclVariable', 'beresp.backend.port [legacy]')
call s:check('#t:var_beresp_saintmode',    'beresp.saintmode',    'vclVariable', 'beresp.saintmode [legacy]')
call s:check('#t:var_beresp_storage_hint', 'beresp.storage_hint', 'vclVariable', 'beresp.storage_hint [legacy]')
call s:check('#t:var_obj_lastuse',         'obj.lastuse',         'vclVariable', 'obj.lastuse [legacy]')
call s:check('#t:var_obj_response',        'obj.response',        'vclVariable', 'obj.response [legacy]')
call s:check('#t:var_req_backend',         'req.backend',         'vclVariable', 'req.backend [legacy]')
call s:check('#t:var_req_backend_healthy', 'req.backend.healthy', 'vclVariable', 'req.backend.healthy [legacy]')
call s:check('#t:var_req_request',         'req.request',         'vclVariable', 'req.request [legacy]')

" --- strings ---
call s:check('#t:kw_set',    'double quoted', 'vclString', 'double-quoted string')
call s:check('#t:str_long',  'long string',   'vclString', '{"..."} long string')
call s:check('#t:str_triple', 'triple string', 'vclString', '"""...""" triple-quoted string')

" --- comments ---
call s:check('#t:comment_hash',  '#',   'vclComment', '# comment')
call s:check('#t:comment_slash', '//',  'vclComment', '// comment')
call s:check('#t:comment_block', '/*',  'vclComment', '/* block */ comment')

" --- inline C ---
call s:check('#t:inline_c', 'int', 'cType', 'C{ ... }C inline C (c.vim)')

if s:fail
  cq
endif
