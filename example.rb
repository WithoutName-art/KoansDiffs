secret = 'Loh'
guess = ''
while guess != secret
  puts('введите слово:')
  guess = gets.chomp
end
puts 'Вы выиграли'
