### Scoring in Bowling

A game of bowling consists of 10 *frames*, each of which contains 1 - 3 *throws*.  The score for a throw is recoded as follows:

#### In frames 1 - 9

* "-": this throw is a *gutterball*, and worth 0 points.
* "1"-"9": this throw is worth its value in points
* "/": this throw is called a *spare*.  It occurs when the second throw of a frame knocks down the remaining pins, and in the first 9 frames, is worth `10 - the frame's first throw + the next throw` in points.  In the last frame, it is only worth `10 - the frame's first throw` points.
* "X": this throw is called a *strike*.  This is worth 10 points, plus the values of the next two throws.

#### In frame 10

In frame 10, you can throw up to three balls.  I suggest checking out Wikipedia, because the scoring rules can get very complicated.

### Code Kata

This kata contains two files: `bowling.rb` and `bowling_test.rb`.  `bowling.rb` defines a class called `Bowling`, with two methods: `initialize` and `score`.  `initialize` will receive a string of bowling throws (between 11 and 21).  `score` should return the value for that game.  Your task is to implement those two methods so that when:

    ruby bowling_test.rb

is run, all of the tests it contains pass.