class FirestorePath {
  static String banana(String uid, String bananaId) => 'users/$uid/bananas/$bananaId';
  
  static String bananas(String uid) => 'users/$uid/bananas';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  // static String account(String uid, String accountId) => 'users/$uid/accounts/$accountId';
  // static String accounts(String uid) => 'accounts/$uid/accounts';
  static String account(String uid, String accountId) => 'users/$uid';
  static String accounts(String uid) => '$uid';
}
