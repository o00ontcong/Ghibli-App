//
//  GhibliService.swift
//  GhibliSwiftUIApp
//
//  Created by ThanhCong on 7/11/25.
//

import Foundation

protocol GhibliService: Sendable {
    func fetchFilms() async throws -> [Film]
    func fetchPerson(from URLString: String) async throws -> Person
}
