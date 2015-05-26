require 'yaml'
require 'yaml/store'

module AR
  class Base
    attr_accessor :id

    class << self
      attr_accessor :yaml_file
    end

    def initialize(params)
      params.each do |k, v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end
    end

    def self.all
      data.map { |obj| obj.is_a?(self) ? obj : new(obj) }
    end

    def self.find(id)
      all.select { |obj| obj.id == id }.first
    end

    def self.find_by(args)
      where(args).first
    end

    def self.where(args)
      all.select do |obj|
        args.map do |k, v|
          obj.send(k) == v
        end.all?
      end
    end

    def self.create(params)
      new(params.merge(id: next_id)).tap do |obj|
        collection = all
        collection << obj
        save(collection)
      end
    end

    def self.delete(record)
      collection = all.reject { |obj| obj.id == record.id }
      save(collection)
    end

    private

    def self.data
      return [] unless File.exist?(file_name)
      yaml = YAML.load_file(file)
    end

    def self.file_name
      "#{(yaml_file || name)}.yml"
    end

    def self.file
      File.open(file_name) if File.exist?(file_name)
    end

    def self.last_id
      all.any? ? all.max_by(&:id).id : 0
    end

    def self.next_id
      last_id + 1
    end

    def self.save(collection)
      File.open(file_name, 'w') do |f|
        f.write collection.to_yaml
      end
    end
  end
end
