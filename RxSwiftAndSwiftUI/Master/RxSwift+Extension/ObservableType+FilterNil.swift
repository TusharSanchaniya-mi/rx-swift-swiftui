//
//  ObservableType+FilterNil.swift
//

import Foundation
import RxSwift

extension ObservableType where Element: OptionalType {
    
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    public func filterNil() -> Observable<Element.Wrapped> {
        
        return self.flatMapLatest { element -> Observable<Element.Wrapped> in
            
            guard let value = element.optionalValue else {
                return Observable<Element.Wrapped>.empty()
            }
            
            return Observable<Element.Wrapped>.just(value)
        }
    }
}

public protocol OptionalType {
    
    associatedtype Wrapped
    
    func map<U>(_ mapper: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension OptionalType {
    
    /**
     Proxy property to allow extensions use Optional normally.
     */
    public var optionalValue: Wrapped? {
        
        return self.map { (value: Wrapped) -> Wrapped in
            return value
        }
    }
}
