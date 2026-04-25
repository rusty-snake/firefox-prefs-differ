# firefox-prefs-differ

1. `./download_firefox.sh 149.0`
2. `./podman-run.sh 149.0`
   - build the image first if it is outdated: `podman build -t firefox-prefs-differ -f Containerfile`
3. `Ctrl+Shift+K` and paste `about_config_extractor.js`
4. `wl-paste > all-prefs-149.0.js`
5. `./smart_differ.py 148.0 149.0`
