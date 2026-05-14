yazi_zed() {
  # Portable mktemp: create under TMPDIR (or /tmp) with XXXXXX template
  tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-chooser.XXXXXX")" || return

  yazi "$@" --chooser-file "$tmp"

  opened_file="$(head -n 1 "$tmp")"
  if [[ -n "$opened_file" ]]; then
    zed -- "$opened_file"
  fi

  rm -f -- "$tmp"
}
