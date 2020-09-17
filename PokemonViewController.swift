import UIKit

var pokemoncaught = PokemonCaught.init(state: [:])

class PokemonViewController: UIViewController {
    
    var url: String!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchPokemonButton: UIButton!
    @IBOutlet var pokemonSprite: UIImageView!
    @IBOutlet var pokemonSpriteBack: UIImageView!
    @IBOutlet var pokemonDescription: UILabel!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPokemon()
        loadSprite()
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        pokemonDescription.text = ""
    }
    
    
    @IBAction func toggleCatch(){
        if  pokemoncaught.state[nameLabel.text!] == nil || pokemoncaught.state[nameLabel.text!] == false {
            catchPokemonButton.setTitle("Release", for: .normal)
            pokemoncaught.state[nameLabel.text!] = true
            UserDefaults.standard.set(true, forKey: nameLabel.text!)
        }
        else {
            catchPokemonButton.setTitle("Catch!", for: .normal)
            pokemoncaught.state[nameLabel.text!] = false
            UserDefaults.standard.set(false, forKey: nameLabel.text!)
        }
        print("Caught: \(pokemoncaught.state)")
    }
    
    
    func loadSprite(){
        URLSession.shared.dataTask(with: URL(string: url)!) { ( data, response, error ) in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonSprite.self, from: data)
                DispatchQueue.main.async {
                    let pokemonSpriteUrl = URL(string: result.sprites.front_default)
                    let pokemonPath = try? Data(contentsOf: pokemonSpriteUrl!)
                    self.pokemonSprite.image = UIImage(data: pokemonPath!)
                    
                    let pokemonSpriteBackUrl = URL(string: result.sprites.back_default)
                    let pokemonBackPath = try? Data(contentsOf: pokemonSpriteBackUrl!)
                    self.pokemonSpriteBack.image = UIImage(data: pokemonBackPath!)
                }
            }
            
            catch let error {
                print(error)
            }
        }.resume()
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
                        
                       if UserDefaults.standard.bool(forKey: self.nameLabel.text!) == true {
                            pokemoncaught.state[self.nameLabel.text!] = true
                       }
                    
                       if pokemoncaught.state[self.nameLabel.text!] == nil || pokemoncaught.state[self.nameLabel.text!] == false {
                           self.catchPokemonButton.setTitle("Catch!", for: .normal)
                       }
                       else {
                           self.catchPokemonButton.setTitle("Release", for: .normal)
                       }
                       
                       
                       for typeEntry in result.types {
                           if typeEntry.slot == 1 {
                               self.type1Label.text = typeEntry.type.name
                           }
                           else if typeEntry.slot == 2 {
                               self.type2Label.text = typeEntry.type.name
                           }
                       }
                   }
                    guard let url2 = URL(string: "https://pokeapi.co/api/v2/pokemon-species/" + (result.name) + "/") else {
                          return
                      }
                      URLSession.shared.dataTask(with: url2) { ( data1, response, error ) in
                          guard let data1 = data1 else {
                              return
                          }
                          print(data1)
                          do {
                              let result = try JSONDecoder().decode(Description.self, from: data1)
                              DispatchQueue.main.async {
                                  let fte = result.flavor_text_entries
                                  for ft in fte {
                                      if ft.language.name == "en" {
                                          self.pokemonDescription.text = ft.flavor_text
                                          break
                                      }
                                  }
                              }
                          }
                          catch let error {
                              print("\(error)")
                          }
                      }.resume()
               }
               catch let error {
                   print(error)
               }
           }.resume()

       }

}
