class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14){[]}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, idx|
      4.times { cup << :stone } unless [6, 13].include? idx
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless (0..5).cover?(start_pos) || (7..12).cover?(start_pos)
    raise "Invalid starting cup" if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)

    stones = @cups[start_pos]
    @cups[start_pos] = []

    place_pos = start_pos
    until stones.empty?
      place_pos += 1
      place_pos = 0 if place_pos > 13

      if place_pos == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif place_pos == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[place_pos] << stones.pop
      end
    end

    render
    next_turn(place_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].count == 1
      :switch
    else
      ending_cup_idx# make_move(ending_cup_idx, current_player_name)
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    (0..5).all? { |e| @cups[e].empty? } || (7..12).all? { |e| @cups[e].empty? }
  end

  def winner
    player1_count = @cups[6].count
    player2_count = @cups[13].count

    if player1_count == player2_count
      :draw
    else
      player1_count > player2_count ? @name1 : @name2
    end
  end
end
