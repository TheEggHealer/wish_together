import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/database_service.dart';

class InvitationService {

  Future testInvitation(String mail) async {
    DatabaseService dbs = DatabaseService();
    String uid = await dbs.uidFromEmail(mail);
    debug('Mail: $mail, uid: $uid');
  }

}