//
//  ExerciseClass.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 23/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//


// To parse the JSON, add this file to your project and do:
//
//   let exercise = try? newJSONDecoder().decode(Exercise.self, from: jsonData)

import Foundation


typealias Exercises = [Exercise]

class Exercise: Codable {
    let idFitnessExercises: Int
    let execiseName: String
    let repeats: Int
    let sets: String
    let howToVideo: String
    
    enum CodingKeys: String, CodingKey {
        case idFitnessExercises = "id_fitness_exercises"
        case execiseName = "execiseName"
        case repeats = "repeats"
        case sets = "sets"
        case howToVideo = "howToVideo"
    }
    
    init(idFitnessExercises: Int, execiseName: String, repeats: Int, sets: String, howToVideo: String) {
        self.idFitnessExercises = idFitnessExercises
        self.execiseName = execiseName
        self.repeats = repeats
        self.sets = sets
        self.howToVideo = howToVideo
        
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
        
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
        
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
                
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
            
        }
        
    }
    
    func exercisesTask(with url: URL, completionHandler: @escaping (Exercises?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
        
    }
}
