using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public static class CryptoHelper
{
    /// <summary>
    /// 从字符串派生出固定长度的加密密钥
    /// </summary>
    /// <param name="input">原始密钥字符串</param>
    /// <param name="keySize">需要的密钥长度(位)，AES-256对应32字节</param>
    /// <returns>派生后的密钥字节数组</returns>
    public static byte[] DeriveKey(string input, int keySize = 32)
    {
        // 参数校验
        if (string.IsNullOrEmpty(input))
            throw new ArgumentNullException(nameof(input));

        if (keySize != 16 && keySize != 24 && keySize != 32)
            throw new ArgumentException("密钥长度必须是16(128位)、24(192位)或32(256位)");

        // 使用PBKDF2进行密钥派生
        using (var deriveBytes = new Rfc2898DeriveBytes(
            password: input,
            salt: Encoding.UTF8.GetBytes("固定盐值(建议改为随机)"), // 生产环境应使用随机盐
            iterations: 10000, // 迭代次数增加破解难度
            hashAlgorithm: HashAlgorithmName.SHA256))
        {
            return deriveBytes.GetBytes(keySize);
        }
    }

    /// <summary>
    /// 生产环境推荐的安全密钥派生方法
    /// </summary>
    public static byte[] SecureDeriveKey(string input, byte[] salt, int keySize = 32)
    {
        // 参数校验
        if (string.IsNullOrEmpty(input))
            throw new ArgumentNullException(nameof(input));

        if (salt == null || salt.Length < 8)
            throw new ArgumentException("盐值必须至少8字节");

        if (keySize != 16 && keySize != 24 && keySize != 32)
            throw new ArgumentException("无效的密钥长度");

        // 使用更安全的Argon2算法(需要安装Libsodium.Net等库)
        // 或者继续使用PBKDF2但增加迭代次数
        using (var deriveBytes = new Rfc2898DeriveBytes(
            password: input,
            salt: salt,
            iterations: 100000, // 更高的迭代次数
            hashAlgorithm: HashAlgorithmName.SHA512))
        {
            return deriveBytes.GetBytes(keySize);
        }
    }
}