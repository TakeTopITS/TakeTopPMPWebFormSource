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
/// ShareClass partial - CustomForm
/// </summary>
public static partial class ShareClass
{
    
    #region 数据表和自定义表单的功能

    //加上关联RelatedID,RelatedType,RelatedCode TODO:CAOJIAN(曹健)

    /// <summary>
    ///  全部为数字
    /// </summary>
    public static bool CheckIsAllNumber(string strValue)
    {
        bool IsBool = false;
        Regex rex = new Regex(@"^[0-9]+$");
        Match ma = rex.Match(strValue);
        if (ma.Success)
        {
            IsBool = true;
            //都为数字
        }
        return IsBool;
    }

    //将DataSet转换为xml对象字符串
    public static string ConvertDataSetToXML(DataSet xmlDS)
    {
        MemoryStream stream = null;
        XmlTextWriter writer = null;

        try
        {
            stream = new MemoryStream();
            //从stream装载到XmlTextReader
            writer = new XmlTextWriter(stream, Encoding.Unicode);

            //用WriteXml方法写入文件.
            xmlDS.WriteXml(writer);
            int count = (int)stream.Length;
            byte[] arr = new byte[count];
            stream.Seek(0, SeekOrigin.Begin);
            stream.Read(arr, 0, count);

            UnicodeEncoding utf = new UnicodeEncoding();
            return utf.GetString(arr).Trim();
        }
        catch (System.Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (writer != null)
                writer.Close();
        }
    }

    //将xml对象内容字符串转换为DataSet
    public static DataSet ConvertXMLToDataSet(string xmlData)
    {
        StringReader stream = null;
        XmlTextReader reader = null;
        try
        {
            DataSet xmlDS = new DataSet();
            stream = new StringReader(xmlData);
            //从stream装载到XmlTextReader
            reader = new XmlTextReader(stream);
            xmlDS.ReadXml(reader);
            return xmlDS;
        }
        catch (System.Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (reader != null)
                reader.Close();
        }
    }

    /// <summary>
    /// 写XML到文件夹中
    /// </summary>
    /// <param name="xml">xml字符串</param>
    /// <param name="filePath">路径</param>
    /// <returns></returns>
    private static void InsertXML(string xml, string filePath)
    {
        try
        {
            string strXML = xml;

            FileStream fs = new System.IO.FileStream(filePath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.ReadWrite);
            StreamWriter sw = new System.IO.StreamWriter(fs);
            sw.WriteLine(strXML);
            sw.Flush();
            sw.Close();
            fs.Close();
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    /// <summary>
    ///  读取XML文件
    /// </summary>
    /// <param name="filePath">路径</param>
    /// <returns></returns>
    public static string ReadXML(string filePath)
    {
        XmlDocument xx = new XmlDocument();
        xx.Load(filePath);
        return xx.OuterXml;
    }

    /// <summary>
    ///  检查数据库备份时间是否超时
    /// </summary>
    public static string CheckBackDBOverTime()
    {
        string strResult = string.Empty;
        string strBackDBHQL = "select (now()::date - ((select BackTime from T_BackDBLog order by BackTime desc limit 1)+BackPeriodDay * interval '1 day')::date) as DayPeriod from T_BackDBPrame";
        DataTable dtBackDB = ShareClass.GetDataSetFromSql(strBackDBHQL, "strBackDBHQL").Tables[0];
        if (dtBackDB != null && dtBackDB.Rows.Count > 0)
        {
            int intDay = 0;
            int.TryParse(dtBackDB.Rows[0]["DayPeriod"] == DBNull.Value ? "0" : dtBackDB.Rows[0]["DayPeriod"].ToString(), out intDay);
            if (intDay > 0)
            {
                strResult = "The backup interval time has arrived, a backup needs to be done again!";
            }
            else
            {
                strResult = "The backup interval time has not been reached!";
            }
        }
        return strResult;
    }

    /// <summary>
    ///  验证是否为数字
    /// </summary>
    public static bool CheckIsNumber(string strValue)
    {
        bool IsBool = false;
        System.Text.RegularExpressions.Regex reg1 = new System.Text.RegularExpressions.Regex(@"^[-]?\d+[.]?\d*$");

        if (reg1.IsMatch(strValue))
        {
            IsBool = true;
        }
        return IsBool;
    }

    /// <summary>
    /// object型转换为string型
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string ObjectToString(object value)
    {
        return ObjectToString(value, String.Empty);
    }

    /// <summary>
    /// object型转换为string型
    /// </summary>
    /// <param name="value"></param>
    /// <param name="defaultValue"></param>
    /// <returns></returns>
    public static string ObjectToString(object value, string defaultValue)
    {
        return (null == value || value == DBNull.Value) ? defaultValue : value.ToString();
    }

    //判断非法字符
    public static bool CheckStringRight(string str_char)
    {
        if (str_char.IndexOf("'") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("!") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("delete") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("and") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("update") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("insert") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf(";") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("master") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("mid") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("user") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("db_name") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("backup") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("select") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("char") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("nchar") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("xp_cmdshell") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf(",") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("--") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("exec") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("from") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("update") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("count") >= 0)
        {
            return false;
        }
        else if (str_char.IndexOf("\"") >= 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    //物资系统通用功能
    public static void UpdateXLCodeStatus(string strXLCode)
    {
        string strUpdateXLCodeHQL = "update T_WZMaterialXL set IsMark = -1 where XLCode = '" + strXLCode + "'";
        ShareClass.RunSqlCommand(strUpdateXLCodeHQL);
    }

    //把符合条件的日期设为空
    public static string SetDateStringToEmpty(string strDateString)
    {
        if (strDateString.IndexOf("0001") >= 0)
        {
            return "";
        }
        else
        {
            return strDateString;
        }
    }

    //截取相应的字数
    public static string StringCutByRequire(string strString, int intShowCount)
    {
        string strResult = string.Empty;
        if (string.IsNullOrEmpty(strString))
        {
            strResult = "";
        }
        else
        {
            if (strString.Length <= intShowCount)
            {
                strResult = strString;
            }
            else
            {
                strResult = strString.Substring(0, intShowCount) + "...";
            }
        }
        return strResult;
    }

    public static string StringToDateTime(string strString, string strFormat)
    {
        string strResult = string.Empty;
        if (string.IsNullOrEmpty(strString))
        {
            strResult = "";
        }
        else
        {
            try
            {
                strResult = DateTime.Parse(strString).ToString(strFormat);
            }
            catch
            {
                return strString;
            }
        }

        return strResult;
    }

    //取得当月开始日期
    public static DateTime getCurrentMonthStartDay()
    {
        DateTime dt = DateTime.Now;
        //本月第一天时间      
        DateTime dt_First = dt.AddDays(1 - (dt.Day));
        //获得某年某月的天数    
        int year = dt.Date.Year;
        int month = dt.Date.Month;
        int dayCount = DateTime.DaysInMonth(year, month);
        //本月最后一天时间    
        DateTime dt_Last = dt_First.AddDays(dayCount - 1);

        return dt_First;
    }

    //取得当月结束日期
    public static DateTime getCurrentMonthEndDay()
    {
        DateTime dt = DateTime.Now;
        //本月第一天时间      
        DateTime dt_First = dt.AddDays(1 - (dt.Day));
        //获得某年某月的天数    
        int year = dt.Date.Year;
        int month = dt.Date.Month;
        int dayCount = DateTime.DaysInMonth(year, month);
        //本月最后一天时间    
        DateTime dt_Last = dt_First.AddDays(dayCount - 1);

        return dt_Last;
    }

    //填充年月和月份方便用户选择
    public static void InitYearMonthList(DropDownList DDL_YearList, DropDownList DDL_MonthList)
    {
        //年份
        DateTime dt = DateTime.Now;
        for (int i = dt.Year - 15; i < dt.Year + 85; i++)
        {
            DDL_YearList.Items.Add(new ListItem(i.ToString()));
        }
        DDL_YearList.SelectedValue = dt.Year.ToString();
        //月份
        for (int i = 1; i <= 12; i++)
        {
            DDL_MonthList.Items.Add(new ListItem(i.ToString()));
        }
        DDL_MonthList.SelectedValue = dt.Month.ToString();
    }

    //获取年份字符串（201601表示2016年1月）
    public static string GetYearMonthString(DropDownList DDL_YearList, DropDownList DDL_MonthList)
    {
        int month = Convert.ToInt32(DDL_MonthList.Text);
        string str = string.Format("{0:D2}", month);

        return DDL_YearList.Text + str;
    }

    //判断收入的字符串是否合法
    public static bool IsValidYearMonth(string ymstr)
    {
        if (ymstr.Trim().Length != 6)
            return false;

        if (false == ShareClass.CheckIsAllNumber(ymstr))
            return false;

        int year = Convert.ToInt32(ymstr.Substring(0, 4));
        int month = Convert.ToInt32(ymstr.Substring(4, 2));

        if (year < 1900 || year > 9999)
            return false;

        if (month < 1 || month > 12)
            return false;

        return true;
    }

    //// <summary>

    /// 人民币大小写金额转换
    /// </summary>
    public static class RMBCapitalization
    {
        private const string DXSZ = "零壹贰叁肆伍陆柒捌玖";
        private const string DXDW = "毫厘分角元拾佰仟萬拾佰仟亿拾佰仟萬兆拾佰仟萬亿京拾佰仟萬亿兆垓";
        private const string SCDW = "元拾佰仟萬亿京兆垓";

        /// <summary>
        /// 转换整数为大写金额
        /// 最高精度为垓，保留小数点后4位，实际精度为亿兆已经足够了，理论上精度无限制，如下所示:
        /// 序号:...30.29.28.27.26.25.24  23.22.21.20.19.18  17.16.15.14.13  12.11.10.9   8 7.6.5.4  . 3.2.1.0
        /// 单位:...垓兆亿萬仟佰拾        京亿萬仟佰拾       兆萬仟佰拾      亿仟佰拾     萬仟佰拾元 . 角分厘毫
        /// 数值:...1000000               000000             00000           0000         00000      . 0000
        /// 下面列出网上搜索到的数词单位:
        /// 元、十、百、千、万、亿、兆、京、垓、秭、穰、沟、涧、正、载、极
        /// </summary>
        /// <param name="capValue">整数值</param>
        /// <returns>返回大写金额</returns>
        public static string ConvertIntToUppercaseAmount(string capValue)
        {
            string currCap = "";    //当前金额
            string capResult = "";  //结果金额
            string currentUnit = "";//当前单位
            string resultUnit = ""; //结果单位
            int prevChar = -1;      //上一位的值
            int currChar = 0;       //当前位的值
            int posIndex = 4;       //位置索引，从"元"开始

            if (Convert.ToDouble(capValue) == 0) return "";
            for (int i = capValue.Length - 1; i >= 0; i--)
            {
                currChar = Convert.ToInt16(capValue.Substring(i, 1));
                if (posIndex > 30)
                {
                    //已超出最大精度"垓"。注:可以将30改成22，使之精确到兆亿就足够了
                    break;
                }
                else if (currChar != 0)
                {
                    //当前位为非零值，则直接转换成大写金额
                    currCap = DXSZ.Substring(currChar, 1) + DXDW.Substring(posIndex, 1);
                }
                else
                {
                    //防止转换后出现多余的零,例如:3000020
                    switch (posIndex)
                    {
                        case 4: currCap = "元"; break;
                        case 8: currCap = "萬"; break;
                        case 12: currCap = "亿"; break;
                        case 17: currCap = "兆"; break;
                        case 23: currCap = "京"; break;
                        case 30: currCap = "垓"; break;
                        default: break;
                    }
                    if (prevChar != 0)
                    {
                        if (currCap != "")
                        {
                            if (currCap != "元") currCap += "零";
                        }
                        else
                        {
                            currCap = "零";
                        }
                    }
                }
                //对结果进行容错处理
                if (capResult.Length > 0)
                {
                    resultUnit = capResult.Substring(0, 1);
                    currentUnit = DXDW.Substring(posIndex, 1);
                    if (SCDW.IndexOf(resultUnit) > 0)
                    {
                        if (SCDW.IndexOf(currentUnit) > SCDW.IndexOf(resultUnit))
                        {
                            capResult = capResult.Substring(1);
                        }
                    }
                }
                capResult = currCap + capResult;
                prevChar = currChar;
                posIndex += 1;
                currCap = "";
            }
            return capResult;
        }

        /// <summary>
        /// 转换小数为大写金额
        /// </summary>
        /// <param name="capValue">小数值</param>
        /// <param name="addZero">是否增加零位</param>
        /// <returns>返回大写金额</returns>
        public static string ConvertDecToUppercaseAmount(string capValue, bool addZero)
        {
            string currCap = "";
            string capResult = "";
            int prevChar = addZero ? -1 : 0;
            int currChar = 0;
            int posIndex = 3;

            if (Convert.ToInt16(capValue) == 0) return "";
            for (int i = 0; i < capValue.Length; i++)
            {
                currChar = Convert.ToInt16(capValue.Substring(i, 1));
                if (currChar != 0)
                {
                    currCap = DXSZ.Substring(currChar, 1) + DXDW.Substring(posIndex, 1);
                }
                else
                {
                    if (Convert.ToInt16(capValue.Substring(i)) == 0)
                    {
                        break;
                    }
                    else if (prevChar != 0)
                    {
                        currCap = "零";
                    }
                }
                capResult += currCap;
                prevChar = currChar;
                posIndex -= 1;
                currCap = "";
            }
            return capResult;
        }

        /// <summary>
        /// 人民币大写金额
        /// </summary>
        /// <param name="value">人民币数字金额值</param>
        /// <returns>返回人民币大写金额</returns>
        public static string RMBAmount(double value)
        {
            string capResult = "";
            string capValue = string.Format("{0:f4}", value);       //格式化
            int dotPos = capValue.IndexOf(".");                     //小数点位置
            bool addInt = (Convert.ToInt32(capValue.Substring(dotPos + 1)) == 0);//是否在结果中加"整"
            bool addMinus = (capValue.Substring(0, 1) == "-");      //是否在结果中加"负"
            int beginPos = addMinus ? 1 : 0;                        //开始位置
            string capInt = capValue.Substring(beginPos, dotPos);   //整数
            string capDec = capValue.Substring(dotPos + 1);         //小数

            if (dotPos > 0)
            {
                capResult = ConvertIntToUppercaseAmount(capInt) +
                    ConvertDecToUppercaseAmount(capDec, Convert.ToDouble(capInt) != 0 ? true : false);
            }
            else
            {
                capResult = ConvertIntToUppercaseAmount(capDec);
            }
            if (addMinus) capResult = "负" + capResult;
            if (addInt) capResult += "整";
            return capResult;
        }
    }

    #endregion 数据表和自定义表单的功能

}
