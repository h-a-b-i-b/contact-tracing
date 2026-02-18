public with sharing class CTPersonController {
    
    /**
     * This method generates a unique token for a given mobile number using MD5 hashing and Base64 encoding.
     * @param mobileNo The mobile number for which the token is to be generated.
     * @return A unique token as a String.
     */
    public static String getToken(String mobileNo){
        return EncodingUtil.base64Encode(Crypto.generateDigest('MD5', Blob.valueOf(mobileNo)));
    }
}