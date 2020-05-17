# frozen_string_literal: true

module PipelinesHelper
  class PipelineConfiguration
    attr_reader :name, :run, :run_args, :remove_existing
    #
    # Example Configuration:
    #
    # name=container_name (default: generated)
    # run=true (default: true)
    # run_args=-d -p 80:80 -v /mnt/md0:/data (default: empty)
    # remove_existing=true (default: false)
    #

    def initialize(path:, name:, run: true, run_args: '', remove_existing: false)
      @content = File.read(path)
      @name = try_get_value('name', name)
      @run = try_get_value('run', run)
      @run_args = try_get_value('run_args', run_args)
      @remove_existing = try_get_value('remove_existing', remove_existing)
    end

    def to_s
      "* name:             #{@name}
* run:              #{@run}
* run_args:         #{@run_args}
* remove_existing:  #{@remove_existing}"
    end

    private

    def try_get_value(key, default=nil)
      match = @content[/^[ ]*\#[ ]*#{key}\=.*$/]
      if match.nil?
        default
      else
        match[/\=.*/][1..]
      end
    end
  end
end
