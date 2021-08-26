require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new('player', 'R', '@board') }

  describe '#initialize' do
    context 'when using default initialization' do
      
      it "has name 'player'" do
        expect(player.name).to eq('player')
      end

      it 'has piece R' do
        expect(player.piece).to eq('R')
      end
    end
  end

  describe '#update_player_name' do
    context 'when updating player name' do

      it 'should update player name to Tommy' do
        expect(player.update_player_name('Tommy')).to eq('Tommy')
      end
    end
  end
end

describe Board do
  subject(:board) { described_class.new }
  subject(:board_arr) { board.instance_variable_get(:@board) }

  describe '#initialize' do
    context 'when board is initalized' do
      it 'should be an instance of Board' do
        expect(board).to be_an_instance_of(Board)
      end

      it 'has an array @board with size of 7' do
        expect(board_arr.size).to eq(7)
      end

      it 'should have the row numbers as the last array' do
        expect(board_arr.last).to eq([*1..7])
      end
    end
  end

  describe '#message' do
    context 'when a message is passed' do

      it 'should put the message' do
        msg = 'Test message'
        expect(STDOUT).to receive(:puts).once
        board.message(msg)
      end
    end
  end

  describe '#number_input_range' do
    context 'when number input is out of range' do
      before do
        allow(board).to receive(:puts)
        allow(board).to receive(:input).and_return(10)
      end

      it 'should get user input and return message' do
        msg = 'Invalid input.  Please enter a value between 1 and 7'
        expect(board.number_input_range('Test', 1, 7)).to eq(msg)
      end
    end

    context 'when number input is within range ' do
      before do
        allow(board).to receive(:puts)
        allow(board).to receive(:gets).and_return(5)
        allow(board).to receive(:number_input_range).with('Test', 1, 7).and_return(5)
      end

      it 'should get user input and return input' do
        expect(board.number_input_range('Test', 1, 7)).to eq(5)
      end
    end
  end

  describe '#column_free?' do
    context 'when column is full' do
      before do
        allow(board).to receive(:puts)
        msg = 'Column 1 is full.  Please select another column'
        allow(board).to receive(:column_free?).with(1).and_return(msg)
      end

      it 'should return column full message' do
        msg = 'Column 1 is full.  Please select another column'
        expect(board.column_free?(1)).to eq(msg)
      end
    end

    context 'when column is not full' do
      before do
        allow(board).to receive(:puts)
        allow(board).to receive(:column_free?).with(1).and_return(true)
      end

      it 'should return column' do
        expect(board.column_free?(1)).to eq(true)
      end
    end
  end

  describe '#board_full?' do
    context 'when board is not full' do
      before do
        allow(board).to receive(:board_full?).and_return(false)
      end

      it 'should return false' do
        expect(board.board_full?).to eq(false)
      end
    end
  end
  
end

describe ConnectFour do
  subject(:game) { described_class.new }
  let(:player_x) { game.instance_variable_get(:@player_x) }
  let(:player_y) { game.instance_variable_get(:@player_y) }
  let(:board) { game.instance_variable_get(:@board) }
  let(:current_player) { game.instance_variable_get(:@current_player) }

  describe '#initialize' do
    context 'when game is initalized' do
      before do
        allow(STDOUT).to receive(:puts)
      end

      it 'should create an instance of Player class called player_x' do
        expect(player_x).to be_an_instance_of(Player)
      end

      it 'should create an instance of Player class called player_y' do
        expect(player_y).to be_an_instance_of(Player)
      end

      it 'should create an instance of board' do
        expect(board).to be_an_instance_of(Board)
      end

      it 'has @current player as @player_x' do
        expect(player_x).to eq(current_player)
      end
    end
  end

  describe '#player_names' do
    context 'when assigning player names' do
      before do
        allow(STDOUT).to receive(:puts)
        allow(game).to receive(:player_names)
      end

      it 'has player name Tommy' do
        player_x.update_player_name('Tommy')
        expect(player_x.name).to eql('Tommy')
      end
    end
  end

  describe '#switch_current_player' do
    context 'when switching players' do
      before do
        allow(STDOUT).to receive(:puts)
        allow(game).to receive(:switch_current_player).with(current_player).and_return(player_y)
      end

      it 'has @current player as @player_x' do
        expect(current_player).to eq(player_x)
      end

      it 'switches the current player to player_y' do
        expect(game.switch_current_player(current_player)).to eq(player_y)
      end
    end
  end
end
