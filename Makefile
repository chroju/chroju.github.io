title = sample

new:
	git checkout -b ${title}
	hugo new blog/${title}.md
	echo "content/blog/${title}.md created."
