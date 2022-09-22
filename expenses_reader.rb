require "rexml/document"
require 'date'

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

unless File.exist?(file_name)
  abort "Файл с финансами не найден"
end

file = File.new(file_name, "r:UTF-8")

doc = REXML::Document.new(file)

ammount_day = {}

sum = 0

doc.elements.each("expenses/expense") do |item|

  loss_sum_day = item.attributes["amount"].to_i
  loss_day = Date.parse(item.attributes["date"])
  ammount_day[loss_day] ||= 0
  ammount_day[loss_day] += loss_sum_day
  sum += loss_sum_day

end

ammount_mouth = {}

ammount_day.each do |key, item|
  loss_sum_mouth = item.to_i
  loss_mouth = key.strftime("%B %Y")
  ammount_mouth[loss_mouth] ||= 0
  ammount_mouth[loss_mouth] += loss_sum_mouth
end

current_mouth = ammount_day.keys.sort[0].strftime("%B %Y")

puts "Вы потратили всего: #{sum} руб."

puts "Вы потратили в #{current_mouth}: #{ammount_mouth[current_mouth]}"

ammount_day.keys.sort.each do |key, item|
  if current_mouth != key.strftime("%B %Y")
    current_mouth = key.strftime("%B %Y")
    puts "Вы потратили в #{current_mouth}: #{ammount_mouth[current_mouth]}"
  end
  puts "Дата: #{key} => потратили: #{ammount_day[key]}"
end

