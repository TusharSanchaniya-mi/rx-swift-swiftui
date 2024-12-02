//
//  ObservableType+Empty.swift
//

import Foundation
import RxSwift

extension ObservableType where Element == String {
    
    public func filterNotEmpty() -> Observable<Element> {
        
        filter { (text) -> Bool in
            !text.isEmpty
        }
    }
    
    public func filterEmpty() -> Observable<Element> {
        
        filter { (text) -> Bool in
            text.isEmpty
        }
    }
    
    public func mapEmpty() -> Observable<Bool> {
        
        map { (text) -> Bool in
            text.isEmpty
        }
    }
    
    public func mapNotEmpty() -> Observable<Bool> {
        
        map { (text) -> Bool in
            !text.isEmpty
        }
    }
}
