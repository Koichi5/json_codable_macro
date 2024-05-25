@attached(member, names: named(init), named(toJson), named(fromJson), named(CodingKeys))
public macro JsonCodable() = #externalMacro(module: "JsonCodableMacroPlugin", type: "JsonCodableMacro")
