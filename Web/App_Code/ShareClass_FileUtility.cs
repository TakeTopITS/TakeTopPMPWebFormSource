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
/// ShareClass partial - FileUtility
/// </summary>
public static partial class ShareClass
{
    
    #region 文件夹COPY、图片缩放、条码、二维码功能

    //插入文档类别
    public static void InsertDocType(string strType)
    {
        string strHQL;

        try
        {
            strHQL = string.Format("Select * From T_DocType Where Type = '{0}'", strType);
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DocType");
            if (ds.Tables[0].Rows.Count == 0)
            {
                strHQL = string.Format(@"Insert Into T_DocType (type, sortnumber, parentid, usercode, savetype) Values ('{0}',10,0,'{1}','Group')", strType, HttpContext.Current.Session["UserCode"].ToString());
                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + HttpContext.Current.Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //根据文档类别获取ID
    public static int getDocTypeIDByType(string strType)
    {
        string strHQL;
        try
        {
            strHQL = string.Format(@"Select ID From T_DocType Where Type = '{0}'", strType);
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DocType");
            if (ds.Tables[0].Rows.Count > 0)
            {
                return int.Parse(ds.Tables[0].Rows[0]["ID"].ToString());
            }
            else
            {
                return 0;
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + HttpContext.Current.Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            return 0;
        }
    }

    //复制文件夹
    //bool copy = CopyDirectory("c:\\temp\\index\\", "c:\\temp\\newindex\\", true);
    public static bool CopyDirectory(string SourcePath, string DestinationPath, bool overwriteexisting)
    {
        bool ret = false;
        try
        {
            SourcePath = SourcePath.EndsWith(@"\") ? SourcePath : SourcePath + @"\";
            DestinationPath = DestinationPath.EndsWith(@"\") ? DestinationPath : DestinationPath + @"\";

            if (Directory.Exists(SourcePath))
            {
                if (Directory.Exists(DestinationPath) == false)
                    Directory.CreateDirectory(DestinationPath);

                foreach (string fls in Directory.GetFiles(SourcePath))
                {
                    FileInfo flinfo = new FileInfo(fls);
                    flinfo.CopyTo(DestinationPath + flinfo.Name, overwriteexisting);
                }
                foreach (string drs in Directory.GetDirectories(SourcePath))
                {
                    DirectoryInfo drinfo = new DirectoryInfo(drs);
                    if (CopyDirectory(drs, DestinationPath + drinfo.Name, overwriteexisting) == false)
                        ret = false;
                }
            }
            ret = true;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            ret = false;
        }
        return ret;
    }



    //在文件上增加一行数据
    public static void AddSpaceLineToFile(string strFileName, string strString)
    {
        try
        {
            string path = HttpContext.Current.Server.MapPath(strFileName);//文件的路径，保证文件存在。
            FileStream fs = new FileStream(path, FileMode.Append);
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine(strString);
            sw.Close();
            fs.Close();
        }
        catch
        {
        }
    }

    //取得二维码图片文件URL
    public static string GetQRCodeURLByZXingNet(String strURL, int intWidth, int intHeight)
    {
        try
        {
            var writer = new BarcodeWriter { Format = BarcodeFormat.QR_CODE, Options = new QrCodeEncodingOptions { Height = 300, Width = 300, CharacterSet = "UTF-8" } };
            var qrCode = writer.Write(strURL);

            string strFileName = "BarCode" + DateTime.Now.ToString("yyyyMMddHHmmsssssfffffff") + ".gif";
            string strDocSavePath = HttpContext.Current.Server.MapPath("Doc") + "\\Bar\\";
            string strUrl = strDocSavePath + strFileName;

            if (Directory.Exists(strDocSavePath) == false)
            {
                //如果不存在就创建file文件夹{
                Directory.CreateDirectory(strDocSavePath);
            }

            qrCode.Save(strUrl, System.Drawing.Imaging.ImageFormat.Png);

            return "Doc/Bar/" + strFileName;
        }
        catch (Exception ex)
        {
            //异常输出
            return ex.Message.ToString();
        }
    }

    //条形码:BarCode, 二维码 不带图:NoLogoQrCode,带图:HaveLogoQrCode
    public static string ShowQrCodeForTaskAssignRecord(string strAssignID, int intWidth, int intHight)
    {
        string strHQL;
        string strQrCode;

        strHQL = "Select QrCode From T_TaskAssignRecord Where ID = " + strAssignID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

        strQrCode = ds.Tables[0].Rows[0][0].ToString().Trim();

        return ShareClass.GenerateQrCodeImage(ShareClass.GetBarType(), strQrCode, intWidth, intHight);
    }

    public static string GenerateQrCodeImage(string strBarType, string strQrCodeString, int intWidth, int intHight)
    {
        string strImageUrl;

        try
        {
            try
            {
                System.Drawing.Bitmap imgTemp;

                if (strBarType == "NoLogoQrCode")
                {
                    //不带图二维码
                    imgTemp = BarcodeHelper.GenerateNoLogoQrCode(strQrCodeString, intWidth, intHight);
                }
                else if (strBarType == "HaveLogoQrCode")
                {
                    //带图二维码
                    imgTemp = BarcodeHelper.GenerateHaveLogoQrCode(strQrCodeString, intWidth, intHight);
                }
                else if (strBarType == "BarCode")
                {
                    //条形码
                    imgTemp = BarcodeHelper.GenerateBarCode(strQrCodeString, 260, 50);
                }
                else
                {
                    return "";
                }

                ////带图二维码
                //System.Drawing.Bitmap imgTemp = BarcodeHelper.GenerateHaveLogoQrCode(strQrCodeString, 240, 240);

                string strFileName = strQrCodeString + "BarCode" + DateTime.Now.ToString("yyyyMMddHHmmsssssfffffff") + ".gif";
                string strDocSavePath = HttpContext.Current.Server.MapPath("Doc") + "\\Bar\\";
                string strUrl = strDocSavePath + strFileName;

                if (Directory.Exists(strDocSavePath) == false)
                {
                    //如果不存在就创建file文件夹{
                    Directory.CreateDirectory(strDocSavePath);
                }

                imgTemp.Save(strUrl, System.Drawing.Imaging.ImageFormat.Gif);

                strImageUrl = "Doc/Bar/" + strFileName;

                return strImageUrl;
            }
            catch
            {
                return "";
            }
        }
        catch
        {
            return "";
        }
    }

    public static string GetBarType()
    {
        string strHQL = "Select Type From T_BarType";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BarType");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "BarType";
        }
    }

    /// <summary>
    /// 图片缩放
    /// </summary>
    /// <param name="savePath">图片相对路径</param>
    /// <param name="fileName">图片名称</param>
    /// <param name="destWidth">缩放宽度</param>
    /// <param name="destHeight">高度</param>
    /// <param name="type">1--固定缩放；2--按比例缩放；3--指定宽度,宽度大于指定宽度按指定宽度进行等比缩放，小于指定宽度按原图大小上传；4--原图直接上传</param>
    /// <returns></returns>
    public static void ReducesPic(string savePath, string fileName, int destWidth, int destHeight, int type)
    {
        if (!fileName.Equals(""))
        {
            //string Allpath = System.Web.HttpContext.Current.Server.MapPath("/") + savePath;

            string Allpath = savePath;

            //生成原图
            System.IO.Stream stream = System.IO.File.OpenRead(Allpath + fileName);
            System.Drawing.Image oImage = System.Drawing.Image.FromStream(stream);
            stream.Close();
            stream.Dispose();

            System.Drawing.Image.GetThumbnailImageAbort callb = new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback);

            string fileType = fileName.Substring(fileName.LastIndexOf(".") + 1);
            int oWidth = oImage.Width;
            int oHeight = oImage.Height;

            int tWidth = destWidth; //设置缩略图初始宽度
            int tHeight = destHeight; //设置缩略图初始高度

            //按指定宽高缩放
            if (type == 1)
            {
                tWidth = destWidth;
                tHeight = destHeight;
            }
            //按比例计算出缩略图的宽度和高度
            else if (type == 2)
            {
                if (oWidth > tWidth || oHeight > tHeight)
                {
                    if (oWidth >= oHeight)
                    {
                        tHeight = (int)Math.Floor(Convert.ToDouble(oHeight) * (Convert.ToDouble(tWidth) / Convert.ToDouble(oWidth)));
                    }
                    else
                    {
                        tWidth = (int)Math.Floor(Convert.ToDouble(oWidth) * (Convert.ToDouble(tHeight) / Convert.ToDouble(oHeight)));
                    }
                }
                else
                {
                    tWidth = oWidth; //原图宽度
                    tHeight = oHeight; //原图高度
                }
            }
            //指定宽度,宽度大于指定宽度按指定宽度进行等比缩放，小于指定宽度按原图大小上传
            else if (type == 3)
            {
                if (oWidth >= tWidth)
                {
                    if (oWidth >= oHeight)
                    {
                        tHeight = (int)Math.Floor(Convert.ToDouble(oHeight) * (Convert.ToDouble(tWidth) / Convert.ToDouble(oWidth)));
                    }
                    else
                    {
                        tWidth = (int)Math.Floor(Convert.ToDouble(oWidth) * (Convert.ToDouble(tHeight) / Convert.ToDouble(oHeight)));
                    }
                }
                else
                {
                    tWidth = oWidth; //原图宽度
                    tHeight = oHeight; //原图高度
                }
            }
            else
            {
                tWidth = oWidth; //原图宽度
                tHeight = oHeight; //原图高度
            }
            //生成缩略原图
            oImage = oImage.GetThumbnailImage(tWidth, tHeight, callb, IntPtr.Zero);
            oImage.Save(Allpath + fileName);
        }
    }

    public static bool ThumbnailCallback()
    {
        return false;
    }

    /// <summary>
    /// 生成缩略图
    /// </summary>
    /// <param name="originalImagePath">源图路径（物理路径）</param>
    /// <param name="thumbnailPath">缩略图路径（物理路径）</param>
    /// <param name="width">缩略图宽度</param>
    /// <param name="height">缩略图高度</param>
    /// <param name="mode">生成缩略图的方式</param>
    public static void MakeThumbnail(string originalImagePath, string thumbnailPath, int width, int height, string mode)
    {
        System.Drawing.Image originalImage = System.Drawing.Image.FromFile(originalImagePath);
        int towidth = width;
        int toheight = height;
        int x = 0;
        int y = 0;
        int ow = originalImage.Width;
        int oh = originalImage.Height; switch (mode)
        {
            case "HW"://指定高宽缩放（可能变形）
                break;

            case "W"://指定宽，高按比例
                toheight = originalImage.Height * width / originalImage.Width;
                break;

            case "H"://指定高，宽按比例
                towidth = originalImage.Width * height / originalImage.Height;
                break;

            case "Cut"://指定高宽裁减（不变形）
                if ((double)originalImage.Width / (double)originalImage.Height > (double)towidth / (double)toheight)
                {
                    oh = originalImage.Height;
                    ow = originalImage.Height * towidth / toheight;
                    y = 0;
                    x = (originalImage.Width - ow) / 2;
                }
                else
                {
                    ow = originalImage.Width;
                    oh = originalImage.Width * height / towidth;
                    x = 0;
                    y = (originalImage.Height - oh) / 2;
                }
                break;

            default:
                break;
        } //新建一个bmp图片
        System.Drawing.Image bitmap = new System.Drawing.Bitmap(towidth, toheight); //新建一个画板
        System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap); //设置高质量插值法
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High; //设置高质量,低速度呈现平滑程度
        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality; //清空画布并以透明背景色填充
        g.Clear(System.Drawing.Color.Transparent); //在指定位置并且按指定大小绘制原图片的指定部分
        g.DrawImage(originalImage, new System.Drawing.Rectangle(0, 0, towidth, toheight),
        new System.Drawing.Rectangle(x, y, ow, oh),
        System.Drawing.GraphicsUnit.Pixel); try
        {
            //以jpg格式保存缩略图
            bitmap.Save(thumbnailPath, System.Drawing.Imaging.ImageFormat.Jpeg);
        }
        catch (Exception e)
        {
            throw e;
        }
        finally
        {
            originalImage.Dispose();
            bitmap.Dispose();
            g.Dispose();
        }
    }

    #endregion 文件夹COPY、图片缩放、条码、二维码功能

}
