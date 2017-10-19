//
//  State.swift
//  relations
//
//  Created by nhatlee on 10/19/17.
//

import Vapor
import FluentProvider
import HTTP

final class State: Model {
    let storage = Storage()
    
    /// The name of the State
    var name: String
    
    /// Creates a new State
    init(name: String) {
        self.name = name
    }
    
    /// Initializes the State from the
    /// database row
    init(row: Row) throws {
        name = try row.get("name")
    }
    // Serializes the State to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        return row
    }
}

// MARK: Fluent Preparation
extension State: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Countries
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
// How the model converts from / to JSON.
extension State: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        return json
    }
}

// MARK: HTTP
// This allows Post models to be returned
// directly in route closures
extension State: ResponseRepresentable { }
