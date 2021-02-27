//  main.swift
//  lLyon_Project02
//  Created by Elizabeth Lyon on 2/15/21.

import Foundation

var myDictionary = [String:String]() //can be anything

class Program {
    init(){ //drives the code
        var reply = ""
        var keepRunning = true
        while (keepRunning) {
            reply = Ask.AskQuestions(questionText: "Hello, Please select from the options below: \n1) View all passwords \n2) View a single password \n3) Delete a password \n4) Add a password \nType '1', '2', '3', or '4' : ", acceptedReply: ["1", "2", "3", "4"])

            if (reply == "1") {
                //calls the all function
                all()
                }
            else if (reply == "2"){
                //calls the single function
                single()
                }
            else if (reply == "3"){
                //calls the delete function
                delete()
            }
            else if (reply == "4"){
                //calls the add function
                add()
            }
            else if (reply == "5" || reply == "0") {
                keepRunning = false
                break
            }
        }
            
            func all(){
                //outputs all keys and values
                for key in myDictionary.keys{
                    print("Key: \(key)")
                }
            }
            
            func single() {
                //output single password based on the valid key
                print("You have selected SINGLE \nPlease enter a key: ")
                let userKey = readLine()
                //if key exists ask for passphrase
                if myDictionary.keys.contains(userKey!){
                    print("Now enter a passphrase: ")
                    let userPassphrase = readLine()
                    myDictionary[userKey!] = passwordDecrypt(passEncrypt : userPassphrase!)
                    print("The password is: " + passwordDecrypt(passEncrypt : userPassphrase!)) //force unwrap
                }
                else{
                    print("Error. Invalid input.")
                }
            }
        }

    //fucntion that outputs all keys with their cooresponding value
    func all(){
        for key in myDictionary.keys{
            print("Key: \(key)")
        }
    }
    
    //function that outputs a single password for the cooresponding key
    func single() {
        //ask for key
        print("You have selected SINGLE \nPlease enter a key: ")
        let userKey = readLine()
        //if key exists ask for passphrase
        if myDictionary.keys.contains(userKey!){
            print("Now enter a passphrase: ")
            let userPassphrase = readLine()
            myDictionary[userKey!] = passwordDecrypt(passEncrypt : userPassphrase!)
            print("The password is: " + passwordDecrypt(passEncrypt : userPassphrase!)) //force unwrap
        }
        //if doesnt exist
        else{
            print("Error. Invalid input.")
        }
    }
    
    //function that deletes a specified object given a key
    func delete() {
        //ask for key
        print("You have selected DELETE \nPlease enter a key: ")
        let userKey = readLine()
        //if exists then delete
        if myDictionary.keys.contains(userKey!){
            myDictionary.removeValue(forKey: userKey!)
            print("YAY! You have successfully deleted that password")
        }
        //else doesnt exists
        else{
            print("Error. Invalid input.")
        }
    }
    
    //function that adds a password to the dictionary
    func add() {
        //ask for name to add
        print("You have selected ADD \nPlease enter a name to add: ")
        let userKey = readLine()
        //ask for passowrd
        print("Now eneter a password: ")
        let userPassword = readLine()
        //ask for passphrase
        print("Now eneter a passphrase: ")
        let userPassphrase = readLine()
        let add = userPassword! + userPassphrase!
        myDictionary[userKey!] = passwordEncrypt(passEncrypt: add)
    }
    
    //function to reverse user input
    func reverse(reverseStr input : String) -> String{
        //returns the users string input as reveresed
        return String(input.reversed())
    }
       
    //function to translate
    func translate(i : Character, intToTranslate : Int) -> Character {
        if let ascii = i.asciiValue{
            var intFinal = ascii
            if (ascii >= 97 && ascii <= 122){
                intFinal = ((ascii - 97) + UInt8(intToTranslate) % 26) + 97
            }
            else if (ascii >= 65 && ascii <= 98){
                intFinal = ((ascii - 65) + UInt8(intToTranslate) % 26) + 65
            }
            return Character(UnicodeScalar(intFinal))
        }
        return Character("")
    }
    
    //function to unscramble the cipher code
    func unscrambleTranslator(i : Character, intToTranslate : Int) -> Character {
            if let ascii = i.asciiValue {
                var intFinal = ascii
                if (ascii >= 97 && ascii <= 122) {
                    let temp = ascii - UInt8(intToTranslate)
                    if(temp < 97){
                        intFinal +=  26
                    }
                    else if (temp > 122){
                        intFinal -= 26
                    }
                    intFinal = (((intFinal - 97) - UInt8(intToTranslate)) % 26) + 65
                }
                else if (ascii >= 65 && ascii <= 90) {
                    let temp = ascii - UInt8(intToTranslate)
                    if (temp < 65){
                        intFinal += 26
                    }
                    else if ( temp > 90){
                        intFinal -= 26
                    }
                    intFinal = (((intFinal - 65) - UInt8(intToTranslate)) % 26) + 65
                }
                return Character(UnicodeScalar(intFinal))
            }
        print(i)
        return Character("")
    }
    
    //function for passowrd encryption
    func passwordEncrypt(passEncrypt : String) -> String {
        var encypted = ""
        let shift = passEncrypt.count
        for letter in passEncrypt{
            encypted += String(translate(i : letter, intToTranslate : shift))
        }
        return encypted
    }

    //function for passowrd decryption
    func passwordDecrypt(passEncrypt : String) -> String {
        var strUnscramble = ""
        let shift = passEncrypt.count
        for letter in passEncrypt{
            strUnscramble += String(unscrambleTranslator(i : letter, intToTranslate: shift))
        }
        return strUnscramble
    }
  }


//recursive class
class Ask {
    static func AskQuestions(questionText output: String, acceptedReply inputArr: [String], caseSen: Bool = false) -> String {
        print(output) //ask question
        
        guard let response = readLine() else{
            //if they didnt type anything at all
            print("Invalid input")
            //recursive function call
            return AskQuestions(questionText: output, acceptedReply: inputArr)
        }
        
        //verify that the response is acceptable or empty
        if (inputArr.contains(response) || inputArr.isEmpty) {
            return response
        }
        else{
            print("Error. Invalid input")
            return AskQuestions(questionText: output,
                                acceptedReply: inputArr)
        
        }
    }
}

//creates instance of object p and store it in the Program class
let p = Program()
    
//write to JSON
func writeJSON(myDictionary : Dictionary<String,String>) -> Void {
    do{
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, //file path within your computer
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("mySimplePasswordManager.json")

        try JSONSerialization.data(withJSONObject: myDictionary)
            .write(to: fileURL) //writing to the object we created
        }
    catch{
        print(error)
    }
}

//read from JSON
func readJSON() -> Dictionary<String,String> {
    do
    {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, //file path within your computer
                 appropriateFor: nil,
                 create: false)
            .appendingPathComponent("mySimplePasswordManager.json")

        let data = try Data(contentsOf: fileURL)
        let dictionary = try JSONSerialization.jsonObject(with: data)
    }
    catch
    {
        print(error)
    }
  return myDictionary
}



