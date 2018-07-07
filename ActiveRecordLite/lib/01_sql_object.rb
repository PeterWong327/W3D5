require_relative 'db_connection'
require 'active_support/inflector'


class SQLObject
  def self.columns
    if @attributes.nil? || @attributes.empty?
      @attributes = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          '#{table_name}'
      SQL
    end
    @attributes.first.map {|key| key.to_sym}
  end
  
  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end
      define_method("#{column}=") do |val|
        attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||
    "#{self.to_s.downcase}s"
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        '#{table_name}'
    SQL
    # data.map! { |datum| datum.delete('id') }
    # data.map { |datum| self.new(datum) }
    # # parse_all(data)
  end

  def self.parse_all(results)
    instances = []
    results.each do |hsh|
      instances << self.new(hsh)
    end 
    
    instances
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    cols = self.class.columns
    params.each do |k, v|
      raise "unknown attribute '#{k}'" unless cols.include?(k)
      send("#{k.to_sym}=", v)
    end
    @params = params
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
