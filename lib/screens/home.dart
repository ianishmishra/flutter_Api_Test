import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/services/user_api.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<User> users = [];
  List<User> filteredUsers = [];
  List<User> showUsers = [];
  bool _isFetching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchUsers();
        await Future.delayed(const Duration(seconds: 1));
      },
      color: Colors.amber,
      backgroundColor: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rest Api Call"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                // Add your filter functionality here
                // For example, you can open a bottom sheet, drawer, or dialog to apply filters
                // Navigator.of(context).push(...);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // print(value);
                  filterUsers(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name, email, or phone',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                  itemCount: showUsers.length,
                  itemBuilder: (context,index){
                    final user = showUsers[index];
                    final email = user.email;
                    final phonenumber = user.phone;
                    final gender = user.gender;
                    final cell = user.cell;
                    final nat = user.nationality;
                    final color = gender == 'male' ? Colors.blueAccent : Colors.pink;
                    final name = user.fullname;
                    final imageurl = user.image.large;
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Stack(

                        children: [ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(imageurl),
                            backgroundColor: Colors.transparent,
                          ),
                          //title: Text(name,style: const TextStyle(fontWeight:FontWeight.bold,color: Colors.white70 ),),
                          title: Text(name,style: const TextStyle(fontWeight:FontWeight.bold,color: Colors.white70 ),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: $email'),
                              // Text('Age: ${user.age}'),
                              // Text('DOB: ${user.age}'),
                              // Text('Location: ${user.age}'),
                              Text('Phone: $phonenumber'),
                              Text('Cell: $cell'),
                              Text('Gender: $gender'),
                              Text('Nationality: $nat'),
                            ],
                          ),
                          tileColor: color,
                        ),

                      Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                      ),
                      ],
                    ),
                    );
                  },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isFetching ? null : fetchUsers,
          child: _isFetching ? const CircularProgressIndicator(
            color: Colors.white,
          ) : const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Future<void> fetchUsers() async{
    _searchController.clear();
    if (_isFetching) return;
    setState(() {
      _isFetching = true;
    });
    try {
      final response = await UserApi.fetchUsers();
      setState(() {
        users = response!;
        // print("users => "+users.toString());
        filteredUsers = users;
        // print("filtered Users => "+filteredUsers.toString());
        showUsers = users;

      });
    } finally {
      // TODO
      setState(() {
        _isFetching = false;
      });
    }
  }

  void filterUsers(String value) {
    setState(() {
      filteredUsers = users.where((user) {
        final name = user.fullname.toLowerCase();
        final email = user.email.toLowerCase();
        final phone = user.phone.toLowerCase();
        return name.contains(value.toLowerCase()) ||
            email.contains(value.toLowerCase()) ||
            phone.contains(value.toLowerCase());
      }).toList();
      showUsers = filteredUsers;
    });
  }

  // Future<void> fetchUsers() async{
  //   if (_isFetching) return;
  //   setState(() {
  //     _isFetching = true;
  //   });
  //   print("Fetch Users Function Call");
  //   const url = "https://randomuser.me/api/?results=10";
  //   final uri = Uri.parse(url);
  //   try {
  //     final response = await http.get(uri);
  //     final json = jsonDecode(response.body);
  //     final results = json['results'] as List<dynamic>;
  //     final transformed = results.map((user) {
  //       final name = UserName(
  //         title: user['name']['title'],
  //         first: user['name']['first'],
  //         last: user['name']['last'],
  //       );
  //       return User(
  //         cell: user['cell'],
  //         email: user['email'],
  //         phone: user['phone'],
  //         gender: user['gender'],
  //         nationality: user['nat'],
  //         name: name,
  //       );
  //     }).toList();
  //     setState(() {
  //       users = transformed;
  //     });
  //     print('fetching users completed');
  //   } catch (e) {
  //     print('Error fetching users: $e');
  //   } finally {
  //     setState(() {
  //       _isFetching = false;
  //     });
  //   }
  // }


}