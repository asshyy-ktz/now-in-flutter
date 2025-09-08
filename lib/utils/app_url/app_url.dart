class AppUrl {
  static const String baseUrl = 'https://accountingapi.silverlaketech.ca/api';

  static const String authenticate = '$baseUrl/Authentication/Authenticate';
  static const String authenticateWithUserId =
      '$baseUrl/Authentication/AuthenticateWithUserId';
  static const String getExpenseSheets =
      '$baseUrl/odata/ExpenseSheet?\$expand=Expenses(\$expand=Attachments(\$expand=File)),PaymentAccount,Expenses';
  static const String postExpenseSheet = '$baseUrl/odata/ExpenseSheet';

  static String patchExpenseSheet(String id) {
    return '$baseUrl/odata/ExpenseSheet/$id';
  }

  static String deleteExpenseSheet(String id) {
    return '$baseUrl/odata/ExpenseSheet/$id';
  }

  static String patchOtherTransactions(String id) {
    return '$baseUrl/odata/OtherTransaction/$id';
  }

  static String createOtherTransactions() {
    return '$baseUrl/odata/OtherTransaction';
  }

  static String getExpenseNotes(String id) {
    return '$baseUrl/odata/ExpenseNotes?\$filter=ExpenseSheet/Oid eq $id';
  }

  static String updateExpenseNotes(String id) {
    return '$baseUrl/odata/ExpenseNotes($id)';
  }

  static const String postExpenseNote = '$baseUrl/odata/ExpenseNotes';
  static const String getAccounts = '$baseUrl/odata/Accounts';
  static const String getVendors = '$baseUrl/odata/Vendors';
  static const String getSalesTaxesList = '$baseUrl/odata/SalesTax';

  static const String uploadAndScanReceipt = '$baseUrl/AI/UploadAndScanReceipt';

  static String playStore = "https://play.google.com/store/";
  static String appStore = "https://apps.apple.com/app/";

  static String getForgetPasswordVerifyUrl(String id, String code) {
    return '';
  }

  static String getExpenses(String id) {
    return '$baseUrl';
  }

  static const String renewPassword = '';
  static const String sendForgotPassword = '';
  static const String getUserProfileAPI = '';
}
