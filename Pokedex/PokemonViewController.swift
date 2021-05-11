import UIKit

class PokemonViewController: UIViewController {
    var url: String!

    var caught: Bool = true
    
    let userDefault = UserDefaults()
    
    let listview = PokemonListViewController()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var add: UIButton!
    @IBOutlet var image: UIImageView!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        
        caught = UserDefaults.standard.bool(forKey: "caught")
        if caught == false {
            print("was false")
            self.add.setTitle("Release Pokémon", for: UIControl.State.normal)
        }
        else {
            print("was true")
            self.add.setTitle("Add to Pokédex", for: UIControl.State.normal)
        }
        

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
//                    self.image.image = UIImage(data: data)  

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        if !caught {
            print("false toggle")
            caught = true
            self.add.setTitle("Add to Pokédex", for: UIControl.State.normal)
            UserDefaults.standard.set("true", forKey: "caught")
            
        }
        else {
            print("true toggle")
            caught = false
            self.add.setTitle("Release Pokémon", for: UIControl.State.normal)
            UserDefaults.standard.set("false", forKey: "caught")
            
        }
    }
    
}
