import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference tokenCollection =
  FirebaseFirestore.instance.collection('all_tokens');
  final CollectionReference livestreamCollection =
  FirebaseFirestore.instance.collection('live_videos');

  // update userdata
  Future updateUserData(
      String fullName, String email, String password, String userType) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'fcmTokens':[],
      'groups': [],
      'group_details': [],
      'profilePic': '',
      'userType': userType
    });
  }

  // create group
  Future createGroup(
      String? userName, String? groupName, String? usertype) async {
    var mapadmin = new Map<String, dynamic>();

    mapadmin['userId'] = uid;
    mapadmin['userName'] = userName;

    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'groupAdmins': FieldValue.arrayUnion([mapadmin]),
      'groupRequest': [],
      'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    var mapfounder = new Map<String, dynamic>();

    mapfounder['userId'] = "fBK1mHAjDUOrS5BFO95dxkwxWl62";
    mapfounder['userName'] = "Founder";

    if (usertype == 'Leader') {
      await groupDocRef.update({
        'groupAdmins': FieldValue.arrayUnion([mapfounder]),
        'members': FieldValue.arrayUnion(
            ["fBK1mHAjDUOrS5BFO95dxkwxWl62" + '_' + "Founder"]),
        // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
        'groupId': groupDocRef.id
      });
    } else {
      await groupDocRef.update({
        // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
        'groupId': groupDocRef.id
      });
    }

    var mapold = new Map<String, dynamic>();

    mapold['group_id'] = groupDocRef.id;
    mapold['group_exist'] = true;
    mapold['group_read'] = true;
    mapold['group_write'] = true;

    if (usertype == 'Leader') {
      DocumentReference userDocRef2 =
          userCollection.doc("fBK1mHAjDUOrS5BFO95dxkwxWl62");
      await userDocRef2.update({
        'groups': FieldValue.arrayUnion([groupDocRef.id]),
        'group_details': FieldValue.arrayUnion([mapold]),
      });
    }

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id]),
      'group_details': FieldValue.arrayUnion([mapold]),
    });
  }

  Future createGroupPublic(
      String? userName, String? groupName, String? usertype) async {
    var mapadmin = new Map<String, dynamic>();

    mapadmin['userId'] = uid;
    mapadmin['userName'] = userName;

    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'groupAdmins': FieldValue.arrayUnion([mapadmin]),
      'groupRequest': [],
      'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });



    var mapfounder = new Map<String, dynamic>();

    mapfounder['userId'] = "fBK1mHAjDUOrS5BFO95dxkwxWl62";
    mapfounder['userName'] = "Founder";

    if (usertype == 'Leader') {
      await groupDocRef.update({
        'groupAdmins': FieldValue.arrayUnion([mapfounder]),
        'members': FieldValue.arrayUnion(
            ["fBK1mHAjDUOrS5BFO95dxkwxWl62" + '_' + "Founder"]),
        // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
        'groupId': groupDocRef.id
      });
    } else {
      await groupDocRef.update({
        // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
        'groupId': groupDocRef.id
      });
    }

    // DocumentReference tokenDocRef = await tokenCollection.add({
    //   'groupId': groupDocRef.id,
    //   'main_notification': [],
    // });

    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        var mapold = new Map<String, dynamic>();

        mapold['group_id'] = groupDocRef.id;
        mapold['group_exist'] = true;
        mapold['group_read'] = true;
        mapold['group_write'] = true;

        DocumentReference userDocRef = userCollection.doc(result.id);
        // userDocRef.update({'groups':""});


        userDocRef.update({
          'groups': FieldValue.arrayUnion([groupDocRef.id]),
          'group_details': FieldValue.arrayUnion([mapold]),
        });

        groupDocRef.update({

          'members': FieldValue.arrayUnion([result.id + '_' + result.data()['fullName']]),
          // 'members': FieldValue.arrayUnion([result.id + '_' + "result.data()['fullName']"]),

        });


        // var maptoken = new Map<String, dynamic>();
        //
        // maptoken['userId'] = result.id;
        // // maptoken['userToken'] = FieldValue.arrayUnion(result.data()['fcmTokens']);
        //
        // tokenDocRef.update({
        //   'main_notification': FieldValue.arrayUnion([maptoken]),
        // });
      });
    });


    // var mapold = new Map<String, dynamic>();
    //
    // mapold['group_id'] = groupDocRef.id;
    // mapold['group_exist'] = true;
    // mapold['group_read'] = true;
    // mapold['group_write'] = true;
    //
    // if (usertype == 'Leader') {
    //   DocumentReference userDocRef2 =
    //   userCollection.doc("fBK1mHAjDUOrS5BFO95dxkwxWl62");
    //   await userDocRef2.update({
    //     'groups': FieldValue.arrayUnion([groupDocRef.id]),
    //     'group_details': FieldValue.arrayUnion([mapold]),
    //   });
    // }
    //
    // DocumentReference userDocRef = userCollection.doc(uid);
    // return await userDocRef.update({
    //   'groups': FieldValue.arrayUnion([groupDocRef.id]),
    //   'group_details': FieldValue.arrayUnion([mapold]),
    // });



  }

  // Future createGroupPublic(
  //     String? userName, String? groupName, String? usertype) async {
  //   var mapadmin = new Map<String, dynamic>();
  //
  //   mapadmin['userId'] = uid;
  //   mapadmin['userName'] = userName;
  //
  //   DocumentReference groupDocRef = await groupCollection.add({
  //     'groupName': groupName,
  //     'groupIcon': '',
  //     'admin': userName,
  //     'groupAdmins': FieldValue.arrayUnion([mapadmin]),
  //     'groupRequest': [],
  //     'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
  //     //'messages': ,
  //     'groupId': '',
  //     'recentMessage': '',
  //     'recentMessageSender': ''
  //   });
  //
  //
  //
  //   var mapfounder = new Map<String, dynamic>();
  //
  //   mapfounder['userId'] = "fBK1mHAjDUOrS5BFO95dxkwxWl62";
  //   mapfounder['userName'] = "Founder";
  //
  //   if (usertype == 'Leader') {
  //     await groupDocRef.update({
  //       'groupAdmins': FieldValue.arrayUnion([mapfounder]),
  //       'members': FieldValue.arrayUnion(
  //           ["fBK1mHAjDUOrS5BFO95dxkwxWl62" + '_' + "Founder"]),
  //       // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
  //       'groupId': groupDocRef.id
  //     });
  //   } else {
  //     await groupDocRef.update({
  //       // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
  //       'groupId': groupDocRef.id
  //     });
  //   }
  //
  //   DocumentReference tokenDocRef = await tokenCollection.add({
  //     'groupId': groupDocRef.id,
  //     'main_notification': [],
  //   });
  //
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((result) {
  //
  //       var mapold = new Map<String, dynamic>();
  //
  //       mapold['group_id'] = groupDocRef.id;
  //       mapold['group_exist'] = true;
  //       mapold['group_read'] = true;
  //       mapold['group_write'] = true;
  //
  //       DocumentReference userDocRef = userCollection.doc(result.id);
  //       // userDocRef.update({'groups':""});
  //
  //
  //       userDocRef.update({
  //         'groups': FieldValue.arrayUnion([groupDocRef.id]),
  //         'group_details': FieldValue.arrayUnion([mapold]),
  //       });
  //
  //       groupDocRef.update({
  //
  //         'members': FieldValue.arrayUnion([result.id + '_' + result.data()['fullName']]),
  //         // 'members': FieldValue.arrayUnion([result.id + '_' + "result.data()['fullName']"]),
  //
  //       });
  //
  //
  //       var maptoken = new Map<String, dynamic>();
  //
  //       maptoken['userId'] = result.id;
  //       // maptoken['userToken'] = FieldValue.arrayUnion(result.data()['fcmTokens']);
  //
  //       tokenDocRef.update({
  //         'main_notification': FieldValue.arrayUnion([maptoken]),
  //       });
  //     });
  //   });
  //
  //
  //   // var mapold = new Map<String, dynamic>();
  //   //
  //   // mapold['group_id'] = groupDocRef.id;
  //   // mapold['group_exist'] = true;
  //   // mapold['group_read'] = true;
  //   // mapold['group_write'] = true;
  //   //
  //   // if (usertype == 'Leader') {
  //   //   DocumentReference userDocRef2 =
  //   //   userCollection.doc("fBK1mHAjDUOrS5BFO95dxkwxWl62");
  //   //   await userDocRef2.update({
  //   //     'groups': FieldValue.arrayUnion([groupDocRef.id]),
  //   //     'group_details': FieldValue.arrayUnion([mapold]),
  //   //   });
  //   // }
  //   //
  //   // DocumentReference userDocRef = userCollection.doc(uid);
  //   // return await userDocRef.update({
  //   //   'groups': FieldValue.arrayUnion([groupDocRef.id]),
  //   //   'group_details': FieldValue.arrayUnion([mapold]),
  //   // });
  //
  //
  //
  // }



  Future AddTokenFcmUser(String tokens) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> fcmtokens = await userDocSnapshot['fcmTokens'];

    if (fcmtokens.contains(tokens)) {
      //print('hey');
      // await userDocRef.update({
      //   'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      // });
      //
      // await groupDocRef.update({
      //   'members': FieldValue.arrayRemove([uid! + '_' + userName])
      // });
    } else {
      //print('nay');
      await userDocRef.update({
        'fcmTokens': FieldValue.arrayUnion([tokens])
      });
    }
  }

  // Future AddProfilePic() async {
  //   DocumentReference userDocRef = userCollection.doc(uid);
  //   DocumentSnapshot userDocSnapshot = await userDocRef.get();
  //
  //   List<dynamic> fcmtokens = await userDocSnapshot['fcmTokens'];
  //
  //     await userDocRef.update({
  //       'profilePic': FieldValue.arrayUnion([tokens])
  //     });
  // }

  Future RemoveTokenFcmUser() async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> fcmtokens = await userDocSnapshot['fcmTokens'];

    await userDocRef.update({
      'fcmTokens': FieldValue.arrayRemove([fcmtokens[0]])
    });
  }

  Future SendFcmToken(String groupId) async {
    DocumentReference userDocRef = userCollection.doc(uid);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();

    return groupDocSnapshot['members'];
  }

  Future getGroupAdmin(String groupId) async {


    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();

    return groupDocSnapshot['groupAdmins'];
  }

  Future Getusertokenreadable(String? userId, String? groupId) async {
    DocumentReference userDocRef = userCollection.doc(userId);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<String> arr_tokens = [];
    String? tokensmy='';

    List<dynamic> markMap = await userDocSnapshot['group_details'];

    List<dynamic> marktokens = await userDocSnapshot['fcmTokens'];

    for(var filename in markMap) {  /// <<<<==== changed line
      if (filename["group_id"] == groupId) {
        if (filename["group_read"]) {
          if(marktokens.length>0) {
            if(userId==uid){
              // tokensmy='';
            }else {
              for (var i = 0; i < marktokens.length; i++) {
               arr_tokens.add(marktokens[i]);
              }

              // tokensmy = marktokens[marktokens.length-1];


            }
          }else{
            // tokensmy='';

          }
        }else{
          // tokensmy='';
        }
      }
    }

    // markMap.forEach((element) {
    //   if (element["group_id"] == groupId) {
    //     if (element["group_read"]) {
    //       tokensmy=marktokens[0];
    //     }
    //   }
    // });

    // return tokensmy;
    return arr_tokens;
  }

  Future Getusertokenreadable2(String? userId, String? groupId) async {
    DocumentReference userDocRef = userCollection.doc(userId);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    // List<String> arr_tokens = [];
    String? tokensmy='';

    List<dynamic> markMap = await userDocSnapshot['group_details'];

    List<dynamic> marktokens = await userDocSnapshot['fcmTokens'];

    for(var filename in markMap) {  /// <<<<==== changed line
      if (filename["group_id"] == groupId) {
        if (filename["group_read"]) {
          if(marktokens.length>0) {
            if(userId==uid){
              tokensmy='';
            }else {
              // for (var i = 0; i < marktokens.length; i++) {
              //   arr_tokens.add(marktokens[i]);
              // }

              tokensmy = marktokens[marktokens.length-1];


            }
          }else{
            tokensmy='';

          }
        }else{
          tokensmy='';
        }
      }
    }

    // markMap.forEach((element) {
    //   if (element["group_id"] == groupId) {
    //     if (element["group_read"]) {
    //       tokensmy=marktokens[0];
    //     }
    //   }
    // });

    return tokensmy;
    // return arr_tokens;
  }

  // toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid! + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid! + '_' + userName])
      });
    }
  }

  Future togglingGroupJoinorRemove(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    bool? admin_exist;
    bool? admin_read;
    bool? admin_write;

    List<dynamic> groups = await userDocSnapshot['groups'];

    if (groups.contains(groupId)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId])
      });

      List<dynamic> markMap = await userDocSnapshot['group_details'];
      markMap.forEach((element) {
        if (element["group_id"] == groupId) {
          admin_read = element["group_read"];
          admin_write = element["group_write"];
          admin_exist = element["group_exist"];
        }
      });

      var mapold = new Map<String, dynamic>();

      mapold['group_id'] = groupId;
      mapold['group_exist'] = admin_exist;
      mapold['group_read'] = admin_read!;
      mapold['group_write'] = admin_write!;

      await userDocRef.update({
        'group_details': FieldValue.arrayRemove([mapold]),
      });

      var mapadmin = new Map<String, dynamic>();

      mapadmin['userId'] = uid;
      mapadmin['userName'] = userName;

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid! + '_' + userName]),
        'groupAdmins': FieldValue.arrayRemove([mapadmin])
      });
    } else {
      //print('nay');
      // await userDocRef.update({
      //   'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      // });
      //
      // await groupDocRef.update({
      //   'members': FieldValue.arrayUnion([uid! + '_' + userName])
      // });
    }
  }

  Future createLiveStreamGroup(
      String? videoId) async {

    DocumentReference groupDocRef = await livestreamCollection.add({
      'doc_id': '',
      'video_id': videoId,
      'total_count': 0,
      'status': 0,
      'Comment': [],
    });

      await groupDocRef.update({
        // 'members': FieldValue.arrayUnion([uid! + '_' + userName!]),
        'doc_id': groupDocRef.id
      });

      if(groupDocRef.id.length>2) {
        return true;
      }else{
        return false;
      }
  }

  getLiveStreamChats(String? videoId) async {
    return  FirebaseFirestore.instance
        .collection('live_videos')
      .where('video_id', isEqualTo: videoId).snapshots();

    // // print(snapshot.docs[0].data);
    // print("snapshot.docs[0].data");
    // return snapshot;
  }


  Future UpdateLiveStreamGroup(String videoId) async {
    QuerySnapshot snapshot =
    await      FirebaseFirestore.instance
        .collection('live_videos')
        .where('video_id', isEqualTo: videoId).get();


    DocumentReference groupDocRef = livestreamCollection.doc(snapshot.docs[0].id);
    // DocumentReference docRef = doc.reference;
    await groupDocRef.update({
      'status' : 1
    });

  }


  Future AddLiveStreamMessage(String doc_id,String videoId, String userName,String userPhoto, String comments,String time,num count) async {

    // livestreamCollection.where('video_id', isEqualTo: videoId).get().then((querySnapshot) => {
    // querySnapshot.docs[0].id
    // })
    // ;
    User? _user = await FirebaseAuth.instance.currentUser;

    DocumentReference groupDocRef = livestreamCollection.doc(doc_id);
    // DocumentReference docRef = doc.reference;
      var mapadmin = new Map<String, dynamic>();

      mapadmin['userId'] = _user!.uid;
      mapadmin['userName'] = userName;
      mapadmin['userPhoto'] = userPhoto;
      mapadmin['userComment'] = comments;
      mapadmin['time'] = time;
      print("my count"+count.toString());
num bb=count+1;
      await groupDocRef.update({
        'Comment': FieldValue.arrayUnion([mapadmin]),
        'total_count' : bb
      });

  }

  Future DeleteLiveStreamMessage(String doc_id,String userId, String userName, String userPhoto, String comments,String time) async {

    // livestreamCollection.where('video_id', isEqualTo: videoId).get().then((querySnapshot) => {
    // querySnapshot.docs[0].id
    // })
    // ;
    User? _user = await FirebaseAuth.instance.currentUser;

    DocumentReference groupDocRef = livestreamCollection.doc(doc_id);
    // DocumentReference docRef = doc.reference;
    var mapadmin = new Map<String, dynamic>();

    mapadmin['userId'] = userId;
    mapadmin['userName'] = userName;
    mapadmin['userPhoto']=userPhoto;
    mapadmin['userComment'] = comments;
    mapadmin['time'] = time;

    await groupDocRef.update({
      'Comment': FieldValue.arrayRemove([mapadmin])
    });

  }

  // AddLiveStreamMessage(String? groupId, chatMessageData) {
  //   FirebaseFirestore.instance
  //       .collection('live_videos')
  //       .where('video_id', isEqualTo: videoId).get();
  //   FirebaseFirestore.instance.collection('groups').doc(groupId).update({
  //     'recentMessage': chatMessageData['message'],
  //     'recentMessageSender': chatMessageData['sender'],
  //     'recentMessageTime': chatMessageData['time'].toString(),
  //   });
  // }



  Future sentRequestGroupJoin(String groupId) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    await groupDocRef.update({
      'groupRequest': FieldValue.arrayUnion([uid!])
    });
  }

  // has user joined the group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  Future<bool> isUserJoined2(String groupId, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot['groups'];

    if (groups.contains(groupId)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('Email', isEqualTo: email).get();
    // print(snapshot.docs[0].data);
    return snapshot;
  }

  Future getUserDataById(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  Future getGroupData(String groupId) async {
    QuerySnapshot snapshot =
        await groupCollection.where('groupId', isEqualTo: groupId).get();
    // print(snapshot.docs[0].data);
    return snapshot;
  }

  Future getUserJoined(String groupId) async {
    QuerySnapshot snapshot =
        await userCollection.where('groups', arrayContains: groupId).get();
    return snapshot;
  }

  getGroupUser(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  // get user groups
  getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  getAdminsGroups(String uname) async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("groups")
        // .where('userId' , arrayContains: {"userId": 1.3})
        .where("groupAdmins",
            arrayContains: {"userId": uid, "userName": uname}).snapshots();
  }

  // send message
  sendMessage(String? groupId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String? groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  getAllGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("groups").snapshots();
  }

  getAllUsers() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  getAllLiveStreamCountVideo() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("live_videos").where('status', isEqualTo: 0).snapshots();
  }

  Future addremoveUserInGroup(String email, String userName, String groupId,
      String groupName, String type) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    if (type == "ADD") {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
          }).then((value) => groupDocRef.update({
                'members': FieldValue.arrayUnion(
                    [documentSnapshot.reference.id + '_' + userName])
              }));
        });
      });
    } else if (type == "REMOVE") {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
          }).then((value) => groupDocRef.update({
                'members': FieldValue.arrayRemove(
                    [documentSnapshot.reference.id + '_' + userName])
              }));
        });
      });
    }
  }

  Future addremoveNewUserInGroup(
      String email,
      String userName,
      String groupId,
      String groupName,
      String type,
      bool? oldread,
      bool? oldwrite,
      bool read,
      bool write) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);
    var mapold = new Map<String, dynamic>();
    mapold['group_id'] = groupId;
    mapold['group_name'] = groupName;
    mapold['group_read'] = oldread;
    mapold['group_write'] = oldwrite;

    var map = new Map<String, dynamic>();
    map['group_id'] = groupId;
    map['group_name'] = groupName;
    map['group_read'] = read;
    map['group_write'] = write;

    if (type == "ADD") {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'groups': FieldValue.arrayUnion([groupId + '_' + groupName]),
            'group_details': FieldValue.arrayUnion([map]),
          }).then((value) => groupDocRef.update({
                'members': FieldValue.arrayUnion(
                    [documentSnapshot.reference.id + '_' + userName])
              }));
        });
      });
    } else if (type == "REMOVE") {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
          }).then((value) => groupDocRef.update({
                'members': FieldValue.arrayRemove(
                    [documentSnapshot.reference.id + '_' + userName])
              }));
        });
      });
    } else if (type == "UPDATE") {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            // 'groups': FieldValue.arrayRemove([groupId + '_' + groupName]),
            'group_details': FieldValue.arrayRemove([mapold]),
          }).then((value) => documentSnapshot.reference.update({
                'group_details': FieldValue.arrayUnion([map]),
              }));
        });
      });
    }
  }

  Future addremoveMainNewUserInGroup(
      String doc_id,
      String email,
      String userName,
      String groupId,
      String type,
      bool? group_exist,
      bool? group_read,
      bool? group_write,
      bool? isChange_exist,
      bool? isChange_read,
      bool? isChange_write) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);
    if (group_exist!) {
      if (isChange_exist!) {
        var map = new Map<String, dynamic>();
        map['group_id'] = groupId;
        map['group_exist'] = group_exist;
        map['group_read'] = group_read;
        map['group_write'] = group_write;

        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            documentSnapshot.reference.update({
              'groups': FieldValue.arrayUnion([groupId]),
              'group_details': FieldValue.arrayUnion([map]),
            }).then((value) => groupDocRef.update({
                  'members': FieldValue.arrayUnion(
                      [documentSnapshot.reference.id + '_' + userName])
                }));
          });
        });
      }
      else {
        if (group_read == false && group_write == false) {
          var mapold = new Map<String, dynamic>();

          mapold['group_id'] = groupId;
          mapold['group_exist'] = true;
          if (isChange_read!) {
            mapold['group_read'] = !group_read!;
          } else {
            mapold['group_read'] = group_read!;
          }
          if (isChange_write!) {
            mapold['group_write'] = !group_write!;
          } else {
            mapold['group_write'] = group_write!;
          }
          // mapold['group_write'] = oldwrite ;

          var mapadmin = new Map<String, dynamic>();

          mapadmin['userId'] = doc_id;
          mapadmin['userName'] = userName;

          FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({
                'groups': FieldValue.arrayRemove([groupId]),
                'group_details': FieldValue.arrayRemove([mapold]),
              }).then((value) => groupDocRef.update({
                'members': FieldValue.arrayRemove(
                    [documentSnapshot.reference.id + '_' + userName]),
                'groupAdmins': FieldValue.arrayRemove([mapadmin])
              }));
            });
          });
        } else {

          var mapold = new Map<String, dynamic>();

          mapold['group_id'] = groupId;
          mapold['group_exist'] = group_exist;
          if (isChange_read!) {
            mapold['group_read'] = !group_read!;
          } else {
            mapold['group_read'] = group_read!;
          }
          if (isChange_write!) {
            mapold['group_write'] = !group_write!;
          } else {
            mapold['group_write'] = group_write!;
          }

          var map = new Map<String, dynamic>();
          map['group_id'] = groupId;
          map['group_exist'] = group_exist;
          map['group_read'] = group_read;
          map['group_write'] = group_write;

          FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({
                // 'groups': FieldValue.arrayRemove([groupId + '_' + groupName]),
                'group_details': FieldValue.arrayRemove([mapold]),
              }).then((value) =>
                  documentSnapshot.reference.update({
                    'group_details': FieldValue.arrayUnion([map]),
                  }));
            });
          });
        }
      }
    }
    else {
      if(isChange_read! || isChange_write!){
        var map = new Map<String, dynamic>();
        map['group_id'] = groupId;
        map['group_exist'] = true;
        map['group_read'] = group_read;
        map['group_write'] = group_write;

        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            documentSnapshot.reference.update({
              'groups': FieldValue.arrayUnion([groupId]),
              'group_details': FieldValue.arrayUnion([map]),
            }).then((value) => groupDocRef.update({
              'members': FieldValue.arrayUnion(
                  [documentSnapshot.reference.id + '_' + userName])
            }));
          });
        });
      }else {
        //remove
        var mapold = new Map<String, dynamic>();

        mapold['group_id'] = groupId;
        mapold['group_exist'] = true;
        if (isChange_read) {
          mapold['group_read'] = !group_read!;
        } else {
          mapold['group_read'] = group_read!;
        }
        if (isChange_write) {
          mapold['group_write'] = !group_write!;
        } else {
          mapold['group_write'] = group_write!;
        }
        // mapold['group_write'] = oldwrite ;

        var mapadmin = new Map<String, dynamic>();

        mapadmin['userId'] = doc_id;
        mapadmin['userName'] = userName;

        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            documentSnapshot.reference.update({
              'groups': FieldValue.arrayRemove([groupId]),
              'group_details': FieldValue.arrayRemove([mapold]),
            }).then((value) =>
                groupDocRef.update({
                  'members': FieldValue.arrayRemove(
                      [documentSnapshot.reference.id + '_' + userName]),
                  'groupAdmins': FieldValue.arrayRemove([mapadmin])
                }));
          });
        });
      }
    }
  }

  Future RequestUserInGroup(
      String doc_id,
      String email,
      String userName,
      String groupId,
      String type,
      bool? group_exist,
      bool? group_disapprove,
      bool? group_read,
      bool? group_write,
      bool? isChange_exist,
      bool? isChange_disapprove,
      bool? isChange_read,
      bool? isChange_write) async {
    // print(group_exist!);
    DocumentReference groupDocRef = groupCollection.doc(groupId);
    if (group_disapprove!) {
      //remove
      var mapold = new Map<String, dynamic>();

      mapold['group_id'] = groupId;
      mapold['group_exist'] = true;
      if (isChange_read!) {
        mapold['group_read'] = !group_read!;
      } else {
        mapold['group_read'] = group_read!;
      }
      if (isChange_write!) {
        mapold['group_write'] = !group_write!;
      } else {
        mapold['group_write'] = group_write!;
      }
      // mapold['group_write'] = oldwrite ;

      var mapadmin = new Map<String, dynamic>();

      mapadmin['userId'] = doc_id;
      mapadmin['userName'] = userName;

      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          groupDocRef.update({
            'groupRequest':
                FieldValue.arrayRemove([documentSnapshot.reference.id]),
          });
        });
      });
    } else {
      //add
        var map = new Map<String, dynamic>();
        map['group_id'] = groupId;
        map['group_exist'] = group_exist;
        map['group_read'] = group_read;
        map['group_write'] = group_write;

        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            documentSnapshot.reference.update({
              'groups': FieldValue.arrayUnion([groupId]),
              'group_details': FieldValue.arrayUnion([map]),
            }).then((value) => groupDocRef.update({
                  'members': FieldValue.arrayUnion(
                      [documentSnapshot.reference.id + '_' + userName]),
                  'groupRequest':
                      FieldValue.arrayRemove([documentSnapshot.reference.id]),
                }));
          });
        });
    }
  }

  Future removeUserInGroup(String email, String userName, String groupId,
      bool? group_exist, bool? group_read, bool? group_write) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);
    //remove
    var mapold = new Map<String, dynamic>();

    mapold['group_id'] = groupId;
    mapold['group_exist'] = true;
    mapold['group_read'] = group_read!;
    mapold['group_write'] = group_write!;

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.update({
          'groups': FieldValue.arrayRemove([groupId]),
          'group_details': FieldValue.arrayRemove([mapold]),
        }).then((value) => groupDocRef.update({
              'members': FieldValue.arrayRemove(
                  [documentSnapshot.reference.id + '_' + userName])
            }));
      });
    });
  }
}
