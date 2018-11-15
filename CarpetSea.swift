//
//  CarpetSea.swift
//  PA5-mcarter6
//  CarpetSea class is the main game asepct of the program. This will initilize the carpet sea with a 2D array of cells
//  and will update a cell when a fishing line is dropped or when a fish appears
//  CPSC 315-01, Fall 2018
//  Programming Assignment #5
//  Class notes were referenced
//  Created by Matt Carter on 10/14/18.
//  Copyright © 2018 Matt Carter. All rights reserved.
//

import Foundation

class carpetSea: CustomStringConvertible {
    var N: Int
    var grid = [[Cell]]()
    var availableFish: [String: Int]
    var description: String {
        var board = ""
        for x in 0..<N {
            for y in 0..<N {
                board += grid[x][y].description + " "
            }
        }
        return board
    }
    
    // Initializes the base carpet sea
    // Parameters: N: the size of the NxN board
    // Returns: n/a
    init(N: Int) {
        self.N = N
        self.availableFish = ["👟": -1, "🐟": 1, "🐠": 3, "🐡": 5, "🦈": 10, "🐋": 12, "🦑": 15, "🧜🏼‍♀️" : 20]
        for a in 0..<N {
            var row = [Cell]()
            for b in 0..<N {
                row.append(Cell(row: a, col: b))
            }
            self.grid.append(row)
        }
    }
    
    // Randomly selects a cell to place a random fish in 
    // Parameters: n/a
    // Returns: n/a
    func randomlyPlaceFish() {
        var fishToPlace = ""
        let cellXPlace = Int.random(in: 0..<N)
        let cellYPlace = Int.random(in: 0..<N)
        let randFish = Int.random(in: 0...100)
        switch (randFish) {
            case 0...5:
                fishToPlace = "👟"
            case 6...35:
                fishToPlace = "🐟"
            case 36...60:
                fishToPlace = "🐠"
            case 61...80:
                fishToPlace = "🐡"
            case 81...90:
                fishToPlace = "🦈"
            case 91...95:
                fishToPlace = "🐋"
            case 96...98:
                fishToPlace = "🦑"
            case 99...100:
                fishToPlace = "🧜🏼‍♀️"
            default:
                print("Error with randFish: \(randFish)")
        }
        grid[cellXPlace][cellYPlace].fish = fishToPlace
    }
    
    // Takes in the button that was tapped and "drops the line" in that cell
    // Parameters: x: A tuple that represents the coordinates of the buttons
    // Returns: n/a
    func dropFishingLine(x: (Int, Int)) {
        grid[x.0][x.1].containsLine = true
    }
    
    // Checks to see if the button clicked has the line dropped and a fish in it. 
    // If so, returns the fish that is caught. If not, returns nothing
    // Parameters: x: A tuple representing the button pressed
    // Returns: String?: The string optional of the fish that might be in the cell 
    func checkFishCaught(x: (Int, Int)) -> String? {
        let tempFish = grid[x.0][x.1].fish
        if grid[x.0][x.1].containsLine && tempFish != nil {
            return grid[x.0][x.1].fish
        } else {
            return nil
        }
    }
    
    // Clears the fish from the cell after each turn
    // Parameters: x: (Int, Int) a tuple that represents the coordinates of the button
    // Returns: n/a
    func clearFish(x: (Int, Int)) {
        grid[x.0][x.1].fish = nil
    }
 
}
