/*:
 [Table of contents](Table%20of%20contents) • [Previous page](@previous) • [Next page](@next)

 # Enumerating enum cases

 [SE-0194 — Derived Collection of Enum Cases](https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md "Derived Collection of Enum Cases"): The compiler can automatically generate an `allCases` property for enums, providing you with an always-up-to-date list of enum cases. All you have to do is conform your enum to the new `CaseIterable` protocol.
 */
enum Terrain: CaseIterable {
    case water
    case forest
    case desert
    case road
}

Terrain.allCases
Terrain.allCases.count

/*:
 Note that the automatic synthesis only works for enums without associated values — because associated values mean an enum can have a potentially infinite number of possible values. aHowever if you want you can add it yourself:
 */
enum Car: CaseIterable {
    static var allCases: [Car] {
        return [.ford, .toyota, .jaguar, .bmw, .porsche(convertible: false), .porsche(convertible: true)]
    }
    
    case ford, toyota, jaguar, bmw
    case porsche(convertible: Bool)
}

Car.allCases
/*:
 Important: You need to add `CaseIterable` to the original declaration of your enum rather than an extension in order for the `allCases` array to be synthesized. This means you can’t use extensions to retroactively make existing enums conform to the protocol.
 */

/*:
 [Table of contents](Table%20of%20contents) • [Previous page](@previous) • [Next page](@next)
 */
