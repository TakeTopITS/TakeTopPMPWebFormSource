using System;
using System.Collections.Concurrent;
using System.Configuration;
using System.IO;
using System.Web;
using System.Xml;

public static class LanguageHandle
{
    private static readonly ConcurrentDictionary<string, XmlDocument> languageDocCache = new ConcurrentDictionary<string, XmlDocument>();
    private static readonly string DefaultLangCode = ConfigurationManager.AppSettings["DefaultLang"] ?? "en";
    private static readonly object initLock = new object();
    private static bool isInitialized = false;

    static LanguageHandle()
    {
        // 延迟初始化，避免在静态构造函数中执行IO操作
    }

    // 确保初始化只执行一次
    private static void EnsureInitialized()
    {
        if (!isInitialized)
        {
            lock (initLock)
            {
                if (!isInitialized)
                {
                    CopyLanguageFilesToLanguageDirectory();
                    isInitialized = true;
                }
            }
        }
    }

    // 取得语言文件的关键词的值
    public static string GetWord(string strKeyword)
    {
        EnsureInitialized();

        if (string.IsNullOrEmpty(strKeyword))
            return string.Empty;

        // 获取当前会话的语言代码
        var context = HttpContext.Current;
        string systemLangCode = context.Session != null && context.Session["LangCode"] != null
            ? context.Session["LangCode"].ToString()
            : null;

        if (string.IsNullOrEmpty(systemLangCode))
        {
            systemLangCode = DefaultLangCode;
        }

        // 尝试获取指定语言的翻译
        string result = GetTranslation(systemLangCode, strKeyword);

        // 如果未找到且当前语言不是默认语言，则尝试默认语言
        if (string.IsNullOrEmpty(result) && !systemLangCode.Equals(DefaultLangCode, StringComparison.OrdinalIgnoreCase))
        {
            result = GetTranslation(DefaultLangCode, strKeyword);
        }

        return result ?? string.Empty;
    }

    // 获取特定语言的翻译
    private static string GetTranslation(string langCode, string keyword)
    {
        XmlDocument doc = GetLanguageDoc(langCode);
        if (doc.DocumentElement == null)
            return null;

        // 使用XPath选择器定位到指定节点
        XmlNode dataNode = doc.SelectSingleNode("/root/data[@name='" + keyword + "']/value");
        return dataNode != null ? dataNode.InnerText : null;
    }

    // 从缓存中获取语言文件，如果缓存中没有则加载
    private static XmlDocument GetLanguageDoc(string langCode)
    {
        // 首先尝试从缓存获取
        XmlDocument cachedDoc;
        if (languageDocCache.TryGetValue(langCode, out cachedDoc))
        {
            return cachedDoc;
        }

        // 同步加载并缓存
        return languageDocCache.GetOrAdd(langCode, code =>
        {
            string resxFile = GetResxFilePath(code);

            // 如果指定的语言文件不存在，则使用默认语言文件
            if (!File.Exists(resxFile))
            {
                resxFile = GetResxFilePath(DefaultLangCode);

                // 如果默认语言文件也不存在，返回空的 XmlDocument
                if (!File.Exists(resxFile))
                {
                    return new XmlDocument();
                }
            }

            try
            {
                XmlDocument doc = new XmlDocument();
                // 使用XmlReaderSettings优化XML加载
                XmlReaderSettings settings = new XmlReaderSettings
                {
                    IgnoreComments = true,
                    IgnoreWhitespace = true
                };

                using (XmlReader reader = XmlReader.Create(resxFile, settings))
                {
                    doc.Load(reader);
                }

                return doc;
            }
            catch
            {
                return new XmlDocument();
            }
        });
    }

    // 获取resx文件路径
    private static string GetResxFilePath(string langCode)
    {
        return HttpContext.Current.Server.MapPath("Language/lang." + langCode + ".resx");
    }

    // 复制语言文件（如果需要）
    private static void CopyLanguageFilesToLanguageDirectory()
    {
        try
        {
            var context = HttpContext.Current;
            if (context == null) return;

            string sourceDirectory = context.Server.MapPath("App_GlobalResources");
            string targetDirectory = context.Server.MapPath("Language");

            // 确保源目录存在
            if (!Directory.Exists(sourceDirectory))
                return;

            // 确保目标目录存在，如果不存在则创建
            if (!Directory.Exists(targetDirectory))
            {
                Directory.CreateDirectory(targetDirectory);
            }

            // 获取源目录下的所有扩展名为 .resx 的文件
            string[] files = Directory.GetFiles(sourceDirectory, "*.resx");

            foreach (string file in files)
            {
                string fileName = Path.GetFileName(file);
                string destFile = Path.Combine(targetDirectory, fileName);

                // 只有当源文件比目标文件新或者目标文件不存在时才复制
                if (!File.Exists(destFile) || File.GetLastWriteTime(file) > File.GetLastWriteTime(destFile))
                {
                    File.Copy(file, destFile, true);
                }
            }
        }
        catch (Exception ex)
        {
            // 记录日志或处理异常
            // 在实际应用中应该记录日志
        }
    }
}