import SwiftUI

public extension Bundle {
    
    func localized(locale: Locale) -> Bundle {
        let bundlePath = path(forResource: locale.identifier, ofType: "lproj") 
            ?? path(
                forResource: locale.identifier.split(separator: "_").map(String.init).first ?? locale.identifier, 
                ofType: "lproj"
            )
        return (bundlePath.map(Bundle.init(path:)) ?? self) ?? self
    }
}

public extension LocalizedStringKey {

    private typealias FormattedVarArgs = (CVarArg, Formatter?)
    
    var localized: String? {
        localized()
    }
    
    var key: String? {
        Mirror(reflecting: self).descendant("key") as? String
    }
    
    /// Returns the localized value of this `LocalizedStringKey` using reflection.
    /// - Important: SwiftUI `format` for interpolated values is ignored.
    func localized(locale: Locale = .current, bundle: Bundle = .main, tableName: String? = nil, explicitKey: String? = nil) -> String? {        
        let bundle = bundle.localized(locale: locale)
        let mirror = Mirror(reflecting: self)
        let value = mirror.descendant("key") as? String
        let key: String? = explicitKey ?? value
        
        guard let key else {
            return nil
        }
        
        var formattedVarArgs: [FormattedVarArgs] = []
        
        if let arguments = mirror.descendant("arguments") as? Array<Any> {
            for argument in arguments {
                let argumentMirror = Mirror(reflecting: argument)
                
                if let storage = argumentMirror.descendant("storage") { 
                    let storageMirror = Mirror(reflecting: storage)
                    
                    if let formatStyleValue = storageMirror.descendant("formatStyleValue") {
                        let formatStyleValueMirror = Mirror(reflecting: formatStyleValue)

                        guard var input = formatStyleValueMirror.descendant("input") as? CVarArg else {
                            continue
                        }
                        
                        let formatter: Formatter? = nil
                        
                        // TODO: Create relevant formatters
                        if let _ = formatStyleValueMirror.descendant("format") {
                            // Cast input to String
                            input = String(describing: input) as CVarArg
                        }
                        
                        formattedVarArgs.append((input, formatter))
                    } else if let storageValue = storageMirror.descendant("value") as? FormattedVarArgs {
                        formattedVarArgs.append(storageValue)
                    }
                }
            }
        }
        
        let string = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value ?? "", comment: "")
        
        if mirror.descendant("hasFormatting") as? Bool ?? false {
            return String.localizedStringWithFormat(
                string, 
                formattedVarArgs.map { arg, formatter in
                    formatter?.string(for: arg) ?? arg
                }
            )
        } else {
            return string   
        }
    }
}
