//
//  ViewModel.swift
//  RxSwiftAndSwiftUI
//
//  Created by Mindinventory on 02/12/24.
//

import Foundation
import RxSwift

protocol ViewModel {
    
    associatedtype State: ViewModelState
    associatedtype Event: ViewModelEvent
    
    var state: Observable<State> { get }
    
    func onReceiveEvent(_ event: Event)
}

protocol ViewModelState {}

protocol ViewModelEvent {}

final class AnyViewModel<State: ViewModelState, Event: ViewModelEvent>: ViewModel, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var state: Observable<State>
    
    // MARK: - Private Properties
    
    private let eventhandler: (Event) -> Void
    
    // MARK: - Init
    
    init<WrappedViewModel: ViewModel>(
        _ viewModel: WrappedViewModel
    ) where WrappedViewModel.State == State, WrappedViewModel.Event == Event {
        self.state = viewModel.state
        self.eventhandler = viewModel.onReceiveEvent
    }
    
    // MARK: - Public Method
    
    func onReceiveEvent(_ event: Event) {
        eventhandler(event)
    }
}
