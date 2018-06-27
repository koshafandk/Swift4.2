/*:
 [Table of contents](Table%20of%20contents) • [Previous page](@previous) • [Next page](@next)

 # Dynamic member lookup

 [SE-0195](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md "Introduce User-defined 'Dynamic Member Lookup' Types") introduces the `@dynamicMemberLookup` attribute for type declarations.

 A variable of a `@dynamicMemberLookup` type can be called with _any_ property-style accessor (using dot notation) — the compiler won’t check if a member with the given name exists or not. Instead, the compiler translates such accesses into calls of a subscript accessor that gets passed the member name as a string.

 The goal of this feature is to facilitate interoperability between Swift and dynamic languages such as Python. The [Swift for Tensorflow](https://github.com/tensorflow/swift) team at Google, who has driven this proposal, implemented a Python bridge that makes it possible to [call Python code from Swift](https://github.com/tensorflow/swift/blob/master/docs/PythonInteroperability.md). Pedro José Pereira Vieito packaged this up in a SwiftPM package called [PythonKit](https://github.com/pvieito/PythonKit).

 SE-0195 isn’t required to enable this interoperability, but it makes the resulting Swift syntax much nicer. It’s worth noting that SE-0195 only deals with property-style member lookup (i.e. simple getters and setters with no arguments). A second "dynamic callable" proposal for a dynamic method call syntax is still in the works.

 Although Python has been the primary focus of the people who worked on the proposal, interop layers with other dynamic languages like Ruby or JavaScript will also be able to take advantage of it.

 And it’s not limited to this one use case, either. Any type that currently has a string-based subscript-style API could be converted to dynamic member lookup style. SE-0195 shows a `JSON` type as an example where you can drill down into nested dictionaries using dot notation.
 */
@dynamicMemberLookup
enum JSON {
    case number(Double)
    case string(String)
    case array([JSON])
    case dictionary([String: JSON])
    
    var numberValue: Double? {
        guard case .number(let n) = self else {
            return nil
        }
        return n
    }
    
    var stringValue: String? {
        guard case .string(let s) = self else {
            return nil
        }
        return s
    }
    
    subscript(index: Int) -> JSON? {
        guard case .array(let arr) = self,
            arr.indices.contains(index) else
        {
            return nil
        }
        return arr[index]
    }
    
    subscript(key: String) -> JSON? {
        guard case .dictionary(let dict) = self else {
            return nil
        }
        return dict[key]
    }
    
    // Important
    subscript(dynamicMember key: String) -> JSON? {
        guard case .dictionary(let dict) = self else {
            return nil
        }
        return dict[key]
    }
}
/*:
 Implementing `subscript(dynamicMember:)` allows us to use simple dot syntax.
 */
let jsonString = """
    [
        {
            "name": {
                "first": "Tim",
                "last": "Cook"
            }
        }
]
"""
let json = JSON.array([.dictionary(["name": JSON.dictionary(["first": JSON.string("Tim"), "last": JSON.string("Cook")])])])

json[0]?.name?.first?.stringValue
json[0]?.name?.last?.stringValue
/*:
 Early we had to write something like this: `json[0]?.["name"]?.["last"]?.stringValue`
 */

/*:
 [Table of contents](Table%20of%20contents) • [Previous page](@previous) • [Next page](@next)
 */
