//
//  Country.swift
//  relations
//
//  Created by nhatlee on 10/18/17.
//

import Vapor
import FluentProvider
import HTTP

final class Country: Model {
    let storage = Storage()
    
    /// The name of the country
    var name: String
    
    /// one to one relation to capital
    var capital_id : Identifier?
    
    /// Creates a new Country
    init(name: String) {
        self.name = name
        
    }
    
    /// Initializes the Country from the
    /// database row
    init(row: Row) throws {
        name = try row.get("name")
        capital_id = try row.get("capital_id")
    }
    // Serializes the Country to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("capital_id", capital_id)
        return row
    }
    
    func states() throws -> [State] {
        let states: Siblings<Country, State, Pivot<Country, State>> = siblings()
        return try states.all()
    }
}

// MARK: Fluent Preparation
extension Country: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Countries
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.foreignId(for: Capital.self, optional: true, unique: false, foreignIdKey: "capital_id", foreignKeyName: "capital_id")
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
// How the model converts from / to JSON.
extension Country: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("capital_id", capital_id)
        return json
    }
}

// MARK: HTTP
// This allows Post models to be returned
// directly in route closures
extension Country: ResponseRepresentable { }
