//
//  Data.swift
//  testpr
//
//  Created by heojaenyeong on 2022/07/14.
//

import Foundation

struct Quiz: Decodable, Identifiable {
    var id: Int//id값은 파싱을 위해 넣은거니 신경 쓰지 말아주세요
    var question: String
    var answers: [String]
    var rightAnswerIndex: Int
}

struct AnimalQuizzes: Decodable, Identifiable {
    var id: Int//id값은 파싱을 위해 넣은거니 신경 쓰지 말아주세요
    var quizzes: [Quiz]
}

struct QuizDao {
    private let totalAnimalQuizzes: [AnimalQuizzes] = loadQuizzes("quizzes.json") //json 파싱해와서 totalAnimalQuizzes라는 변수에저장,private let으로 설정되어있어 구조체 밖에서 접근할수 없음
    private let errorQuizzes: AnimalQuizzes = AnimalQuizzes(id: 0, quizzes: [Quiz(id: 0, question: "에러퀴즈!", answers: ["에러0","에러1","에러2","에러3"], rightAnswerIndex: 1)])//에러 발생시 출력해줄 에러 출력용객체 생성
    private let animalDict = ["polarbear": 0 ,"elephant": 1, "dolphin": 2, "tiger": 3, "panda":4]//동물이름으로 totalAnimalQuizzess에 접근할 인덱스를 찾기 위해 선언한 Dictionary
    
    
    public func getTotalAnimalQuizzess() -> [AnimalQuizzes] {
        return self.totalAnimalQuizzes
    }//totalAnimalQuizzess가 private let으로 선언되어있어 구조체 밖에서 바로 접근할수 없지만 이렇게 getTotalAnimalQuizzess 메소드를 통해 접근 가능
    
    public func getQuizzessByName(animalName: String) -> AnimalQuizzes {
        let index : Int? = animalDict[animalName]
        guard index != nil else { return getQuizzessByIndex(index: 404) }//만약 동물이름을 찾을수 없다면 getQuizzessByIndex에서 에러 퀴즈를 반환하기 위해 out of range오류가 일어날수 있게 404를 인덱스 값으로 해서 getQuizzessByIndex 반환
        return getQuizzessByIndex(index: index!)
    }// 사용 예시 : quizDao.getQuizzessByName(animalName: "dolphin").quizzes[0].question -> 돌고래들은 어디서 살까요?
    
    public func getQuizzessByIndex(index: Int) -> AnimalQuizzes {
        if -1 < index && index < totalAnimalQuizzes.count {
            return totalAnimalQuizzes[index]
        } else {
            return errorQuizzes
        }
    }// 사용 예시 : quizDao.getQuizzessByIndex(index:2).quizzes[0].question -> 돌고래들은 어디서 살까요?
    
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
