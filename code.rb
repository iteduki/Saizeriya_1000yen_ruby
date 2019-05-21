# frozen_string_literal: true

require 'active_record'
require 'sinatra'
require 'slim'
require 'slim/include'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'saizeriya.db')
class Menu < ActiveRecord::Base; end

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  slim :index
end

get '/get' do
  @menus = get_menus
  @tweet_text = "サイゼリヤ1000円ガチャを回したよ！\n\n#{@menus.map(&:name).join("\n")}\n\n#{total_row(@menus)}\n\n"
  slim :index
end

def get_menus(budget = 1000)
  candidate = Menu.where('price <= ?', budget)
  menus = []

  while candidate.present?
    menus.push(candidate.sample)
    candidate = candidate.select { |menu| menu.price <= budget - menus.sum(&:price) }
  end
  menus
end

def total_row(menus)
  "計　#{@menus.sum(&:price)}円　#{@menus.sum(&:calorie)}kcal　#{@menus.sum(&:salt).round(2)}g"
end
