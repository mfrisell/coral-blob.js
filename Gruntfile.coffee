module.exports = (grunt) ->

	grunt.initConfig {
		pkg: grunt.file.readJSON 'package.json'

		# Wiredep config. Insert Bower packages into html files
		wiredep: {
			task: {
				src:['index.html']
			}
		}

		# Watch files for changes and execute rlated tasks on them 
		watch: {
			coffee: {
				files: 'coffeescript/*.coffee'
				tasks: 'coffee:compile'
			}

			sass: {
				files: 'scss/*.scss'
				tasks: 'sass:compile'
			}

			bower: {
				files: 'bower.json'
				tasks: 'wiredep'
			}

		}

		# Configuration and targets for the coffee task
		coffee: {
			compile: {
				options: {
					bare: true
					join: true
					sourceMap: true
				}

				files: {
					'js/main.js': 'coffeescript/*.coffee'
				}
			}
		}

		sass: {
			options: {
		    	sourceMap: true
			}
			compile: {
			    files: {
			        'css/main.css': 'scss/main.scss'
			    }
			}
	   	}

		coffeelint: {
			lint: 'coffeescript/*.coffee'
		}


		# Configuration for browser sync (auto refresh)
		browserSync: {
			bsFiles: {
				src: ['js/*.js', 'css/*.css', 'index.html']
			}

			options: {
				proxy: 'localhost.boilerplate.com'
				# server: {
				# 	baseDir: 'src/'
				# }
			}
		}

	}

	# Load the grunt-wiredep task. This injects Bower components into html files
	grunt.loadNpmTasks 'grunt-wiredep'
	grunt.loadNpmTasks 'grunt-contrib-watch' 
	grunt.loadNpmTasks 'grunt-contrib-coffee' 
	grunt.loadNpmTasks 'grunt-coffeelint'
	grunt.loadNpmTasks 'grunt-browser-sync'
	grunt.loadNpmTasks 'grunt-sass'


	

	#  Default task(s)
	grunt.registerTask 'default', ['browserSync']