# DreamWisp

An Actionscript 3 framework for developing games that I started in 2013 (when I was 16 years old). Building this helped me learn core programming concepts and best practices.

## The Game and ScreenManager

The `Game` class contains everything you might need to run a game: the game loop's `update()` and `render()` functions, the game save system, the user input, and the `ScreenManager`.

The `ScreenManager` is where all the action happens. Create custom screens extending the `GameScreen` or `MenuScreen` classes. When you want to display or transition to a new screen, add it to a `ScreenManager` using the `pendScreen` method. `ScreenManager` will handle any screen transitions and execute the logic and rendering for its top-most active screen.

## Entity

Extend `Entity` to create game objects that exist during gameplay, like the player's spaceship, enemy goons, projectiles, or powerups. Each `Entity` can have various components like physics, hit box, and view which determine its behavior. The `EntityManager` present in each screen handles the adding and removal of entities.

## Built-in Functionality

DrewamWisp includes some useful high-level features such as:

- 2D platformer physics and tile-based environments
- A particle system, which uses a circular buffer to efficiently create and destroy multiple particles
- An audio system to handle multiple sounds, smooth music fade transitions, and volume control