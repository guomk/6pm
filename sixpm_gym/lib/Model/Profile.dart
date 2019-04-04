class Profile{
  String dob;
  String email;
  String firstName;
  String lastName;
  String gender;
  String interest;
  String strength;
  String level;
  String username;
  double currentRating;
  double hourSum;
  int numOfSession;

  //Constructor
  Profile(
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.gender,
    this.dob,
    this.strength,
    this.interest,
    this.level,
  ){
    //Initialized variables
    currentRating = 5.0;
    hourSum = 0;
    numOfSession = 0;
  }

  Map<String, Object> getMap(){
        Map<String, Object> data = <String, Object>{
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'gender': gender,
      'dob':dob,
      'strength': strength,
      'interest': interest,
      'level': level,
      'currentRating': currentRating,
      'hourSum': hourSum,
      'numOfSession': numOfSession,
    };
    return data;
  }
}