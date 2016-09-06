class DicePool

	attr_reader :successes, :motes, :gxp, :sxp, :wxp, :wp, :charms, :data

	def initialize( charms = Hash.new, data = Hash.new )
		charms.is_a?(Hash) ? @charms = charms : @charms = Hash.new
		data.is_a?(Hash) ? @data = data : @data = Hash.new
		@data[:log] ||= false
		@data[:essence] ||= 1
		@data[:intelligence] ||= 1
		@data[:craft_skill]||= 1
		@data[:base_pool] ||= @data[:intelligence] + @data[:craft_skill]
		@charms[:excellency] ||= false
		@charms[:ecottv] ||= false
		@charms[:fhm] ||= false
		@charms[:fhm2] ||= false
		@charms[:smf] ||= false
		@charms[:smf2] ||= false
		@charms[:smf3] ||= false
		@charms[:fmotd] ||= false
		@charms[:uif] ||= false
		@charms[:mem] ||= false
		@charms[:dit] ||= false
		@charms[:hmu] ||= false
		@excellency = @data[:intelligence] + @data[:craft_skill]
		@rerolls = Array.new
		@pool = Array.new
		@showing = Hash.new
		@used_successes = Array.new
		@uif = 0
		@total_successes = 0
		self.base_pool = @data[:base_pool]
		log "#{@pool.count} size pool = #{@pool.to_s}"
		log "showing = #{@showing.sort.to_s}"
		log "uif = #{@uif}"
		log "rerolls = #{@rerolls.to_s}"
		log "used_successes = #{@used_successes}"
		log "total_successes = #{@total_successes}"
	end

	def log(*p)
		puts p if @data[:log]
	end

	def successes
		@total_successes
	end

	def base_pool=(base)
		if @charms[:excellency]
			base += excellency
		end
		log "base_pool = #{base} including excellency"
		base.downto(1) do 
			add_die
		end
		uif if @charms[:uif]
		charmset
		ecottv if @charms[:ecottv]
		dit if @charms[:dit]
		@total_successes += @uif if @charms[:uif]
		cost
	end

	def cost
		
	end

	def excellency
		dice = @excellency
		if charms[:mem]
			dice += @data[:craft_skill]
		end
		return dice
	end

	def dit
		log "total before DIT = #{@total_successes}"
		pre_successes = @total_successes
		used_hmu = !@charms[:hmu]
		new_dice = pre_successes / 3
		used_succ = new_dice * 3
		log "used hmu = #{used_hmu}"
		log "DIT-Dice #{new_dice}"
		loop do
			if (@total_successes - used_succ) >= 3
				new_dice += 1
				log "added 1 DIT Dice"
				used_succ += 3
			end
			if (@total_successes - pre_successes) >= 3
				new_dice += 3
				log "used HMU"
				used_hmu = true
			end unless used_hmu
			add_die
			charmset
			new_dice -= 1

			break if new_dice < 1
		end

	end

	def charmset
		while fmotd 
			fhm
		end if @charms[:fmotd]
		fhm
	end

	def ecottv
		pool = data[:essence]
		if data[:essence] > 2
			pool += data[:intelligence]
		end
		log "ecottv pool = #{pool}"
		pool.downto(1) do
			add_die
		end	
		@total_successes += 1
		charmset
	end

	def add_die
		@pool << Random.rand(1..10)
		update_tally(@pool.count - 1)
	end

	def fhm
		reroll_dice = []
		loop do
			reroll_dice += @showing[10] if (@charms[:fhm] && @showing[10])
			reroll_dice += @showing[6]  if (@charms[:fhm2] && @showing[6])
			log "fhm reroll_dice = #{reroll_dice.to_s}" unless reroll_dice == []
			break if reroll_dice.count == 0
			reroll_dice.each { |die| reroll(die)  }
			reroll_dice.clear
			
		end
		
	end

	def fmotd
		non_succ = Array.new
		(1..6).each {|x| non_succ = non_succ + @showing[x] if @showing[x]}
		[7,8,9,10].each do |x|
			if @showing[x] 
				temp = @showing[x] - @used_successes
				q = temp.count / 3 
				if ( q > 0 )
					log "fmotd = #{x}" 
					ns = non_succ.pop
					last = @pool[ns]
					@pool[ns] = 10
					update_tally(ns, last)
					@used_successes << temp.pop << temp.pop << temp.pop
					return true
				end
			end
		end
		return nil
	end


	def uif
		temp = Array.new
		[7,8,9,10].each do |x|
			temp += @showing[x] if @showing[x]
		end
		@uif = @data[:essence] + temp.count
	end

	def reroll(die)
    	@rerolls << @pool[die]
    	@pool[die] = Random.rand(1..10)
    	update_tally(die, @rerolls.last)
 	end


	def update_tally(pos, last=nil)
		unless @showing[@pool[pos]].is_a? Array 
			@showing[@pool[pos]] = Array.new
		end
		@showing[last].delete_if{|x| x == pos } if last
		@showing[@pool[pos]] << pos
		update_success(@pool[pos])
		log @showing.to_s
		
	end

	def update_success(face)
		case face
		when 7
			@charms[:smf3] ? @total_successes += 2 : @total_successes += 1
		when 8
			@charms[:smf2] ? @total_successes += 2 : @total_successes += 1
		when 9
			if @charms[:smf]
				@total_successes += 2
			else
				@total_successes += 1
			end
		when 10
			@total_successes += 2
		end
		
	end


end
