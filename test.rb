require "./dice_pool.rb"

charms = {uif: true, fmotd: true, fhm: true, smf2: true, smf3: true, ecottv: true, dit: true, hmu: true, fhm2: true, excellency: true, mem: true}
data = {essence: 3, intelligence: 4, craft_skill: 5, log: true}
test = DicePool.new(charms, data)
ta = Array.new(20){ DicePool.new(charms, data)}
puts test.charms.to_s
puts test.data.to_s
puts test.successes

puts ta.map{|x| x.successes}.to_s