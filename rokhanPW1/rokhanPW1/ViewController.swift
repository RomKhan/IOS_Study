// Сделаны все пункты ТЗ
// От себя дабавлено: изменение размеров и позиции вьювсов.
// Спасибо за проверку!

import UIKit

class ViewController: UIViewController {

    // Все кастомные аутлетыю
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var buttonColor: UIButton!
    @IBOutlet weak var buttonPosition: UIButton!
    @IBOutlet weak var buttonColorAndPosition: UIButton!
    
    // Время анимации (изначально ноль, тк програму необходимо настроить).
    var duration = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваю кнопки программно
        ButtonSettings(button: buttonColor, red: 79, green: 173, blue: 122)
        ButtonSettings(button: buttonPosition, red: 7, green: 14, blue: 161)
        ButtonSettings(button: buttonColorAndPosition, red: 183, green: 0, blue: 148)
        
        // Рандомная настройка вьювсов в самом началею
        changeColorButtonPressed(self)
        duration = 1
    }
    
    // Функция настройки кнопки (создана для читаемости кода).
    func ButtonSettings(button: UIButton, red: Int, green: Int, blue: Int) {
        button.backgroundColor = UIColor(displayP3Red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
        button.layer.shadowOffset = .zero
        button.layer.shadowColor = CGColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 1
        button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
        button.layer.cornerRadius = 10
        
        // Ставлю кнопку выше всех вьевсов, чтобы они ее не закрывали.
        super.view.bringSubviewToFront(button)
    }
    
    // Событие нажатия на кнопку "Push me!".
    // Здесь сочитаются две другие кнопки.
    @IBAction func ColorAndPositionChange(_ sender: Any) {
        changeColorButtonPressed(sender)
        ChangePositionButtonPressed(self)
    }
    
    // Событие нажатия на кнопку с позицией.
    // Здесь я рандомно меняю позицию(и размер) вьювсов, но так, чтобы они дркг на друга не накладывались.
    // Для этого я создаю массив с занятыми областями, и каждую новую область проверяю со на пересечение со всеми предыдущими.
    @IBAction func ChangePositionButtonPressed(_ sender: Any) {
        var usedAreas: [(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)] = []
        for view in views {
            var xAxis: CGFloat!
            var yAxis: CGFloat!
            var width: CGFloat!
            var height: CGFloat!
            
            repeat {
                let size = Int.random(in: 40...200)
                xAxis = CGFloat(arc4random_uniform(UInt32(self.view.frame.width-50)))
                yAxis = CGFloat(arc4random_uniform(UInt32(self.view.frame.height-100)))
                width = CGFloat(size)
                height = CGFloat(size)
                
                var flagOfCorrectSelection = true
                for area in usedAreas {
                    if !(area.x >= xAxis+width) && !(area.y >= yAxis+height) && !(xAxis >= area.x+area.width) && !(yAxis >= area.y+area.height) {
                        flagOfCorrectSelection = false
                    }
                }
                if flagOfCorrectSelection {break}
            } while (true)
            
            // Анимация перехода от одной позиции(и размеру) к другой.
            // Было решено не накладывать ограничения на время нажатия кнопки, тк в данном случае это не мешает (в отличии от цвета).
            UIView.animate(withDuration: duration, animations: {
                view.frame = CGRect(x: xAxis, y: yAxis, width: width, height: height)
            })
            usedAreas.append((x: xAxis, y: yAxis, width: width, height: height))
        }
    }
    
    // Событие нажатия на кнопку с цветомю
    // Здесь происходит смена цвета (больший часть ТЗ тут).
    @IBAction func changeColorButtonPressed(_ sender: Any) {
        let button = sender as? UIButton
        button?.isEnabled = false
        
        var set = Set<UIColor>()
        if views == nil {return}
        while set.count < views.count {
        set.insert(UIColor(rgb: Int.random(in: 0x000000...0xFFFFFF)))}
        UIView.animate(withDuration: duration, animations: {
            for view in self.views {
            view.layer.cornerRadius = view.frame.height/CGFloat(Int.random(in: 5...20))
                view.backgroundColor = set.popFirst()
            }
            }) { completion in
                button?.isEnabled = true
            }
    }
}

// Расширение класса UIColor.
// Теперь можно преобразовывать HEX в RGB (пункт 10 ТЗ).
extension UIColor {
   convenience init(rgb: Int) {
       self.init(
        red: CGFloat(rgb >> 16 & 0xFF)/255,
        green: CGFloat(rgb >> 8 & 0xFF)/255,
        blue: CGFloat(rgb & 0xFF)/255,
        alpha: CGFloat(1)
       )
   }
}

