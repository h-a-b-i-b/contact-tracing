public with sharing class CTPersonController {
    
    public static String getToken(String mobile){
        // generate unique hash
        Blob targetBlob = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        String result = EncodingUtil.base64Encode(hash);
        return result;
    }
}