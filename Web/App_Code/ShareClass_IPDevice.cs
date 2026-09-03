using LumiSoft.Net.Mail;
using LumiSoft.Net.MIME;
using LumiSoft.Net.POP3.Client;

using Microsoft.CSharp;

using MSXML2;

using net.sf.mpxj.primavera.schema;

using Npgsql;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using RTXSAPILib;

using RTXServerApi;

using System;
using System.Activities.DurableInstancing;
using System.Activities.Statements;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
//using NPOI.SS.Formula.Functions;
//using Microsoft.Office.Interop.MSProject;
//using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using TakeTopCore;

using TakeTopGantt;

using TakeTopWF;

using ZXing;
using ZXing.QrCode;

/// <summary>
/// ShareClass partial - IPDevice
/// </summary>
public static partial class ShareClass
{
    
    #region IP、MAC地址和移动设备函数

    /// <summary>
    /// 得到当前网站的根地址
    /// </summary>
    /// <returns></returns>
    /// <summary>

    public static string GetCurrentSiteRootPath()
    {
        var context = HttpContext.Current;

        if (context != null)
        {
            var request = context.Request;
            var uri = request.Url;

            string scheme = request.Headers["X-Forwarded-Proto"] ?? uri.Scheme;
            string host = request.Headers["X-Forwarded-Host"] ?? uri.Host;

            int port = 0;
            int fp;

            var forwardedPort = request.Headers["X-Forwarded-Port"];
            if (!string.IsNullOrEmpty(forwardedPort) && int.TryParse(forwardedPort, out fp))
            {
                port = fp;
            }
            else
            {
                var hostHeader = request.Headers["Host"];
                if (!string.IsNullOrEmpty(hostHeader))
                {
                    int colonIdx = hostHeader.LastIndexOf(':');
                    if (colonIdx > 0 && int.TryParse(hostHeader.Substring(colonIdx + 1), out fp))
                        port = fp;
                }
            }

            if (port == 0)
                port = uri.Port;

            string url = $"{scheme}://{host}:{port}{request.ApplicationPath}";

            if (!url.EndsWith("/"))
                url += "/";
            return url;
        }
        else
        {
            return GetSiteUrlForTimerSimple();
        }
    }

    private static string GetSiteUrlForTimerSimple()
    {
        try
        {
            // 方法1：从缓存中获取（首次请求时设置）
            if (HttpRuntime.Cache["SiteBaseUrl"] != null)
            {
                return HttpRuntime.Cache["SiteBaseUrl"].ToString();
            }

            // 方法2：从web.config读取
            string siteUrl = ConfigurationManager.AppSettings["SiteBaseUrl"];
            if (!string.IsNullOrEmpty(siteUrl))
            {
                if (!siteUrl.EndsWith("/"))
                    siteUrl += "/";

                // 缓存起来
                HttpRuntime.Cache.Insert("SiteBaseUrl", siteUrl, null,
                    DateTime.Now.AddHours(24), Cache.NoSlidingExpiration);

                return siteUrl;
            }

            // 方法3：动态构建（适用于大多数场景）
            string appVirtualPath = HttpRuntime.AppDomainAppVirtualPath ?? "";
            string machineName = Environment.MachineName.ToLower();

            // 如果是本地环境
            if (machineName.Contains("localhost") ||
                machineName.Contains("dev") ||
                machineName.Contains("test") ||
                HttpRuntime.AppDomainAppPath.Contains("IIS Express"))
            {
                string port = ConfigurationManager.AppSettings["LocalPort"] ?? "80";
                string url = $"http://localhost:{port}{appVirtualPath}";
                if (!url.EndsWith("/"))
                    url += "/";
                return url;
            }
            else
            {
                // 生产环境
                string url = $"http://{machineName}{appVirtualPath}";
                if (!url.EndsWith("/"))
                    url += "/";
                return url;
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile($"获取定时器站点URL错误: {ex.Message}");
            return "http://localhost/"; // 默认值
        }
    }


    //得到当前网站的根地址,不包含站点名,
    public static string GetCurrentSiteRootPathNoSiteName()
    {
        // 是否为SSL认证站点
        string secure = HttpContext.Current.Request.ServerVariables["HTTPS"];
        string httpProtocol = (secure == "on" ? "https://" : "http://");
        // 服务器名称
        string serverName = HttpContext.Current.Request.ServerVariables["Server_Name"];
        string port = HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
        // 应用服务名称
        string applicationName = HttpContext.Current.Request.ApplicationPath;

        if (applicationName.Substring(applicationName.Length - 1, 1) != "/")
        {
            return httpProtocol + serverName + (port.Length > 0 ? ":" + port : string.Empty) + "/";
        }
        else
        {
            return httpProtocol + serverName + (port.Length > 0 ? ":" + port : string.Empty);
        }
    }

    // <summary>
    /// 获得浏览器类型字符 
    /// </summary>
    /// <param name="browser"></param>
    /// <returns>FF(Firfox) SF(Safari) OE(Opera) IE</returns>
    public static string GetBrowser(HttpBrowserCapabilities browser)
    {
        if (browser == null)
        {
            return "IE";
        }
        else if (browser.Browser.IndexOf("IE", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            return "IE";
        }
        if (browser.Browser.IndexOf("Firefox", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            return "FF";
        }
        else if (browser.Browser.IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            return "SF";
        }
        else if (browser.Browser.IndexOf("Opera", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            return "OE";
        }
        else if (browser.Browser.IndexOf("Chrome", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            return "CH";
        }
        else
        {
            return "IE";
        }
    }

    /// <summary>
    /// 根据 Agent 判断是否是智能手机
    /// </summary>
    /// <returns></returns>
    public static bool IsMobileDeviceCheckAgent()
    {
        //bool flag = false;
        string agent = HttpContext.Current.Request.UserAgent;
        string[] keywords = { "Android", "iPhone", "iPod", "iPad", "Windows Phone", "MQQBrowser" };

        //排除Window 桌面系统 和 苹果桌面系统
        if (!agent.Contains("Windows NT") && !agent.Contains("Macintosh"))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //判断是否是IOS设备
    public static bool isIOSDevice()
    {
        bool isIPhone = HttpContext.Current.Request.UserAgent.Contains("iPhone");
        bool isIPad = HttpContext.Current.Request.UserAgent.Contains("iPad");
        bool isIPod = HttpContext.Current.Request.UserAgent.Contains("iPod");

        if (isIPhone | isIPad | isIPod)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    /// 根据 Agent 判断是否是IOS设备
    ///
    ///
    public static bool CheckAgentIsIOSDevice()
    {
        bool flag = false;
        string agent = HttpContext.Current.Request.UserAgent;
        string[] keywords = { "iPhone", "iPod", "iPad" };
        //排除Window 桌面系统 和 苹果桌面系统
        if (!agent.Contains("Windows NT") && !agent.Contains("Macintosh"))
        {
            foreach (string item in keywords)
            {
                if (agent.Contains(item))
                {
                    flag = true;
                    break;
                }
            }
        }
        return flag;
    }

    //取得IP所在地址名
    public static string GetUserLocation(string userIP)
    {
        try
        {
            WebClient webGetting = new WebClient();
            //string userIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
            string ipQueryResult = webGetting.DownloadString("http://www.ip.cn/getip.php?action=queryip&ip_url=" + userIP);
            string startString = @"来自:";
            int startIndex = ipQueryResult.LastIndexOf(startString) + startString.Length;
            int endIndex = ipQueryResult.LastIndexOf(@" ", startIndex);
            return ipQueryResult.Substring(startIndex, ipQueryResult.Length - startIndex);
        }
        catch
        {
            return "";
        }
    }

    public static string GetUserLocation()
    {
        try
        {
            WebClient webGetting = new WebClient();
            string userIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
            string ipQueryResult = webGetting.DownloadString("http://www.ip.cn/getip.php?action=queryip&ip_url=" + userIP);
            string startString = @"来自:";
            int startIndex = ipQueryResult.LastIndexOf(startString) + startString.Length;
            int endIndex = ipQueryResult.LastIndexOf(@" ", startIndex);
            return ipQueryResult.Substring(startIndex, ipQueryResult.Length - startIndex);
        }
        catch
        {
            return string.Empty;
        }
    }

    public static string GetIPinArea(string strIP)//strIP为IP
    {
        string stringIpAddress = "";

        //string sURL = "http://www.youdao.com/smartresult-xml/search.s?type=ip&q=" + strIP + "";

        //try
        //{
        //    using (XmlReader read = XmlReader.Create(sURL))//获取返回的xml格式文件内容
        //    {
        //        while (read.Read())
        //        {
        //            switch (read.NodeType)
        //            {
        //                case XmlNodeType.Text://取xml格式文件当中的文本内容
        //                    if (string.Format("{0}", read.Value).ToString().Trim() != strIP)//youdao返回的xml格式文件内容一个是IP，另一个是IP地址
        //                    {
        //                        stringIpAddress = string.Format("{0}", read.Value).ToString().Trim();//赋值
        //                    }
        //                    break;
        //                //other
        //            }
        //        }
        //    }

        try
        {
            stringIpAddress = IpSearch.GetAddressWithIP(strIP);

            if (stringIpAddress == "")
            {
                return "内网:" + strIP;
            }
            else
            {
                return stringIpAddress.Trim();
            }
        }
        catch
        {
            return stringIpAddress.Trim();
        }
    }

    public static string GetMacAddress()
    {
        string clientIp = HttpContext.Current.Request.UserHostAddress;

        string mac = "";
        System.Diagnostics.Process process = new System.Diagnostics.Process();
        process.StartInfo.FileName = "nbtstat";
        process.StartInfo.Arguments = "-a " + clientIp;
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.CreateNoWindow = true;
        process.StartInfo.RedirectStandardOutput = true;
        process.Start();
        string output = process.StandardOutput.ReadToEnd();
        int length = output.IndexOf("MAC Address =");
        if (length > 0)
        {
            mac = output.Substring(length + 14, 17);
        }
        return mac;
    }

    /// <summary>
    /// 经纬度坐标
    /// </summary>
    public class Degree
    {
        public Degree(double x, double y)
        {
            X = x;
            Y = y;
        }

        private double x;

        public double X
        {
            get { return x; }
            set { x = value; }
        }

        private double y;

        public double Y
        {
            get { return y; }
            set { y = value; }
        }
    }

    public class CoordDispose
    {
        private const double EARTH_RADIUS = 6378137.0;//地球半径(米)

        /// <summary>
        /// 角度数转换为弧度公式
        /// </summary>
        /// <param name="d"></param>
        /// <returns></returns>
        private static double radians(double d)
        {
            return d * Math.PI / 180.0;
        }

        /// <summary>
        /// 弧度转换为角度数公式
        /// </summary>
        /// <param name="d"></param>
        /// <returns></returns>
        private static double degrees(double d)
        {
            return d * (180 / Math.PI);
        }

        /// <summary>
        /// 计算两个经纬度之间的直接距离
        /// </summary>
        public static double GetDistance(Degree Degree1, Degree Degree2)
        {
            double radLat1 = radians(Degree1.X);
            double radLat2 = radians(Degree2.X);
            double a = radLat1 - radLat2;
            double b = radians(Degree1.Y) - radians(Degree2.Y);
            double s = 2 * Math.Asin(Math.Sqrt(Math.Pow(Math.Sin(a / 2), 2) +
            Math.Cos(radLat1) * Math.Cos(radLat2) * Math.Pow(Math.Sin(b / 2), 2)));
            s = s * EARTH_RADIUS;
            s = Math.Round(s * 10000) / 10000;
            return s;
        }

        /// <summary>
        /// 计算两个经纬度之间的直接距离(google 算法)
        /// </summary>
        public static double GetDistanceGoogle(Degree Degree1, Degree Degree2)
        {
            double radLat1 = radians(Degree1.X);
            double radLng1 = radians(Degree1.Y);
            double radLat2 = radians(Degree2.X);
            double radLng2 = radians(Degree2.Y);
            double s = Math.Acos(Math.Cos(radLat1) * Math.Cos(radLat2) * Math.Cos(radLng1 - radLng2) + Math.Sin(radLat1) * Math.Sin(radLat2));
            s = s * EARTH_RADIUS;
            s = Math.Round(s * 10000) / 10000;
            return s;
        }

        /// <summary>
        /// 以一个经纬度为中心计算出四个顶点
        /// </summary>
        /// <param name="distance">半径(米)</param>
        /// <returns></returns>
        public static Degree[] GetDegreeCoordinates(Degree Degree1, double distance)
        {
            double dlng = 2 * Math.Asin(Math.Sin(distance / (2 * EARTH_RADIUS)) / Math.Cos(Degree1.X));
            dlng = degrees(dlng);//一定转换成角度数  原PHP文章这个地方说的不清楚根本不正确 后来lz又查了很多资料终于搞定了
            double dlat = distance / EARTH_RADIUS;
            dlat = degrees(dlat);//一定转换成角度数
            return new Degree[] { new Degree(Math.Round(Degree1.X + dlat,6), Math.Round(Degree1.Y - dlng,6)),//left-top
                                  new Degree(Math.Round(Degree1.X - dlat,6), Math.Round(Degree1.Y - dlng,6)),//left-bottom
                                  new Degree(Math.Round(Degree1.X + dlat,6), Math.Round(Degree1.Y + dlng,6)),//right-top
                                  new Degree(Math.Round(Degree1.X - dlat,6), Math.Round(Degree1.Y + dlng,6)) //right-bottom
            };
        }

        /// <summary>
        /// 测试方法
        /// </summary>
        private static void Main(string[] args)
        {
            double a = CoordDispose.GetDistance(new Degree(116.412007, 39.947545), new Degree(116.412924, 39.947918));//116.416984,39.944959
            double b = CoordDispose.GetDistanceGoogle(new Degree(116.412007, 39.947545), new Degree(116.412924, 39.947918));
            Degree[] dd = CoordDispose.GetDegreeCoordinates(new Degree(116.412007, 39.947545), 102);
            Console.WriteLine(a + " " + b);
            Console.WriteLine(dd[0].X + "," + dd[0].Y);
            Console.WriteLine(dd[3].X + "," + dd[3].Y);
            Console.ReadLine();
        }
    }

    public static string GetUserRuleAddressLongitudeByLeader(string strUserCode, string strLeaderCode)
    {
        string strHQL;
        DataSet ds;

        string strLongitude;

        strHQL = "Select OfficeLongitude From T_UserAttendanceRule Where UserCode = '" + strUserCode + "' and LeaderCode = '" + strLeaderCode + "'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserAttendanceRule");

        strLongitude = ds.Tables[0].Rows[0][0].ToString().Trim();

        if (strLongitude == "")
        {
            return "0";
        }
        else
        {
            return strLongitude;
        }
    }

    public static string GetUserRuleAddressLatitudeByLeader(string strUserCode, string strLeaderCode)
    {
        string strHQL;
        DataSet ds;

        string strLatitude;

        strHQL = "Select OfficeLatitude From T_UserAttendanceRule Where UserCode = '" + strUserCode + "' and LeaderCode = '" + strLeaderCode + "'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserAttendanceRule");

        strLatitude = ds.Tables[0].Rows[0][0].ToString().Trim();

        if (strLatitude == "")
        {
            return "0";
        }
        else
        {
            return strLatitude;
        }
    }

    public static string GetUserDepartmentAddressLongitude(string strUserCode)
    {
        string strHQL;
        DataSet ds;

        string strDepartCode, strLongitude;

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "Select Longitude From T_Department Where DepartCode = " + "'" + strDepartCode + "'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

        strLongitude = ds.Tables[0].Rows[0][0].ToString().Trim();

        if (strLongitude == "")
        {
            strHQL = "Select Longitude From T_Department Where IsDefaultAddress = 'YES'";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

            if (ds.Tables[0].Rows.Count > 0)
            {
                strLongitude = ds.Tables[0].Rows[0][0].ToString().Trim();

                if (strLongitude == "")
                {
                    return "0";
                }
                else
                {
                    return strLongitude;
                }
            }
            else
            {
                return "0";
            }
        }
        else
        {
            return strLongitude;
        }
    }

    public static string GetUserDepartmentAddressLatitude(string strUserCode)
    {
        string strHQL;
        DataSet ds;

        string strDepartCode, strLatitude;

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "Select Latitude From T_Department Where DepartCode = " + "'" + strDepartCode + "'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

        strLatitude = ds.Tables[0].Rows[0][0].ToString().Trim();

        if (strLatitude == "")
        {
            strHQL = "Select Latitude From T_Department Where IsDefaultAddress = 'YES'";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

            if (ds.Tables[0].Rows.Count > 0)
            {
                strLatitude = ds.Tables[0].Rows[0][0].ToString().Trim();

                if (strLatitude == "")
                {
                    return "0";
                }
                else
                {
                    return strLatitude;
                }
            }
            else
            {
                return "0";
            }
        }
        else
        {
            return strLatitude;
        }
    }

    #endregion IP、MAC地址和移动设备函数

}
