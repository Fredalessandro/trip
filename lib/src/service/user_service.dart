import 'dart:convert';

import '../model/user_model.dart';
import 'local_storage_service.dart';


class UserService  {
   static String KEY = "USUARIO";
  
   static save(User user) async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         remove();
         const JsonEncoder encoder = JsonEncoder();
         final String stringJson = encoder.convert(user);
         sharedLocalStorageService.put(KEY, stringJson);
   }

   static Future get() async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         const JsonDecoder decoder = JsonDecoder();
         String stringJson = ""; 
         await sharedLocalStorageService.getString(KEY).then((value) => {
              stringJson = value!    
         });
         Map<String, dynamic> object = decoder.convert(stringJson);
         User user = User.fromJson(object);
         return user;
   }

   static remove() async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         sharedLocalStorageService.delete(KEY);
   }


}