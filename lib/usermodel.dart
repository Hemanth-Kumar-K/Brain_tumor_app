class UserModel
{
  String? uid;
  String? email;
  String? Name;
  String? phonenumber;

  UserModel({
    this.uid, this.email, this.Name, this.phonenumber
});
//recevi from server
  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      Name: map['Name'],
      phonenumber: map['phonenumber']
    );
  }

  //sending data to the server
Map<String, dynamic> toMap()
{
  return{
    'uid':uid,
    'email': email,
    'Name': Name,
    'phonenumber': phonenumber
  };
}

}