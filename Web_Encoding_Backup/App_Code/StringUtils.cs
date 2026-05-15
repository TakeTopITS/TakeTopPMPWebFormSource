using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

/// <summary>
/// Summary description for StringUtils
/// </summary>
public static class StringUtils
{
    /// <summary>
    /// 计算中文字符串长度
    /// </summary>
    /// <param name="cnstr"></param>
    /// <returns></returns>
    public static int CnLength(string cnstr)
    {
        byte[] bs = Encoding.ASCII.GetBytes(cnstr);

        int len = 0;  									//len为字符串之实际长度
        for (int i = 0; i <= bs.Length - 1; i++)
        {
            if (bs[i] == 63)							//判断是否为汉字或全脚符号
            {
                len++;
            }
            len++;
        }

        return len;
    }

    /// <summary>
    /// 累加字符串
    /// </summary>
    /// <param name="str"></param>
    /// <param name="times"></param>
    /// <returns></returns>
    public static string Repeat(string str, int times)
    {
        StringBuilder sb = new StringBuilder(str.Length * times);
        for (int i = 0; i < times; i++)
        {
            sb.Append(str);
        }
        return sb.ToString();
    }

    /// <summary>
    /// 验证input是否在以separator分隔的序列sequence中
    /// </summary>
    /// <param name="sequence"></param>
    /// <param name="separator"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    public static bool IsInSequence(string sequence, char separator, string input)
    {
        string[] ss = sequence.Split(separator);
        bool isInSequence = false;
        for (int i = 0, count = ss.Length; i < count; i++)
        {
            if (input == ss[i])
            {
                isInSequence = true;
                break;
            }
        }
        return isInSequence;
    }

    /// <summary>
    /// 拆分字符串
    /// </summary>
    /// <param name="s"></param>
    /// <param name="separator"></param>
    /// <returns></returns>
    public static string[] Split(string s, string separator)
    {
        return System.Text.RegularExpressions.Regex.Split(s, separator);
    }

    /// <summary>
    /// 截断并补齐字符串
    /// </summary>
    /// <param name="s"></param>
    /// <param name="maxlength"></param>
    /// <param name="placeholder"></param>
    /// <returns></returns>
    public static string Truncate(string s, int maxlength, string placeholder)
    {
        if (String.IsNullOrEmpty(s) || s.Length <= maxlength)
        {
            return s;
        }

        return s.Substring(0, maxlength) + placeholder;
    }

    #region Join

    public static string Join(IList<string> list)
    {
        return Join(list, String.Empty, String.Empty, String.Empty);
    }

    public static string Join(IList<string> list, string perfix, string postfix, string separator)
    {
        StringBuilder sb = new StringBuilder();
        int count = list.Count;
        for (int i = 0; i < count; i++)
        {
            sb.Append(perfix);
            sb.Append(list[i]);
            sb.Append(postfix);
            sb.Append(separator);
        }
        if (count > 0)
        {
            sb.Length -= separator.Length;
        }
        return sb.ToString();
    }

    public static string Join(string[] arr, string perfix, string postfix, string separator)
    {
        if (null == arr) throw new ArgumentNullException("arr", "array should not be null");

        int count = arr.Length;
        if (count > 0)
        {
            perfix = (null == perfix) ? "" : perfix;
            postfix = (null == postfix) ? "" : postfix;
            separator = (null == separator) ? "" : separator;
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < count; i++)
            {
                sb.Append(perfix);
                sb.Append(arr[i]);
                sb.Append(postfix);
                sb.Append(separator);
            }
            sb.Length -= separator.Length;
            return sb.ToString();
        }
        else
        {
            return "";
        }
    }

    public static string Join(string[] arr, string separator)
    {
        if (null == arr || arr.Length == 0) return String.Empty;

        if (arr.Length >= 10)
        {
            return JoinByStringBuilder(arr, separator);
        }
        else
        {
            return JoinByString(arr, separator);
        }
    }

    public static string JoinByStringBuilder(string[] arr, string separator)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.Length; i++)
        {
            sb.Append(arr[i]);
            sb.Append(separator);
        }
        sb.Length = sb.Length - separator.Length;
        return sb.ToString();
    }

    public static string JoinByString(string[] arr, string separator)
    {
        string result = "";
        int len = arr.Length;
        for (int i = 0, icount = len - 2; i <= icount; i++)
        {
            result += arr[i] + separator;
        }
        result += arr[len - 1];
        return result;
    }

    #endregion Join

    #region Align

    /// <summary>
    /// 向左对齐
    /// </summary>
    /// <param name="s"></param>
    /// <param name="length"></param>
    /// <param name="placeholder"></param>
    /// <returns></returns>
    public static string AlignLeft(string s, int length, char placeholder)
    {
        return Align(s, length, placeholder, true);
    }

    /// <summary>
    /// 向右对齐
    /// </summary>
    /// <param name="s"></param>
    /// <param name="length"></param>
    /// <param name="placeholder"></param>
    /// <returns></returns>
    public static string AlignRight(string s, int length, char placeholder)
    {
        return Align(s, length, placeholder, false);
    }

    private static string Align(string s, int length, char placeholder, bool isAlignLeft)
    {
        if (null == s || length <= s.Length) return s;

        int lengthOfPlaceholders = length - s.Length;
        char[] cc = new char[lengthOfPlaceholders];
        for (int i = 0; i < lengthOfPlaceholders; i++)
        {
            cc[i] = placeholder;
        }

        string retVal = isAlignLeft ? (new string(cc) + s) : (s + new string(cc));
        return retVal;
    }

    #endregion Align

    /// <summary>
    /// 获得最后一个匹配项后的字符串
    /// </summary>
    /// <param name="s"></param>
    /// <param name="separator"></param>
    /// <returns></returns>
    public static string GetSplitAfterStr(string s, string separator)
    {
        if (String.IsNullOrEmpty(s))
        {
            return s;
        }
        return s.Substring(s.LastIndexOf(separator) + 1);
    }

    /// <summary>
    /// 替换html中的特殊字符
    /// </summary>
    /// <param name="inputString"></param>
    /// <returns></returns>
    public static string HtmlEncode(object inputString)
    {
        string retVal = inputString.ToString();
        retVal = retVal.Replace("&", "&amp;");
        retVal = retVal.Replace("\"", "&quot;");
        retVal = retVal.Replace("'", "&quot;");
        retVal = retVal.Replace("<", "&lt;");
        retVal = retVal.Replace(">", "&gt;");
        retVal = retVal.Replace(" ", "");
        retVal = retVal.Replace("  ", "");
        retVal = retVal.Replace("\t", "");
        retVal = retVal.Replace("\r\n", "<br/>");
        return retVal;
    }

    /// <summary>
    /// 恢复html中的特殊字符
    /// </summary>
    /// <param name="inputString"></param>
    /// <returns></returns>
    public static string HtmlDecode(object inputString)
    {
        string retVal = inputString.ToString();
        retVal = retVal.Replace("&amp;", "&");
        retVal = retVal.Replace("&quot;", "\"");
        retVal = retVal.Replace("&quot;", "'");
        retVal = retVal.Replace("&lt;", "<");
        retVal = retVal.Replace("&gt;", ">");
        retVal = retVal.Replace("", " ");
        retVal = retVal.Replace("", "  ");
        retVal = retVal.Replace("", "\t");
        retVal = retVal.Replace("<br/>", "\r\n");
        return retVal;
    }

    /// <summary>
    /// 把数字转换成中文数字
    /// </summary>
    /// <param name="num"></param>
    /// <returns></returns>
    public static string ConventToChs(int num)
    {
        string numstr = num.ToString();
        string result = string.Empty;
        for (int i = 0; i < numstr.Length; i++)
        {
            switch (numstr[i])
            {
                case '0':
                    result = result + "零"; 
                    break;

                case '1':
                    result = result + "一"; 
                    break;

                case '2':
                    result = result + "二"; 
                    break;

                case '3':
                    result = result + "三"; 
                    break;

                case '4':
                    result = result + "四"; 
                    break;

                case '5':
                    result = result + "五"; 
                    break;

                case '6':
                    result = result + "六"; 
                    break;

                case '7':
                    result = result + "七"; 
                    break;

                case '8':
                    result = result + "八"; 
                    break;

                case '9':
                    result = result + "九"; 
                    break;
            }
        }
        return result;
    }

    //替换字符串
    public static void ReplaceString(string strReportFile, string strOldString, string strNewString)
    {
        //防止文本字符中有特殊字符，必须用Encoding.UTF8
        StreamReader reader = new StreamReader(@strReportFile, Encoding.UTF8);

        String a = reader.ReadToEnd();
        //将a.hhp文件中bb替换为cc。
        //a = a.Replace(">Trial<", "><");

        a = a.Replace(strOldString, strNewString);

        //防止文本字符中有特殊字符，必须用Encoding.UTF8
        StreamWriter readTxt = new StreamWriter(@strReportFile + "1", false, Encoding.UTF8);
        readTxt.Write(a);
        readTxt.Flush();
        readTxt.Close();
        reader.Close();

        File.Copy(@strReportFile + "1", @strReportFile, true);
        File.Delete(@strReportFile + "1");
    }

}
