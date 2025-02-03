import ballerina/http;
import ballerina/time;

type User record{|
    readonly int id;
    string name;
    string email;
    time:Date birthDate;
    string mobileNumber;
|};
  
table<User> key(id) users = table[
    {id:1, name:"John Doe",
     email:"PASINDU@GMAIL.COM",
      birthDate:{year:1995, month:10, day:10},
     mobileNumber:"0702311822"},
     {
     id:2, name:"Pasi Doe",
     email:"PASINDU@GMAIL.COM",
      birthDate:{year:1995, month:10, day:10},
     mobileNumber:"0702311822"}
   
];

type ErrorDetails record{
    string message;
    string details;
    time:Utc timeStamp;
};

type UserNotFound record{
    *http:NotFound;
    ErrorDetails body;
};

service /social\-media on new http:Listener(9090) {
    //social-media/users
     // Get all users
    resource function get users() returns User[]|error {

    // User[] users = [{id:1, name:"John Doe",
    //  email:"PASINDU@GMAIL.COM",
    //   birthDate:{year:1995, month:10, day:10},
    //  mobileNumber:"0702311822"},{
    //  id:2, name:"Pasi Doe",
    //  email:"PASINDU@GMAIL.COM",
    //   birthDate:{year:1995, month:10, day:10},
    //  mobileNumber:"0702311822"}];
    
     return users.toArray();
    }

     // Get user by ID
    resource function get users/[int id]() returns User|UserNotFound|error {

        User? user = users[id];
        
        if user is (){
            UserNotFound userNotFound = {
                 body: {message:string `id`, details: string `user/${id}`, timeStamp:time:utcNow()}
            };
            return userNotFound;
        }
        return user;
    }
}
