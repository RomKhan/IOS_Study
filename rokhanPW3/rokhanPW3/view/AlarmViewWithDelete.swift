//
//  AlarmViewWithDelete.swift
//  rokhanPW3
//
//  Created by Roman on 24.10.2021.
//

import UIKit

class AlarmViewWithDelete : AlarmView {
    /// Функция позволяет рекогнайзеру захватываеть только горизонтальные движения, чтобы можно было продолжать скролить ячейки.
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
