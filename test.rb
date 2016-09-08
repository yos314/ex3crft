require "./dice_pool.rb"

charms = {uif: true, fmotd: true, fhm: true, smf2: true, smf3: true, ecottv: true, dit: true, hmu: true, fhm2: true, excellency: true, mem: true}
data = {essence: 3, intelligence: 4, craft_skill: 5, log: false}
test = DicePool.new(charms, data)
ta = Array.new(20){ DicePool.new(charms, data)}
puts test.charms.to_s
puts test.data.to_s
puts test.successes
puts test.motes
puts test.sxp
puts test.gxp
puts test.wxp
puts test.wp

puts ta.map{|x| [x.successes, x.motes, x.sxp, x.gxp, x.wxp, x.wp]}.to_s