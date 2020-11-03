# frozen_string_literal: true

module PipelinesHelper
  class PipelineConfiguration
    attr_reader :name, :run, :run_args, :remove_existing

    def initialize(path:, name:, run: true, run_args: '', remove_existing: false)
      @content = File.read(path)
      @name = try_get_value('name', name)
      @run = try_get_value('run', run)
      @run_args = try_get_value('run_args', run_args)
      @remove_existing = try_get_value('remove_existing', remove_existing)
    end

    def to_s
      <<~STR
        * name:             #{@name}
        * run:              #{@run}
        * run_args:         #{@run_args}
        * remove_existing:  #{@remove_existing}
      STR
    end

    private

    def try_get_value(key, default = nil)
      match = @content[/^[ ]*\#[ ]*#{key}\=.*$/]
      if match.nil?
        default
      else
        match[/\=.*/][1..]
      end
    end
  end
end
