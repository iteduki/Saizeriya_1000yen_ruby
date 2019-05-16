# frozen_string_literal: true

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'saizeriya.db')

class Menu < ActiveRecord::Base
end

Menu.all.each { |m| p m }
