public with sharing class CTPersonController {
    
    public static String getToken(String mobile){
        if(String.isBlank(mobile)){
            return null;
        }
        
        Blob targetBlob = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);

        return EncodingUtil.base64Encode(hash);
    }
}