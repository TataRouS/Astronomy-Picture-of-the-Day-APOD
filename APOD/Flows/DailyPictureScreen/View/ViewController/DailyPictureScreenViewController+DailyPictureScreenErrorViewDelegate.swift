//
//  DailyPictureScreenViewController+DailyPictureScreenErrorViewDelegate.swift
//  APOD
//
//  Created by Alexander Rubtsov on 21.09.2024.
//

import Foundation

extension DailyPictureScreenViewController: DailyPictureScreenErrorViewDelegate {
    func didTapRetryButton() {
        presenter?.didTapRetryButton()
    }
}
