import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct JsonCodableMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(ActorDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) || declaration.is(StructDeclSyntax.self) else {
            return []
        }
        
        let variableDecls: [(pattern: IdentifierPatternSyntax, typeAnnotation: TypeAnnotationSyntax)]
        variableDecls = declaration.memberBlock.members.compactMap {
            guard let decl = $0.decl.as(VariableDeclSyntax.self) else { return nil }
            
            guard let binding = decl.bindings.first else { return nil }
            
            guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else { return nil }
            guard let typeAnnotation = binding.typeAnnotation else { return nil }
            
            return (pattern, typeAnnotation)
        }
        let initDecl = DeclSyntax(stringLiteral: 
        """
        init(
            \(variableDecls.map { "\($0.pattern)\($0.typeAnnotation)" }.joined(separator: ",\n"))
        ) {
            \(variableDecls.map { "self.\($0.pattern) = \($0.pattern)" }.joined(separator: "\n"))
        }
        """
        )
        
        let toJsonDecl = DeclSyntax(stringLiteral: """
        public func toJson() -> String? {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(self) else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        }
        """)

        let fromJsonDecl = DeclSyntax(stringLiteral: """
        public func fromJson(_ json: String) -> Self? {
            let decoder = JSONDecoder()
            guard let data = json.data(using: .utf8),
                  let object = try? decoder.decode(Self.self, from: data) else {
                return nil
            }
            return object
        }
        """)
        
        let codingKeysCases = variableDecls.map { decl -> String in
            let pattern = decl.pattern.identifier.text
            let snakeCaseName = pattern.toSnakeCase() ?? pattern
            return "case \(pattern) = \"\(snakeCaseName)\""
        }.joined(separator: "\n")

        let codingKeysEnumDecl = DeclSyntax(stringLiteral: """
        public enum CodingKeys: String, CodingKey {
            \(codingKeysCases)
        }
        """)
        
        return [
            initDecl,
            toJsonDecl,
            fromJsonDecl,
            codingKeysEnumDecl
        ]
    }
}

@main
struct JsonCodablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        JsonCodableMacro.self,
    ]
}

extension String {
    func toSnakeCase() -> String? {
        guard !isEmpty else { return nil }

        var result = ""
        var shouldAddUnderscore = false

        for character in self {
            if character.isUppercase {
                if shouldAddUnderscore {
                    result += "_"
                }
                result += character.lowercased()
                shouldAddUnderscore = true
            } else {
                result += String(character)
                shouldAddUnderscore = true
            }
        }

        return result
    }
}
