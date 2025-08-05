class GameController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Show upload form or current game state
    if session[:game_state].present?
      @game_data = JSON.parse(session[:game_state])
      @grid = parse_grid(@game_data['state'])
    end
  end
  
  def upload
    if params[:file].present?
      begin
        game_data = parse_file(params[:file])
        session[:game_state] = game_data.to_json
        redirect_to game_path, notice: 'Game uploaded successfully!'
      rescue StandardError => e
        redirect_to game_path, alert: "Error parsing file: #{e.message}"
      end
    else
      redirect_to game_path, alert: 'Please select a file to upload.'
    end
  end
  
  def next_generation
    if session[:game_state].present?
      begin
        game_data = JSON.parse(session[:game_state])
        new_generation = compute_next_generation(game_data)
        session[:game_state] = new_generation.to_json
        
        render json: { 
          success: true, 
          generation: new_generation['generation_number'],
          grid: parse_grid(new_generation['state'])
        }
      rescue StandardError => e
        render json: { success: false, error: e.message }, status: 422
      end
    else
      render json: { success: false, error: 'No game state found' }, status: 422
    end
  end
  
  def reset
    session[:game_state] = nil
    head :ok
  end
  
  private
  
  def parse_file(file)
    content = file.read.force_encoding('UTF-8')
    lines = content.strip.split("\n")
    
    # Validate minimum number of lines
    raise "File must have at least 3 lines" if lines.length < 3
    
    # Parse first line: "Generation N:"
    generation_line = lines[0].strip
    unless generation_line.match?(/^Generation\s+\d+:$/)
      raise "First line must be in format 'Generation N:'"
    end
    generation_number = generation_line.match(/\d+/)[0].to_i
    
    # Parse second line: "R C"
    dimensions_line = lines[1].strip
    unless dimensions_line.match?(/^\d+\s+\d+$/)
      raise "Second line must be in format 'R C' (rows and columns)"
    end
    rows, cols = dimensions_line.split.map(&:to_i)
    
    # Validate we have enough grid lines
    if lines.length < 2 + rows
      raise "File must have #{rows} grid lines after the dimensions line"
    end
    
    # Parse grid lines
    grid_lines = lines[2, rows]
    grid_lines.each_with_index do |line, index|
      unless line.length == cols
        raise "Grid line #{index + 1} has #{line.length} characters, expected #{cols}"
      end
      unless line.match?(/^[*.]+$/)
        raise "Grid line #{index + 1} contains invalid characters. Only '*' and '.' are allowed"
      end
    end
    
    state = grid_lines.join("\n")
    
    {
      generation_number: generation_number,
      rows: rows,
      cols: cols,
      state: state
    }
  end
  
  def parse_grid(state)
    state.split("\n").map do |line|
      line.chars.map { |char| char == '*' }
    end
  end
  
  def compute_next_generation(game_data)
    grid = parse_grid(game_data['state'])
    rows = game_data['rows']
    cols = game_data['cols']
    
    new_grid = Array.new(rows) { Array.new(cols, false) }
    
    (0...rows).each do |row|
      (0...cols).each do |col|
        alive_neighbors = count_alive_neighbors(grid, row, col, rows, cols)
        current_cell = grid[row][col]
        
        # Conway's Game of Life rules
        if current_cell
          # Live cell with 2 or 3 neighbors survives
          new_grid[row][col] = alive_neighbors == 2 || alive_neighbors == 3
        else
          # Dead cell with exactly 3 neighbors becomes alive
          new_grid[row][col] = alive_neighbors == 3
        end
      end
    end
    
    new_state = new_grid.map do |row|
      row.map { |cell| cell ? '*' : '.' }.join
    end.join("\n")
    
    {
      generation_number: game_data['generation_number'] + 1,
      rows: rows,
      cols: cols,
      state: new_state
    }
  end
  
  def count_alive_neighbors(grid, row, col, rows, cols)
    count = 0
    
    (-1..1).each do |dr|
      (-1..1).each do |dc|
        next if dr == 0 && dc == 0 # Skip the cell itself
        
        neighbor_row = row + dr
        neighbor_col = col + dc
        
        # Check bounds
        if neighbor_row >= 0 && neighbor_row < rows &&
           neighbor_col >= 0 && neighbor_col < cols
          count += 1 if grid[neighbor_row][neighbor_col]
        end
      end
    end
    
    count
  end
end
