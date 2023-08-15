//
//  UserVIewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 15/08/23.
//

import Foundation
import RookUserSDK
import Combine

class UserViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let userManager: RookUserManager = RookUserManager()
  
  @Published var userId: String = ""
  @Published var isUserStored: Bool = false
  @Published var isAddUserEnable: Bool = false
  
  var id: String = ""
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  // MARK:  init
  
  // MARK:  Helpers
  
  func addUser() {
    if !(userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
      userManager.registerRookUser(with: userId) { [weak self] result in
        switch result {
        case .success(let success):
          DispatchQueue.main.async {
            debugPrint("success adding user \(success)")
            self?.id = self?.userId ?? ""
            self?.isUserStored = true
          }
        case .failure(let failure):
          debugPrint("error adding user \(failure)")
        }
      }
    }
  }
  
  func validateUserStored() {
    userManager.getUserIdStored() { [weak self] result in
      switch result {
      case .success(let id):
        self?.id = id
        self?.isUserStored = true
      case .failure(_):
        self?.isUserStored = false
      }
    }
  }
  
  func validateId() {
    $userId.sink { _ in
    } receiveValue: { [weak self] idUser in
      self?.isAddUserEnable = !(idUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }.store(in: &cancellables)

  }
  
}
