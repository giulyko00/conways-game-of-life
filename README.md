# Conway's Game of Life - Rails App

A fully functional Conway's Game of Life web application built with Ruby on Rails, featuring user authentication, file upload, server-side computation, and interactive visualization.

## 🎮 Features

- **User Authentication** - Secure login/registration with Devise
- **File Upload** - Upload Game of Life patterns in text format
- **Interactive Visualization** - Beautiful grid display with CSS styling
- **Dual-Mode Gameplay**:
  - **Manual Mode** - Step through generations one by one
  - **Auto-Play Mode** - Continuous simulation with 1-second intervals
- **Server-Side Computation** - All generation calculations performed on server
- **AJAX Updates** - Smooth updates without page reloads
- **Pattern Library** - Includes classic Conway patterns (Glider, Pulsar, etc.)

## 🛠️ Tech Stack

- **Ruby on Rails** 8.0.2
- **SQLite** (development) / **PostgreSQL** (production)
- **Devise** for authentication
- **Bootstrap 5** for responsive UI
- **Turbo Rails** for AJAX functionality

## 🚀 Local Development

### Prerequisites
- Ruby 3.3+
- Rails 8.0+
- SQLite3

### Setup
```bash
# Clone the repository
git clone https://github.com/giulyko00/conways-game-of-life.git
cd conways-game-of-life

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate

# Start the server
rails server
```

Visit `http://localhost:3000` to use the application.

## 📁 File Format

Upload text files in this format:
```
Generation 0:
ROWS COLUMNS
.***..
..*...
..***.
```

## 🌐 Heroku Deployment

### Prerequisites
- Heroku CLI installed
- Heroku account

### Deploy Steps
```bash
# Login to Heroku
heroku login

# Create Heroku app
heroku create your-app-name

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:mini

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate

# Open app
heroku open
```

## 🎯 Pattern Examples

The app includes several classic Conway's Game of Life patterns:

- **Glider** - Moves diagonally across the grid
- **Blinker** - Simple 2-period oscillator
- **Toad** - 2-period oscillator
- **Beacon** - 2-period oscillator
- **Pulsar** - Beautiful 3-period oscillator
- **Pentadecathlon** - 15-period oscillator
- **Glider Gun** - Generates infinite gliders
- **R-Pentomino** - Chaotic pattern that evolves for 1000+ generations

## 🎮 How to Play

1. **Register/Login** to your account
2. **Click "Start New Game"**
3. **Upload a pattern file** or use one of the provided examples
4. **Choose your mode**:
   - **Manual**: Click "Next Generation" to step through
   - **Auto-Play**: Click "Start Auto Play" for continuous simulation
5. **Reset** anytime to start over

## 🏗️ Architecture

- **Session-based state** - Game state stored in Rails sessions
- **Server-side logic** - All Conway's rules computed on backend
- **AJAX communication** - Frontend fetches new generations via JSON API
- **Responsive design** - Works on desktop and mobile

## 📝 License

MIT License - feel free to use and modify!
