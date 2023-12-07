//
//  Result+Additions.swift
//
//
//  Created by Brad Grzesiak on 9/27/23.
//

import Foundation

public extension Result where Failure == any Error {
    init(catching body: () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch let error {
            self = .failure(error)
        }
    }
}
