require 'fileutils'

module IronWorkerNG
  module Feature
    class Base
      def initialize(code)
        @code = code
      end

      def rebase(path)
        @code.base_dir + path
      end

      def zip_add(zip, dest, src)
        src, clean = IronWorkerNG::Fetcher.fetch(src, true)

        src = File.expand_path(src)

        unless File.exists?(src)
          IronCore::Logger.error 'IronWorkerNG', "Can't find src with path='#{src}'"
          raise IronCore::IronError.new("Can't find src with path='#{src}'")
        end

        if File.directory?(src)
          Dir.glob(src + '/**/**') do |path|
            zip.add(@code.dest_dir + dest + path[src.length .. -1], path)
          end
        else
          zip.add(@code.dest_dir + dest, src)
        end

        unless clean.nil?
          FileUtils.rm_f(clean)
        end
      end

      def hash_string
        ''
      end

      def bundle(zip)
      end
    end
  end
end
