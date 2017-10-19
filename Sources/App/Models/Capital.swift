//
//  Capital.swift
//  relations
//
//  Created by nhatlee on 10/18/17.
//

import Vapor
import FluentProvider
import HTTP

final class Capital: Model {
    let storage = Storage()
    
    /// The name of the Capital
    var name: String
    
    /// one to one relation to country
    var country_id : Identifier?
    
    /// Creates a new Capital
    init(name: String) {
        self.name = name
        
    }
    
    /// Initializes the Capital from the
    /// database row
    init(row: Row) throws {
        name = try row.get("name")
        country_id = try row.get("country_id")
    }
    // Serializes the Capital to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("country_id",country_id)
        return row
    }
}

// MARK: Fluent Preparation
extension Capital: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Countries
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.foreignId(for: Country.self, optional: true, unique: false, foreignIdKey: "country_id", foreignKeyName: "country_id")
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
// How the model converts from / to JSON.
extension Capital: JSONConvertible {
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
extension Capital: ResponseRepresentable { }
