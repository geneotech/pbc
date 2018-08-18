pngize() {
	for GIF_FILE in "$@"; do
		magick $GIF_FILE -coalesce "$(basename $GIF_FILE .gif)_%d.png"
	done
}

pngize_all() {
	for GIF_FILE in *.gif; do
		pngize $GIF_FILE
	done
}
