vcl 4.1;  #t:kw_vcl_top

import std;  #t:kw_import
import std as std_alias from "libvmod_std.so";  #t:ctx_as_from
unused b1;  #t:kw_unused
include +glob "extra.vcl";  #t:kw_include  #t:ctx_glob

acl localnetwork { "localhost"; }  #t:kw_acl
acl flags +log +fold(+report) +pedantic +table { "localhost"; }  #t:ctx_acl_flags
backend empty_lower { none; }  #t:ctx_none
backend empty_upper { None; }  #t:ctx_None
backend b2 { .probe = default; }  #t:ctx_default  #t:ctx_backend_probe
backend b1 { .host = "localhost"; .port = "80"; .path = "/backend"; .host_header = "example.test"; .connect_timeout = 1s; .first_byte_timeout = 2s; .between_bytes_timeout = 3s; .max_connections = 10; .proxy_header = 1; .preamble = C{ int x = 0; }C; .via = b1; .authority = "example.test"; .wait_timeout = 1s; .wait_limit = 5; }  #t:kw_backend
probe p1 { .url = "/"; }  #t:kw_probe
probe p2 {
    .request = "GET / HTTP/1.1";  #t:ctx_probe_request
    .expected_response = 200;  #t:ctx_probe_expected
    .timeout = 1s;  #t:ctx_probe_timeout
    .interval = 2s;  #t:ctx_probe_interval
    .window = 3;  #t:ctx_probe_window
    .threshold = 2;  #t:ctx_probe_threshold
    .initial = 1;  #t:ctx_probe_initial
    .expect_close = false;  #t:ctx_probe_expect_close
}

sub vcl_init {
    new b = directors.round_robin();  #t:kw_new
    return (ok);  #t:ret_ok
}

sub vcl_recv {
    if (req.url == "/x") {  #t:cond_if
        return (error(503, "boom"));  #t:ret_error
    } elseif (false) {  #t:cond_elseif
    } elsif (true) {  #t:cond_elsif
    } elif (false) {  #t:cond_elif
    } else {  #t:cond_else
    }
    return (pipe);  #t:ret_pipe
    return (pass);  #t:ret_pass
    return (hash);  #t:ret_hash
    return (lookup);  #t:ret_lookup
    return (purge);  #t:ret_purge
    return (restart);  #t:ret_restart
    return (deliver);  #t:ret_deliver
    return (synth(503, "x"));  #t:ret_synth
    return (fetch);  #t:ret_fetch
    return (fail("nope"));  #t:ret_fail
    return (miss);  #t:ret_miss
    return (hit_for_pass);  #t:ret_hit_for_pass
    return (vcl(main));  #t:ret_vcl
    return (abandon);  #t:ret_abandon
    return (delivery);  #t:ret_prefix_delivery
    return (passenger);  #t:ret_prefix_passenger
    return (missed);  #t:ret_prefix_missed
    return (retry);  #t:ret_retry
    error(503, "legacy error statement");  #t:err_legacy
    ban("obj.http.x ~ y");  #t:kw_ban
    call foo;  #t:kw_call
    hash_data("/x");  #t:kw_hash_data
    set req.url = regsub(req.url, "^/", "");  #t:kw_regsub
    set req.url = regsuball(req.url, "x", "y");  #t:kw_regsuball
    set req.http.X = "double quoted";  #t:kw_set
    unset req.http.Cookie;  #t:kw_unset
    return;  #t:kw_return_bare
    if (true || false) {  #t:const_true
        if (now > req.time) {  #t:const_now
        }
    }
    if (false) {  #t:const_false
    }
}

sub vcl_backend_response {
    return (pass(30s));  #t:ret_pass_dur
    set bereq.filters = "gzip";  #t:var_bereq_filters
    set bereq.retry_connect = true;  #t:var_bereq_retry_connect
    set beresp.esi_disable_xml_check = true;  #t:var_beresp_esi_disable_xml_check
    set beresp.esi_ignore_https = true;  #t:var_beresp_esi_ignore_https
    set beresp.esi_ignore_other_elements = true;  #t:var_beresp_esi_ignore_other_elements
    set beresp.esi_remove_bom = true;  #t:var_beresp_esi_remove_bom
    set beresp.ttl = 1m;  #t:var_beresp_ttl
    set beresp.grace = 1m;  #t:var_beresp_grace
    set beresp.saintmode = true;  #t:var_beresp_saintmode
    set beresp.storage_hint = "foo";  #t:var_beresp_storage_hint
    set beresp.backend.port = 80;  #t:var_beresp_backend_port
    return (beresp);  #t:ret_beresp
}

sub vcl_backend_refresh {
    return (merge);  #t:ret_merge
    return (obj_stale);  #t:ret_obj_stale
    if (obj_stale.is_valid) {  #t:var_obj_stale_is_valid
        set obj_stale.age = 0s;  #t:var_obj_stale_age
    }
}

sub vcl_deliver {
    return (deliver);  #t:ret_deliver_2
    set req.filters = "gzip";  #t:var_req_filters
    set req.max_age = 30s;  #t:var_req_max_age
    set req.backend_hint = b;  #t:var_req_backend_hint
    set req.backend.healthy = true;  #t:var_req_backend_healthy
    set req.backend = b;  #t:var_req_backend
    set req.request = "GET";  #t:var_req_request
    set obj.ttl = 1m;  #t:var_obj_ttl
    set obj.lastuse = 0s;  #t:var_obj_lastuse
    set obj.response = "ok";  #t:var_obj_response
    set resp.esi_include_onerror = true;  #t:var_resp_esi_include_onerror
    set resp.storage = storage.s0;  #t:var_resp_storage
    set param.default_ttl = 10m;  #t:var_param_default_ttl
    set param.transit_buffer = 1m;  #t:var_param_transit_buffer
    set sess.xid = 0;  #t:var_sess_xid
    set req0.method = "GET";  #t:var_req0_method
    set req0.proto = "HTTP/1.1";  #t:var_req0_proto
    set req0.url = "/original";  #t:var_req0_url
    set req0.http.Original = "value";  #t:var_req0_http
    synthetic("legacy synthetic");  #t:kw_synthetic
    rollback();  #t:kw_rollback
    set req.http.Long = {"long string"};  #t:str_long
    set req.http.Triple = """triple string""";  #t:str_triple
    # a hash comment  #t:comment_hash
    // a slash comment  #t:comment_slash
    /* a block comment */  #t:comment_block
    C{ int x = 0; }C  #t:inline_c
}
