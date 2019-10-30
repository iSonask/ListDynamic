//
//  ContentView.swift
//  ListViewDynamic
//
//  Created by keval dattani on 25/10/19.
//  Copyright © 2019 keval dattani. All rights reserved.
//

import SwiftUI

struct Pokemon :Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let color: Color
}

struct ContentView: View {
    
    @State var pokemonList = [
        Pokemon(name: "Charmander", type: "Fire", color: .red),
        Pokemon(name: "Squirtle", type: "Water", color: .gray),
        Pokemon(name: "Bulbasaur", type: "Grass", color: .green),
        Pokemon(name: "Pikachu", type: "Electric", color: .yellow),
    ]
    @State private var text: String = ""
    
    var body: some View {
        NavigationView{

            List(pokemonList) { pokemon in
                NavigationLink(destination: DetailView(poke: pokemon)) {
                    HStack {
                        Text(pokemon.name)
                        Spacer()
                        Text(pokemon.type).foregroundColor(pokemon.color)
                    }
                }
            }.navigationBarTitle(Text("Pokemon"))
                .navigationBarItems(leading: Button(action: { self.alert() }) { Text("Add") })
        }
        
    }
    
     private func delete(with indexSet: IndexSet) {
         indexSet.forEach { pokemonList.remove(at: $0) }
     }

    
    private func alert() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        showAlert(alert: alert)
    }
    
    func showAlert(alert: UIAlertController) {
        alert.addTextField { (textField) in
            textField.placeholder = "Enter"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertaction) in
            let textField = alert.textFields![0]
            print(textField.text)
            self.pokemonList.append(Pokemon(name: textField.text!, type: "New", color: .red))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertaction) in
            
        }))
        
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}


struct DetailView: View {
    var poke: Pokemon
    var body: some View {
        ZStack{
            poke.color.edgesIgnoringSafeArea(.all)
            Text(poke.name)
        }
            
    }
}
