require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :create_file_with_content do |path, content|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          if resource.name == path
            if (Array(resource.action) & [:create, :create_if_missing]).any?
              case resource_type(resource)
                when 'template'
                  @actual_content = render(resource, chef_run.node)
                  @actual_content.to_s.include? content
                when 'file'
                  @actual_content = resource.content
                  @actual_content.to_s.include? content
              end
            end
          end
        end
      end
      failure_message_for_should do |actual|
        "File content:\n#{@actual_content} does not match expected:\n#{content}"
      end
    end
  end
end