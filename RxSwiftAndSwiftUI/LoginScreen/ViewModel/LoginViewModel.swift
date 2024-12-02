//
//  LoginViewModel.swift
//  RxSwiftAndSwiftUI
//
//  Created by Mindinventory on 02/12/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class LoginViewModel {
    private let mutableState = BehaviorRelay<State?>(value: nil)
    private let disposeBag = DisposeBag()
    
    private let email: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init() {
        self.bindForButtonState()
        self.bindEmailFieldForError()
        self.bindPasswordFieldForError()
    }
    
    
    private func bindForButtonState() {
        Observable.combineLatest(email.asObservable(), password.asObservable())
            .map { (email, password) in
                !email.isEmpty && !password.isEmpty
            }.map { result in
                State.enableButton(result)
            }
            .bind(to: mutableState)
            .disposed(by: disposeBag)
    }
    
    private func bindEmailFieldForError() {
        
        self.email.asObservable()
            .map { email in
                if email.isNotEmpty && !email.isValidEmailAddress {
                    return .some(State.showEmailError("Please enter valid email address"))
                }
                return State.showEmailError(nil)
            }
            .bind(to: self.mutableState)
            .disposed(by: self.disposeBag)
    }
    
    private func bindPasswordFieldForError() {
        self.password.asObservable()
            .map { password in
                if password.isNotEmpty && !password.isValidEmailAddress {
                    return .some(State.showPasswordError("Password should at least 8 characters, contains 1 upper case and lower case letter and least 1 number"))
                }
                return State.showEmailError(nil)
            }
            .bind(to: self.mutableState)
            .disposed(by: self.disposeBag)
    }
    
    @discardableResult
    private func validateEmail() -> Bool {
        if email.value.isValidUserName {
            return true
        }
        
        mutableState.accept(.showEmailError("Please enter valid email addresss."))
        return false
    }
    
    private func onButtonTapAction() {
        guard self.validateEmail() else {
            return
        }
        print("Thank you validation is successfully done.")
    }
    
}

//MARK: LoginViewModel+ViewModel
extension LoginViewModel: ViewModel {
    
    var state: Observable<State> {
        mutableState.asObservable().filterNil()
    }
    
    func onReceiveEvent(_ event: Event) {
        switch event {
        case .emailDidChange(let email):
            self.email.accept(email)
            break
        case .passwordDidChange( let password):
            self.password.accept(password)
            break
        }
    }
    
    
}

//MARK: LoginViewModel+Event
extension LoginViewModel {
    enum Event: ViewModelEvent {
        case emailDidChange(String)
        case passwordDidChange(String)
    }
}

//MARK: LoginViewModel+State
extension LoginViewModel {
    enum State: ViewModelState {
        case enableButton(Bool)
        case showEmailError(String?)
        case showPasswordError(String?)
    }
}
