## Idemeum iOS SDK


## Installation

Install using cocoapod

```
target '<your-app>' do
  ...
  pod 'idemeum' # insert this line to your project's Podfile
  ...
end
```

## Usage
## Import idemeum iOS SDK

We can now import idemeum iOS SDK. For this guide we will simply import the SDK to your view controller.
```
import idemeum
```

## Initialize idemeum SDK

Initialize idemeum SDK instance. 
Use your clientId that you obtained from [idemeum developer portal]().

``` 
var objIdemeum: Idemeum!

objIdemeum = Idemeum(parentView: self, clientId: “<Place your client id here>”)
```

## Manage user authentication state

```
func isUserLoggedIn(){
  objIdemeum.isLoggedIn(){(isLoggedin) in
     if isLoggedin {
      //User is logged in
     }else {
      //User is not logged in
     }
   }
}
```

## Login 

```
func login(){
  objIdemeum.login(){(isSuccess, mIdemeumResponse, error) in
    if isSuccess, let response = mIdemeumResponse {
      //Get here OIDC token.
    }else {
      //Show error
    }
  }
}
```

## Get and validate user claims

```
func renderUserClaims(){
  objIdemeum.userClaims(){(isSuccess, result, error) in
    if isSuccess, let stringResult = result {
      //Get here OIDC token.
    }else {
      //Show error
    }
  }
}
```

## Logout

```
objIdemeum.logout()
```


## Complete documentation guide

You can checkout the complete documentation guide [here](https://docs.idemeum.com/reference/ios-guide/)


## Contact

You can reach us at <support@idemeum.com>

## Licence

This project uses the following license: [MIT License](https://github.com/idemeum/idemeum-ios-sdk/blob/main/LICENSE)
