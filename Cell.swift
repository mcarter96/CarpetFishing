//
//  Cell.swift
//  PA5-mcarter6
//  Cell Class will be the type that carpetSea calls for each of it's options/buttons
//  It initalizes a row and col which are the coordinates in the 2D array of cells in carpet Sea
//  Cell also holds whether there is a fish or fishing line in each cell
//  CPSC 315-01, Fall 2018
//  Programming Assignment #5
//  Class notes were referenced
//  Created by Matt Carter on 10/14/18.
//  Copyright © 2018 Matt Carter. All rights reserved.
//



import Foundation

class Cell: CustomStringConvertible {
    var row: Int
    var col: Int
    var containsLine: Bool
    var fish: String?
    var description: String {
        return "\(fish ?? "") at position \(row), \(col)"
    }
    
    // Initializes the cell
    // Parameters: row: the size of rows, col: the size of the columns
    // Returns: n/a
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.containsLine = false
        self.fish = nil
    }
    
}
