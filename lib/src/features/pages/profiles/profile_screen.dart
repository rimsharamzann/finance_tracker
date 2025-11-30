import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 170.0,
              floating: true,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.blue.shade200,
                          child: const CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                                'https://img.freepik.com/free-psd/expressive-woman-gesturing_23-2150198673.jpg?ga=GA1.1.1086731780.1714360195&semt=ais_hybrid'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid ??
                                      '')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }
                                // print(snapshot.data);
                                var profileData = snapshot.data?.data();
                                String name = profileData?['name'] ?? 'Unknown';
                                String email = profileData?['email'] ?? 'empty';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Colors.white),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              children: [
                GestureDetector(
                  child: _buildListItem(Icons.person_add_alt, 'Edit Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()));
                  },
                ),
                Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey.shade50,
                ),
                _buildListItem(Icons.notifications_none_sharp, 'Notifications'),
                Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey.shade50,
                ),
                _buildListItem(Icons.settings, 'Setting'),
                Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey.shade50,
                ),
                _buildListItem(Icons.headset_mic_outlined, 'Support'),
                Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey.shade50,
                ),
                InkWell(
                  onTap: () {
                    logoutUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor: Colors.red[50],
                        child: const Icon(Icons.logout_outlined,
                            color: Colors.red),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Logout",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Future<void> logoutUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
    } catch (e) {
      // print('Error ..........: $e');
    }
  }

// String getName(List<QueryDocumentSnapshot<Object?>> docs) {
//
// }
}
