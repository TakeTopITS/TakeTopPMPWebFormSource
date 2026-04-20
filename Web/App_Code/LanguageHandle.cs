using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web;
using System.Xml;

public static class LanguageHandle
{
    // 缓存：语言代码 -> 关键词字典，直接查字典比 XPath 快 10-100 倍
    private static readonly ConcurrentDictionary<string, Dictionary<string, string>> languageCache = 
        new ConcurrentDictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);
    
    // 缓存文件最后修改时间，用于检测文件变化
    private static readonly ConcurrentDictionary<string, DateTime> fileLastWriteCache = 
        new ConcurrentDictionary<string, DateTime>();
    
    private static readonly string DefaultLangCode = ConfigurationManager.AppSettings["DefaultLang"] ?? "en";
    private static readonly object initLock = new object();
    private static volatile bool isInitialized = false;

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
        if (string.IsNullOrEmpty(strKeyword))
            return string.Empty;

        EnsureInitialized();

        // 获取当前会话的语言代码
        var context = HttpContext.Current;
        string systemLangCode = context?.Session?["LangCode"]?.ToString();

        if (string.IsNullOrEmpty(systemLangCode))
        {
            systemLangCode = DefaultLangCode;
        }

        // 尝试获取指定语言的翻译（使用字典直接查找，O(1)复杂度）
        string result = GetTranslationFromCache(systemLangCode, strKeyword);

        // 如果未找到且当前语言不是默认语言，则尝试默认语言
        if (result == null && !systemLangCode.Equals(DefaultLangCode, StringComparison.OrdinalIgnoreCase))
        {
            result = GetTranslationFromCache(DefaultLangCode, strKeyword);
        }

        return result ?? string.Empty;
    }

    // 从缓存字典中获取翻译，O(1) 复杂度
    private static string GetTranslationFromCache(string langCode, string keyword)
    {
        // 检查文件是否已更新，如果是则刷新缓存
        CheckAndRefreshCacheIfNeeded(langCode);

        // 直接查字典，比 XPath 快得多
        Dictionary<string, string> dict;
        if (languageCache.TryGetValue(langCode, out dict))
        {
            string value;
            if (dict.TryGetValue(keyword, out value))
                return value;
        }

        return null;
    }

    // 检查文件是否变化，必要时刷新缓存
    private static void CheckAndRefreshCacheIfNeeded(string langCode)
    {
        string resxFile = GetResxFilePath(langCode);
        
        // 如果缓存不存在，直接加载
        if (!languageCache.ContainsKey(langCode))
        {
            LoadLanguageIntoCache(langCode, resxFile);
            return;
        }

            // 检查文件是否已更新
            if (File.Exists(resxFile))
            {
                DateTime lastWrite = File.GetLastWriteTime(resxFile);
                DateTime cachedTime;
                if (fileLastWriteCache.TryGetValue(langCode, out cachedTime))
                {
                    if (lastWrite > cachedTime)
                    {
                        // 文件已更新，刷新缓存
                        LoadLanguageIntoCache(langCode, resxFile);
                    }
                }
            }
    }

    // 加载语言文件到缓存字典
    private static void LoadLanguageIntoCache(string langCode, string resxFile)
    {
        // 如果文件不存在，尝试默认语言
        if (!File.Exists(resxFile))
        {
            resxFile = GetResxFilePath(DefaultLangCode);
            if (!File.Exists(resxFile))
            {
                languageCache[langCode] = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                return;
            }
        }

        try
        {
            var dict = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            
            // 使用 XmlReader 流式读取，内存效率更高
            var settings = new XmlReaderSettings
            {
                IgnoreComments = true,
                IgnoreWhitespace = true,
                DtdProcessing = DtdProcessing.Prohibit // 安全：禁止 DTD 解析
            };

            using (var reader = XmlReader.Create(resxFile, settings))
            {
                string currentName = null;
                bool inValue = false;

                while (reader.Read())
                {
                    if (reader.NodeType == XmlNodeType.Element)
                    {
                        if (reader.Name == "data")
                        {
                            currentName = reader.GetAttribute("name");
                        }
                        else if (reader.Name == "value" && currentName != null)
                        {
                            inValue = true;
                        }
                    }
                    else if (reader.NodeType == XmlNodeType.Text && inValue && currentName != null)
                    {
                        dict[currentName] = reader.Value;
                        currentName = null;
                        inValue = false;
                    }
                    else if (reader.NodeType == XmlNodeType.EndElement && reader.Name == "value")
                    {
                        inValue = false;
                    }
                }
            }

            // 更新缓存
            languageCache[langCode] = dict;
            fileLastWriteCache[langCode] = File.GetLastWriteTime(resxFile);
        }
        catch
        {
            // 出错时使用空字典，避免重复加载失败文件
            languageCache.TryAdd(langCode, new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase));
        }
    }

    // 获取resx文件路径
    private static string GetResxFilePath(string langCode)
    {
        return HttpContext.Current?.Server.MapPath("Language/lang." + langCode + ".resx");
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

            if (!Directory.Exists(sourceDirectory))
                return;

            if (!Directory.Exists(targetDirectory))
            {
                Directory.CreateDirectory(targetDirectory);
            }

            // 只复制 .resx 文件
            foreach (string file in Directory.EnumerateFiles(sourceDirectory, "*.resx"))
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
        catch
        {
            // 静默处理异常，避免影响页面加载
        }
    }

    // 预加载指定语言到缓存（可用于启动时预热）
    public static void PreloadLanguage(string langCode)
    {
        string resxFile = GetResxFilePath(langCode);
        if (!string.IsNullOrEmpty(resxFile))
        {
            LoadLanguageIntoCache(langCode, resxFile);
        }
    }

    // 清除指定语言的缓存（用于文件更新后强制刷新）
    public static void ClearCache(string langCode)
    {
        Dictionary<string, string> temp1;
        DateTime temp2;
        languageCache.TryRemove(langCode, out temp1);
        fileLastWriteCache.TryRemove(langCode, out temp2);
    }

    // 清除所有缓存
    public static void ClearAllCache()
    {
        languageCache.Clear();
        fileLastWriteCache.Clear();
    }
}
