//
//  RollResult.swift
//  Storyteller
//
//  Created by Jared Lindsay on 2/6/21.
//

/// An enum representing the different outcomes of a roll.
enum RollResult {
  case botch(Int)
  case failure
  case success(Int)
  case none
}
