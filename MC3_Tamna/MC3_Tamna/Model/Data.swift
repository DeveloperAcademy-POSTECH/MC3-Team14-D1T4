//
//  Data.swift
//  testpr
//
//  Created by heojaenyeong on 2022/07/14.
//

import Foundation
import SwiftUI

struct Quiz : Decodable, Identifiable {
    var id: Int
    var question: String
    var answer: [String]
    var rightAnswerIndex: Int
}

struct AnimalQuizzes: Decodable, Identifiable{
    var id: Int
    var quizzes: [Quiz]
}

struct QuizDao {

    private let totalAnimalQuizzes: [AnimalQuizzes] = loadQuizzes("quizzes.json")
    
    private let errorQuizzes: AnimalQuizzes = AnimalQuizzes(id: 0, quizzes: [Quiz(id: 0, question: "에러입니다", answer: ["에러", "에러", "에러", "에러"], rightAnswerIndex: 1)])
    
    private let animalDict = ["polarbear": 0, "elephant": 1, "dolphin": 2, "tiger": 3, "panda": 4]
    
    public func getTotalAnimalQuizzess() -> [AnimalQuizzes] {
        return self.totalAnimalQuizzes
    }
    
    public func getQuizzessByName(animalName: String) -> AnimalQuizzes {
        let index = findIndex(animalName: animalName)
        switch index {
        case .success(let index):
            return totalAnimalQuizzes[index]
        case .failure:
            return errorQuizzes
        }
    }
    
    public func findIndex(animalName: String) -> Result<Int, QuizDaoError> {
        let index: Int? = animalDict[animalName]
        if index == nil {
            return .failure(.cannotFoundAnimalName)
        }
        return .success(index!)
    }
    
    enum QuizDaoError: Error {
        case cannotFoundAnimalName
    }
    
}

func loadQuizzes<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
