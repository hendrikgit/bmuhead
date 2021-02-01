# bmuhead
Adds the text `BMU V1.0` to the beginning of files. If that header is already present, nothing is done.

Download binaries under [releases](https://github.com/hendrikgit/bmuhead/releases).

A bash loop that does the same ;)
```bash
for f in *.bmu; do [ ! "$(sed -n '/^BMU V1.0/p;q' "$f")" ] && echo -n "BMU V1.0" | cat - $f > $f.bmuheader && mv $f.bmuheader $f; done
```
