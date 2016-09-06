class Craft
  attr_accessor :base_pool, :essence, :int #non charms
  attr_accessor :fhm, :fhm2, :smf, :smf2, :smf3, :ecottv, :fmotd, :uif, :mem, :dit, :hmu #charms
  attr_reader :successes, :motes, :gxp, :sxp, :wxp, :wp #outputs
  def initialize(x)
    @base_pool = x
    @dice = Array.new
    @rerolls = Array.new
    @used_successes = Array.new
    @dit_pool = 0
    @essense = 1
    @int = 1
  end
  
  
  
  def roll
    @base_pool += @essense if @ecottv
    @base_pool += @int if (@essense >= 3 && @ecottv)
    @base_pool.downto(1) do 
      @dice << Random.rand(1..10)
    end
    reroll_singles
    while three_of_a_kind
      reroll_singles 
    end if @fmotd
    divine_inspiration
  end
  
  def reroll_singles
    @dice.each_index do |x|
      while ((@dice[x] == 10 && @fhm) || (@dice[x] == 6 && @fhm2))
        reroll(x)
      end
    end
  end
  
  def three_of_a_kind
    temp = Array.new(10){ Array.new } 
    @dice.each.with_index{ |x,ind| temp[x-1] << ind unless @used_successes.include? ind }
    non_succ = temp[0..5].flatten
    [6,7,8,9].each do |x| 
      q = temp[x].count / 3
      if (q > 0)
        ns = non_succ.pop
        @dice[ns] = 10
        q = q-1
        @used_successes << temp[x].pop << temp[x].pop << temp[x].pop
        return true
      end
    end
    return nil
  end

  def divine_inspiration
    
  end
  
  def count_successes

  end

  def reroll(x)
    @rerolls << @dice[x]
    @dice[x] = Random.rand(1..10)
  end
  
  def pool
    (@dice + @rerolls).to_s
  end
  
  def total_pool
    "#{@dice.count}, #{(@dice + @rerolls).count}"
  end
  
  
end

roll1 = Craft.new(10)
roll1.essence = 2
roll1.ecottv = true
roll1.fmotd = true
roll1.fhm2 = true
roll1.roll
puts roll1.pool
puts roll1.total_pool


#      while (@dice.last == 10 || @dice.last == 6)
#        @dice << Random.rand(1..10) if (@charm6s || @charm10s)
#      end
#

#
#@dice_total = 10
#@tally = Array.new(10){0}
#@pool = Array.new
#@charm1 = true
#
#@charm7 = false
#@charm8 = true
#@charm9 = true
#
#@tally_total = 0
#@successes = 0
#
#@dice_total.downto(1) do
#  @pool <<  Random.rand(1..10)
#  while (@pool.last == 10)
#    @pool << Random.rand(1..10)
#  end if @charm1
#end
#
#puts @pool.to_s
#
#@pool.each do |x|
#  @tally[x-1] += 1
#end
#
#puts @tally.to_s
#@tally.each {|x| @tally_total += x} 
#puts @tally_total 
#
#case
#when @charm7
#  @doubles = 7
#when @charm8
#  @doubles = 8
#when @charm9
#  @doubles = 9
#else
#  @doubles = 10
#end
#
#@pool.reject{|x| x < 7}.each {|x| x >= @doubles ? @successes += 2 : @successes += 1}
#puts @successes
#
