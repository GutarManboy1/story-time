require "faker"
# first delete everything....
Rails.application.eager_load!
models = ActiveRecord::Base.descendants

models.each do |model|
  next unless model.table_exists?

  puts "Burninating citizens from #{model.name}ville...TROOOGDOOOOOOOORRR!!!"
  model.destroy_all
end
# then reseed everything here....
# TODO make some mutha fuckin seeeeeeds biotch!
giraffe_people = [
  { email: "Zergyjanus@gmail.com", password: "giraffe" },
  { email: "glenntorrens@gmail.com", password: "giraffe" },
  { email: "avoeler@gmail.com", password: "giraffe" }
]
giraffe_people.each do |banana|
  User.create!(email: banana.email, password: banana.password)
end

10.times do
  user = User.new(email: Faker::Internet.email, password: "giraffe")
  user.save!
end
# programmers note.... Im going home now.... byeeeee
puts "You planted some pretty flowers!"
