import 'package:credixo/providers/dashboardProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<DashboardProvider>(context).userName;
    final userEmail = Provider.of<DashboardProvider>(context).userEmail;
    return Scaffold(

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black87,
                  Colors.black54,
                  Colors.grey[600]!,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,color: Colors.white,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Profile',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ],
                ),
                SizedBox(height: 10,),
                // User Profile Section
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFECB3), Colors.grey[800]!, Colors.grey[900]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(userEmail, style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text("Edit",
                                  style:
                                      TextStyle(fontSize: 15, color: Colors.white)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                tileContainer(
                    iconPath: "paymentHistory.png",
                    title: "Payment History",
                    subtitle: "Ongoing payments, Recent transactions"),
                tileContainer(
                    iconPath: "requestPayment.png",
                    title: "Request Payment",
                    subtitle: "Request to payment, nearest..."),
                tileContainer(
                    iconPath: "contactList.png",
                    title: "Your Contact List",
                    subtitle: "Your saved contacts"),
                tileContainer(
                    iconPath: "paymentMode.png",
                    title: "Payment Mode",
                    subtitle: "Saved Cards, Wallet"),
                tileContainer(
                    iconPath: "address.png",
                    title: "Address",
                    subtitle: "Permanent address"),
                tileContainer(
                    iconPath: "notification.png",
                    title: "Notification",
                    subtitle: "Offers, Order tracking messages"),
                tileContainer(
                    iconPath: "settings.png",
                    title: "Settings",
                    subtitle: "App settings, Dark mode"),
                tileContainer(
                    iconPath: "profileSettings.png",
                    title: "Profile Settings",
                    subtitle: "Full name, Password"),
                tileContainer(
                    iconPath: "term.png",
                    title: "Term & Conditions",
                    subtitle: "T&C for use of platform"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customButton(
                      iconPath: "logout.png",
                      title: "Logout",
                      color: Colors.red[200]!,
                      callback: () async{
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      }
                    ),
                    customButton(
                      iconPath: "help.png",
                      title: "Customer Care",
                      color: Colors.green[200]!,
                      callback: () {},
                    ),
                  ],
                )
                // tileContainer(iconPath: "help.png", title: "Help / Customer Care", subtitle: "Customer support, FAQs"),
                // tileContainer(iconPath: "logout.png", title: "Logout", subtitle: ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tileContainer({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/profileIcons/$iconPath",
                scale: 17,
                color: Colors.white,
              ),
              SizedBox(
                width: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget customButton({
    required String iconPath,
    required String title,
    required Color color,
    required VoidCallback callback, // Using VoidCallback for better type safety
  }) {
    return InkWell(
      onTap: callback, // No semicolon here
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/profileIcons/$iconPath",
              scale: 20,
              color: Colors.black,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
