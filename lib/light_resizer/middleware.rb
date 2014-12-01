# encoding: utf-8
require 'light_resizer/image_loader'
require 'light_resizer/middleware/path'
require 'light_resizer/middleware/resizer'

module LightResizer
  class Middleware

    def initialize(app, root, folder = 'public')
      @app           = app
      @image_loader  = LightResizer::ImageLoader.new File.join(root, folder)
      @resizer       = LightResizer::Middleware::Resizer.new
    end

    def call(env)
      @path          = LightResizer::Middleware::Path.new(env['PATH_INFO'])
      
      if @path.image_path? and @path.original_image_exists?
      	resize_and_serve_file
      else
      	@app.call(env)
      end

    end

    private

    def resize_and_serve_file
      @resizer.resize(
        @path.dimensions,
        @image_loader.original_path,
        @image_loader.resize_path,
        @path.crop_path?,
        @path.image_extension,
        @path.convert_path?
      ) unless @image_loader.resized_image_exist?

      Rack::File.new(@image_loader.resized.root_dir).call(env) #todo check
    end

  end
end
