//
//  ViewController.swift
//  ObserverPatterns
//
//  Created by Sergio on 25.12.22.
//

import UIKit

// Метод в протоколе который отправляет notify с помощью update
protocol Observer: AnyObject {
    func update(subject: NotificationCenters)
}

// вращает сам себе бизнес логику(someBusinessLogic) и хранит наблюдателей (observers) за ним, можем подписаться (subscribe) отписаться (unsubscribe) или отправить сообщение (notify)
class NotificationCenters {
    var state: Int = {
        return Int(arc4random_uniform(10))
    }()

    private lazy var observers = [Observer]()

    func subscribe(_ observer: Observer) {
        print(#function)
        observers.append(observer)
    }

    func unsubscribe(_ observer: Observer) {
        if let index = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: index)
            print(#function)
        }
        print(#function)
    }

    func notify() {
        print(#function)
        observers.forEach( {$0.update(subject: self)})
    }

    func someBusinessLogic() {
        print(#function)
        state = Int(arc4random_uniform(10))
        notify()
    }
}

// обьекты которые подписаны на Observer, они будут принимать сообщения или реагировать на изменение так как напишем в теле функции update
class ContenteObserverA: Observer {
    func update(subject: NotificationCenters) {
        print("ConreteObserverA: \(subject.state)")
    }
}

class ViewController: UIViewController, Observer {

    let notificationCenter = NotificationCenters()
    let observer1 = ContenteObserverA()

    // MARK: - UIElements

    private var outOneLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "OUT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let updateAction: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let subscribeSwitch: UISwitch = {
        let subscribeSwitch = UISwitch()
        subscribeSwitch.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        subscribeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return subscribeSwitch
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups

    func setupHierarchy() {
        view.addSubview(outOneLabel)
        view.addSubview(updateAction)
        view.addSubview(subscribeSwitch)
    }

    //принимаeт сообщения или реагирует на изменение
    func update(subject: NotificationCenters) {
        outOneLabel.text = "State subject: \(subject.state)"
    }

    @objc func buttonTapped() {
        notificationCenter.someBusinessLogic()
    }

    @objc func toggle() {
        if subscribeSwitch.isOn {
            notificationCenter.subscribe(self)//подписались
            notificationCenter.subscribe(observer1)
        } else {
            notificationCenter.unsubscribe(self)//отписались
            notificationCenter.unsubscribe(observer1)
        }
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            outOneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            outOneLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),

            updateAction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateAction.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            updateAction.widthAnchor.constraint(equalToConstant: 140),
            updateAction.heightAnchor.constraint(equalToConstant: 50),

            subscribeSwitch.topAnchor.constraint(equalTo: updateAction.bottomAnchor, constant: 150),
            subscribeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
