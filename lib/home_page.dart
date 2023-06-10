import 'package:flutter/material.dart';
import 'package:my_flutter_contact_list_app/contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = List.empty(growable: true);

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  
  var selectedIndex;



  
  var _foundUsers = [];

  @override
  void initState() {
    _foundUsers = contacts;
    super.initState();
  }


  void _runFilter(String enteredKeyword){
    var results = [];
    if (enteredKeyword.isEmpty){
      results = contacts;
    }else{
      results = contacts.where((user) => user.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contacts List"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const  EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Contact Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(height: 10),
               TextField(
                controller: contactController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                    hintText: "Contact Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(height: 10),
        
              TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: "Search", suffixIcon: Icon(Icons.search)
              ),
            ),
        
        
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    //
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    if (name.isNotEmpty && contact.isNotEmpty){
                      setState(() {
                        nameController.text="";
                        contactController.text = "";
                        _foundUsers.add(Contact(name: name, contact: contact));  
                      });  
                    }
                        
                    //
                  }, child: const Text("Save")),
                  ElevatedButton(onPressed: () {
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    if (name.isNotEmpty && contact.isNotEmpty){
                      setState(() {
                        nameController.text="";
                        contactController.text = "";
                        _foundUsers[selectedIndex].name = name;
                        _foundUsers[selectedIndex].contact = contact;
                        selectedIndex = -1;  
                      });  
                    }
                        
                        
                        
                        
                  }, child: const Text("Update"))
                ],
              ),
              const SizedBox(height: 10),
              _foundUsers.isEmpty ? const Text("No Contact Yet...", style: TextStyle(fontSize: 22)) :
              Expanded(
                child: ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => getRow(index)),
              ),
            ],
          ),
        ));
  }

  Widget getRow(int index){
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: index%2==0 ? Colors.deepPurpleAccent : Colors.purple, foregroundColor: Colors.white ,child: Text(_foundUsers[index].name[0], style: const TextStyle(fontWeight: FontWeight.bold),)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(_foundUsers[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(_foundUsers[index].contact)
        ],),
        trailing: SizedBox(
          width: 70,
          child:  Row(children: [
            InkWell(onTap: (){

              nameController.text = _foundUsers[index].name;
              contactController.text = _foundUsers[index].contact;
              setState(() {
                selectedIndex = index;
              });

            },child: const Icon(Icons.edit)),
            InkWell(onTap:() {
              setState(() {
                _foundUsers.removeAt(index);
              });
            }, child: const Icon(Icons.delete))
          ],),
        ),
      ),
    );
  }



}
