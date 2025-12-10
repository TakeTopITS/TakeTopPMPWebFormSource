using System;
using System.Web;
using System.Collections.Concurrent;
using Newtonsoft.Json;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.IO.Compression;

public class CookieSessionModule : IHttpModule
{
    private const string CookieName = "AppSession_V2";
    private const int TimeoutMinutes = 20;
    private static readonly byte[] EncryptionKey = Encoding.UTF8.GetBytes(System.Configuration.ConfigurationManager.AppSettings["SessionEncryptionKey"]);

    public void Init(HttpApplication context)
    {
        context.BeginRequest += RestoreSession;
        context.PostRequestHandlerExecute += PersistSession;
        context.Error += OnError;
    }

    private void RestoreSession(object sender, EventArgs e)
    {
        var app = (HttpApplication)sender;
        if (ShouldSkip(app.Request)) return;

        try
        {
            var cookie = app.Request.Cookies[CookieName];
            if (cookie != null && !string.IsNullOrEmpty(cookie.Value))
            {
                var decrypted = DecryptData(cookie.Value);
                app.Context.Items["SessionStore"] = JsonConvert.DeserializeObject<ConcurrentDictionary<string, object>>(decrypted)
                    ?? new ConcurrentDictionary<string, object>();
            }
            else
            {
                InitializeNewSession(app);
            }
        }
        catch
        {
            InitializeNewSession(app);
            InvalidateCookie(app.Response);
        }
    }

    private void PersistSession(object sender, EventArgs e)
    {
        var app = (HttpApplication)sender;
        if (ShouldSkip(app.Request)) return;

        var sessionData = app.Context.Items["SessionStore"] as ConcurrentDictionary<string, object>;
        if (sessionData != null)
        {
            try
            {
                var json = JsonConvert.SerializeObject(sessionData);
                var encrypted = EncryptData(json);

                var cookie = new HttpCookie(CookieName, encrypted)
                {
                    HttpOnly = true,
                    Secure = app.Request.IsSecureConnection,
                    Expires = DateTime.Now.AddMinutes(TimeoutMinutes),
                    Path = "/",
                    SameSite = SameSiteMode.Lax
                };

                app.Response.Cookies.Add(cookie);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError($"Session persistence failed: {ex}");
            }
        }
    }

    private void InitializeNewSession(HttpApplication app)
    {
        var newSession = new ConcurrentDictionary<string, object>
        {
            ["SessionID"] = GenerateSessionId(),
            ["Created"] = DateTime.UtcNow,
            ["IP"] = app.Request.UserHostAddress,
            ["UserAgent"] = app.Request.UserAgent?.GetHashCode()
        };
        app.Context.Items["SessionStore"] = newSession;
    }

    private string GenerateSessionId()
    {
        using (var rng = new RNGCryptoServiceProvider())
        {
            var bytes = new byte[16];
            rng.GetBytes(bytes);
            return Convert.ToBase64String(bytes);
        }
    }

    private string EncryptData(string plainText)
    {
        using (Aes aes = Aes.Create())
        {
            aes.Key = EncryptionKey;
            aes.IV = new byte[16]; // Zero-padded IV for simplicity

            using (var ms = new MemoryStream())
            {
                using (var cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                using (var sw = new StreamWriter(new GZipStream(cs, CompressionMode.Compress)))
                {
                    sw.Write(plainText);
                }
                return Convert.ToBase64String(ms.ToArray());
            }
        }
    }

    private string DecryptData(string cipherText)
    {
        try
        {
            using (Aes aes = Aes.Create())
            {
                aes.Key = EncryptionKey;
                aes.IV = new byte[16];

                var buffer = Convert.FromBase64String(cipherText);

                using (var ms = new MemoryStream(buffer))
                using (var cs = new CryptoStream(ms, aes.CreateDecryptor(), CryptoStreamMode.Read))
                using (var sr = new StreamReader(new GZipStream(cs, CompressionMode.Decompress)))
                {
                    return sr.ReadToEnd();
                }
            }
        }
        catch
        {
            return null;
        }
    }

    private void InvalidateCookie(HttpResponse response)
    {
        response.Cookies.Add(new HttpCookie(CookieName, "")
        {
            Expires = DateTime.Now.AddYears(-1),
            Path = "/"
        });
    }

    private void OnError(object sender, EventArgs e)
    {
        var app = (HttpApplication)sender;
        System.Diagnostics.Trace.TraceError($"Application Error: {app.Server.GetLastError()}");
    }

    private bool ShouldSkip(HttpRequest request)
    {
        string path = request.Path.ToLower();
        return path.EndsWith(".css") ||
               path.EndsWith(".js") ||
               path.EndsWith(".png") ||
               path.Contains("/api/");
    }

    public void Dispose() { }
}