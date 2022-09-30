# encoding: utf-8
# Программа для записи расходов в XML
#
# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

#Подключаем библиотеку REXML и date
require 'rexml/document'
require 'date'

#Спросим необходимые данные у пользователя
puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_count = STDIN.gets.to_i

puts "Укажите дату трату в формате 12.09.2022.(пустое - сегодня)"
date_input = STDIN.gets.chomp

#Запишем дату и распарсим
expense_date = nil

if date_input == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "В какую категорию занести трату?"
expense_category = STDIN.gets.chomp

#Пропишем путь к файлу
current_path = File.dirname(__FILE__)
file_path = current_path + "/my_expenses.xml"

#Откроем и распарсим файл хмл

file = File.new(file_path, "r:UTF-8")

begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => error
  abort "Битый хмл: " + error.message
end

file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element "expense",
                               { "amount" => expense_count,
                                 "category" => expense_category,
                                 "date" => expense_date.to_s }
expense.text = expense_text

file = File.new(file_path, "w:UTF-8")
doc.write(file, 2)
file.close