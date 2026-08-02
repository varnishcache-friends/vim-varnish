#!/bin/sh
# Run Varnish and Vinyl Cache VCL syntax highlighting tests.
#
# Usage:
#   ./test/run.sh
#   VIM_BIN=nvim ./test/run.sh        # override the vim binary
#
# Exits non-zero if any test fails. Results are printed to stdout.
#
# Notes:
#   * Do NOT use the variable name VIM for the override -- $VIM is vim's own
#     reserved environment variable (the install/runtime path) and setting it
#     to a binary path breaks syntax loading. Hence VIM_BIN.
#   * The syntax under test is loaded under a unique name (b:current_syntax =
#     "vclvarnish-test") via a generated copy of syntax/vcl.vim, so it can never
#     be confused or collide with a system "vcl" syntax. The syn rules are
#     byte-for-byte the repo's; only the current_syntax name is changed.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
VIM_BIN=${VIM_BIN:-vim}

OUT=$(mktemp -t vcltest.XXXXXX) || exit 2
VOUT=$(mktemp -t vclvim.XXXXXX) || exit 2
TMPSYN=$(mktemp -t vclsyn.XXXXXX) || exit 2
trap 'rm -f "$OUT" "$VOUT" "$TMPSYN"' EXIT

# Generate the test-only syntax file: a verbatim copy of the repo's
# syntax/vcl.vim with b:current_syntax renamed to a unique value.
if ! sed 's#^let b:current_syntax = .*#let b:current_syntax = "vclvarnish-test"#' \
    "$ROOT/syntax/vcl.vim" >"$TMPSYN"; then
  echo "could not generate test syntax from $ROOT/syntax/vcl.vim" >&2
  exit 2
fi

# Load the fixture, source the (renamed) syntax under test, then run the
# assertions. The test script writes PASS/FAIL lines to $OUT and calls :cq
# (exit non-zero) on any failure.
#
# A clean slate is forced first (syntax clear + unlet b:current_syntax) so the
# file's own guard ("elseif exists('b:current_syntax') | finish") can't no-op
# against anything already loaded.
#
# vim's stdout is redirected to a real file (not /dev/null): in silent-ex
# (-es) mode, discarding stdout can prevent syntax from being computed.
"$VIM_BIN" -es -u NONE -N \
  -c "cd $ROOT" \
  -c "syntax on" \
  -c "edit test/fixtures/sample.vcl" \
  -c "syntax clear" \
  -c "unlet! b:current_syntax" \
  -c "source $TMPSYN" \
  -c "let g:vcl_test_out = '$OUT'" \
  -c "source test/assertions.vim" \
  -c "q!" >"$VOUT" 2>&1
rc=$?

cat "$OUT"

if [ "$rc" -ne 0 ]; then
  cat "$VOUT" >&2
  echo "FAILED (vim exit $rc)"
fi
exit "$rc"
