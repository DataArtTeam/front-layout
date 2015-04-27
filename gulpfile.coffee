gulp = require 'gulp'
sass = require 'gulp-sass'
prefixer = require 'gulp-autoprefixer'
rename = require 'gulp-rename'
minify = require 'gulp-minify-css'
concatCss = require 'gulp-concat-css'
reload = require 'gulp-livereload'
connect = require 'gulp-connect'
bowerFiles = require 'main-bower-files'
rimraf = require 'gulp-rimraf'

config =
	sassPath: 'app/styles'
	bowerDir: 'app/bower_components'
	html: 'app'
	fonts: 'app/fonts'
	images: 'app/images'

target =
	css: 'dist/css'
	html: 'dist'
	images: 'dist/images'

gulp.task 'css', ->
	gulp.src config.sassPath + '/*.scss'
		.pipe sass
				style: 'compressed'
				includePaths: [
					config.sassPath,
					config.bowerDir + '/bootstrap-sass/assets/stylesheets'
				]
				onError: console.error.bind(console, 'Sass error:')
		.pipe prefixer 'last 3 versions'
		.pipe concatCss 'style.css'
		.pipe gulp.dest target.css
		.pipe minify
			relativeTo: 'app/bower_components'
			processImport: true
		.pipe rename 'style.min.css'
		.pipe gulp.dest target.css
		.pipe do connect.reload


gulp.task 'html', ->
	gulp.src config.html + '/*.html'
		.pipe gulp.dest target.html
		.pipe do connect.reload

gulp.task 'connect', ->
	connect.server
		root: 'dist',
		livereload: true

gulp.task 'watch', ->
	gulp.watch config.sassPath + '/*.scss', ['css']
	gulp.watch config.html + '/*.html', ['html']
	gulp.watch config.fonts + '/**/*', ['fonts']
	gulp.watch config.images + '/*', ['images']

gulp.task 'fonts', ->
	gulp.src bowerFiles(filter: '**/*.{eot,svg,ttf,woff,woff2}').concat config.fonts + '/**/*'
	 	.pipe gulp.dest 'dist/fonts'
	 	.pipe do connect.reload

gulp.task 'images', ->
	gulp.src config.images + '/*'
		.pipe gulp.dest target.images
		.pipe do connect.reload

gulp.task 'clean', (cb) ->
	rimraf 'dist', cb

gulp.task 'default', ['clean', 'html', 'css', 'fonts', 'images', 'connect', 'watch']


